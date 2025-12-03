import json
import os
import re
import numpy as np
from flask import Flask, render_template, request, redirect, url_for, abort, flash
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text, or_ 
from sqlalchemy import event 
from sqlalchemy.engine import Engine 
from functools import lru_cache 
from collections import defaultdict 
import click 

from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
from werkzeug.security import generate_password_hash, check_password_hash


from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity

app = Flask(__name__)

basedir = os.path.abspath(os.path.dirname(__file__))
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'heinlein.db')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = 'secret-key-change-me-in-production'

db = SQLAlchemy(app)

@event.listens_for(Engine, "connect")
def set_sqlite_pragma(dbapi_connection, connection_record):
    dbapi_connection.create_function("lower", 1, lambda s: s.lower() if s else None)

login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login' 

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(100), unique=True, nullable=False)
    password_hash = db.Column(db.String(200), nullable=False)

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

class Cycle(db.Model):
    __tablename__ = 'cycles'
    id = db.Column(db.Integer, primary_key=True)
    title_ru = db.Column(db.String(255), nullable=False)
    title_original = db.Column(db.String(255))
    description = db.Column(db.Text)
    works = db.relationship('Work', backref='cycle', lazy=True)

class Publisher(db.Model):
    __tablename__ = 'publishers'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=False)
    country = db.Column(db.String(100))
    city = db.Column(db.String(100))
    founded_year = db.Column(db.Integer)
    is_active = db.Column(db.Boolean)
    website = db.Column(db.String(255))
    works = db.relationship('Work', backref='publisher', lazy=True)

class Adaptation(db.Model):
    __tablename__ = 'adaptations'
    id = db.Column(db.Integer, primary_key=True)
    work_id = db.Column(db.Integer, db.ForeignKey('works.id'), nullable=False)
    title_ru = db.Column(db.String(255))
    title = db.Column(db.String(255), nullable=False)
    release_year = db.Column(db.Integer)
    type = db.Column(db.String(50))
    author = db.Column(db.String(255))
    imdb_rating = db.Column(db.Float)
    imdb_link = db.Column(db.String(255))

work_keywords = db.Table('work_keywords',
    db.Column('work_id', db.Integer, db.ForeignKey('works.id'), primary_key=True),
    db.Column('keyword_id', db.Integer, db.ForeignKey('keywords.id'), primary_key=True)
)

class Keyword(db.Model):
    __tablename__ = 'keywords'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), unique=True, nullable=False)

class Work(db.Model):
    __tablename__ = 'works'
    id = db.Column(db.Integer, primary_key=True)
    title_ru = db.Column(db.String(255), nullable=False)
    title_original = db.Column(db.String(255))
    publication_year = db.Column(db.Integer)
    work_type = db.Column(db.String(50)) 
    description = db.Column(db.Text)
    
    cycle_id = db.Column(db.Integer, db.ForeignKey('cycles.id'))
    cycle_order = db.Column(db.Float)
    publisher_id = db.Column(db.Integer, db.ForeignKey('publishers.id'))
    
    adaptations = db.relationship('Adaptation', backref='work', lazy=True)
    keywords = db.relationship('Keyword', secondary=work_keywords, lazy='subquery',
        backref=db.backref('works', lazy=True))

    vector_json = db.Column(db.Text, nullable=True)

    def get_text_for_embedding(self):
        parts = [
            self.title_ru,
            self.title_original or "",
            self.work_type,
            str(self.publication_year),
            self.cycle.title_ru if self.cycle else "",
            self.description or ""
        ]
        parts.extend([k.name for k in self.keywords])
        return " ".join(parts)


@lru_cache(maxsize=1)
def load_ml_model():
    try:
        model = SentenceTransformer('cointegrated/rubert-tiny2')
        return model
    except Exception as e:
        print(f"КРИТИЧЕСКАЯ ОШИБКА: Не удалось загрузить ML-модель: {e}")
        return None

@app.template_filter('stars')
def stars_filter(value):
    try:
        rating = int(value)
    except (ValueError, TypeError):
        rating = 0
    return "★" * rating + "☆" * (5 - rating)


@app.route('/')
def index():
    default_mode = request.args.get('mode', 'ml')
    return render_template('index.html', default_mode=default_mode)


@app.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('index'))
    
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        user = User.query.filter_by(username=username).first()
        
        if user and user.check_password(password):
            login_user(user)
            return redirect(request.args.get('next') or url_for('index'))
        else:
            flash('Неверный логин или пароль')
    
    return render_template('login.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('index'))


@app.route('/add', methods=['GET', 'POST'])
@login_required
def add_work():
    if request.method == 'POST':
        work = Work(
            title_ru=request.form['title_ru'],
            title_original=request.form['title_original'],
            publication_year=request.form.get('publication_year', type=int),
            work_type=request.form['work_type'],
            description=request.form['description'],
            cycle_id=request.form.get('cycle_id') or None,
            cycle_order=request.form.get('cycle_order') or None 
        )
        db.session.add(work)
        db.session.commit()
        
        model = load_ml_model()
        if model:
            text = work.get_text_for_embedding()
            vec = model.encode(text)
            work.vector_json = json.dumps(vec.tolist())
            db.session.commit()
            
        flash(f'Произведение "{work.title_ru}" успешно добавлено.', 'success')
        return redirect(url_for('work_detail', work_id=work.id))

    cycles = Cycle.query.order_by(Cycle.title_ru).all()
    return render_template('work_form.html', cycles=cycles, title="Добавить произведение")

@app.route('/edit/<int:work_id>', methods=['GET', 'POST'])
@login_required
def edit_work(work_id):
    work = Work.query.get_or_404(work_id)
    
    if request.method == 'POST':
        work.title_ru = request.form['title_ru']
        work.title_original = request.form['title_original']
        work.publication_year = request.form.get('publication_year', type=int)
        work.work_type = request.form['work_type']
        work.description = request.form['description']
        
        c_id = request.form.get('cycle_id')
        work.cycle_id = c_id if c_id and c_id != '' else None
        
        c_order = request.form.get('cycle_order')
        work.cycle_order = c_order if c_order and c_order != '' else None
        
        work.vector_json = None
        db.session.commit()
        
        model = load_ml_model()
        if model:
            text = work.get_text_for_embedding()
            vec = model.encode(text)
            work.vector_json = json.dumps(vec.tolist())
            db.session.commit()

        flash(f'Произведение "{work.title_ru}" успешно обновлено.', 'success')
        return redirect(url_for('work_detail', work_id=work.id))

    cycles = Cycle.query.order_by(Cycle.title_ru).all()
    return render_template('work_form.html', work=work, cycles=cycles, title="Редактировать произведение")

#здесь логика поисковика
@app.route('/search')
def search():
    query_text = request.args.get('q', '').strip()
    search_mode = request.args.get('mode', 'ml').lower() 
    threshold = 0.45 
    
    if not query_text:
        return redirect(url_for('index', mode=search_mode))

    current_model = load_ml_model() 
    results = []
    model_status = "ok"

    if search_mode == 'ml':
        works_with_vectors = Work.query.filter(Work.vector_json.isnot(None)).all()
        if current_model and works_with_vectors:
            try:
                query_vector = current_model.encode([query_text])[0]
                db_vectors = []
                valid_works = []
                for work in works_with_vectors:
                    try:
                        vec = json.loads(work.vector_json)
                        db_vectors.append(vec)
                        valid_works.append(work)
                    except: continue 
                
                if db_vectors:
                    scores = cosine_similarity([query_vector], db_vectors)[0]
                    for work, score in zip(valid_works, scores):
                        if score >= threshold: 
                            work.similarity_score = round(score * 100, 1)
                            results.append(work)
                    results.sort(key=lambda x: x.similarity_score, reverse=True)
            except Exception as e:
                model_status = "error"
        else:
             if not current_model: model_status = "error" 

    elif search_mode == 'sql':
        search_pattern = f"%{query_text}%"
        search_condition = or_(
            Work.title_ru.ilike(search_pattern),
            Work.title_original.ilike(search_pattern),
            Work.description.ilike(search_pattern),
            db.cast(Work.publication_year, db.String).ilike(search_pattern),
            Cycle.title_ru.ilike(search_pattern),
            Keyword.name.ilike(search_pattern)
        )
        
        results = Work.query.outerjoin(Cycle).outerjoin(work_keywords).outerjoin(Keyword).filter(search_condition).distinct().all()
        
        for r in results: r.similarity_score = 0 
        model_status = "ok"
    else:
        model_status = "unknown_mode"

    works_by_cycle = defaultdict(list)
    for r in results:
        r.cycle_title = r.cycle.title_ru if r.cycle else None 
        works_by_cycle[r.cycle_title].append(r)

    grouped_works = [
        {'cycle_title': title, 'works': works} 
        for title, works in works_by_cycle.items()
    ]
    grouped_works.sort(key=lambda x: (x['cycle_title'] is None, x['cycle_title'] or ''))

    return render_template('search_results.html', 
                           works=results, 
                           grouped_works=grouped_works,
                           query=query_text,
                           search_mode=search_mode,
                           model_status=model_status) 

@app.route('/work/<int:work_id>')
def work_detail(work_id):
    work = Work.query.get_or_404(work_id)
    keywords_list = [k.name for k in work.keywords]
    work.cover_url = f"https://placehold.co/300x450/34495e/ffffff?text={work.title_ru.replace(' ', '%20')}"
    return render_template('work_detail.html', work=work, keywords=keywords_list, adaptations=work.adaptations)

@app.route('/cycles')
def cycles():
    cycles_list = Cycle.query.order_by(Cycle.title_ru).all()
    return render_template('cycles.html', cycles=cycles_list)

# CLI КОМАНДЫ 

@app.cli.command("init-db")
def init_db_command():
    with app.app_context():
        db.create_all()
        print("База данных создана.")

@app.cli.command("create-admin")
@click.argument("username")
@click.argument("password")
def create_admin_command(username, password):
    """
    Создает администратора.
    ПЕРЕД ВСТАВКОЙ В БД, ЭТА КОМАНДА ВЫЗЫВАЕТ db.create_all() 
    чтобы гарантировать создание таблицы 'user'.
    Пример: flask create-admin admin 12345
    """
    with app.app_context():
        db.create_all() 
        
        if User.query.filter_by(username=username).first():
            print(f"Пользователь '{username}' уже существует.")
            return

        user = User(username=username)
        user.set_password(password)
        db.session.add(user)
        try:
            db.session.commit()
            print(f"Администратор '{username}' создан.")
        except Exception as e:
            db.session.rollback()
            print(f"Ошибка: {e}")

@app.cli.command("import-sql")
def import_sql_command():
    SQL_FILENAME = 'hein_db.sql'
    if not os.path.exists(SQL_FILENAME):
        print(f"Файл {SQL_FILENAME} не найден!")
        return
    print("Начинаем импорт из SQL...")
    with app.app_context():
        db.drop_all()
        db.create_all() 
        with open(SQL_FILENAME, 'r', encoding='utf-8') as f:
            content = f.read()
        content = content.replace("\\'", "''").replace('`', '"')
        inserts = re.findall(r"INSERT INTO.*?;", content, re.DOTALL)
        count = 0
        WORKS_COLUMNS = "(id, title_ru, title_original, publication_year, work_type, description, cycle_id, cycle_order, publisher_id)"
        with db.engine.connect() as connection:
            trans = connection.begin()
            try:
                for statement in inserts:
                    if re.search(r'INSERT INTO ("works"|works) VALUES', statement):
                        statement = re.sub(r'INSERT INTO ("works"|works) VALUES', f'INSERT INTO "works" {WORKS_COLUMNS} VALUES', statement)
                    connection.execute(text(statement))
                    count += 1
                trans.commit()
                print(f"Успешно выполнено {count} команд INSERT.")
            except Exception as e:
                trans.rollback()
                print(f"ОШИБКА при импорте: {e}")

@app.cli.command("generate-embeddings")
def generate_embeddings_command():
    model = load_ml_model() 
    if model is None: return
    works = Work.query.all()
    works_to_generate = [w for w in works if w.vector_json is None]
    if not works_to_generate:
        print("Векторы уже сгенерированы.")
        return
    print(f"Генерация векторов для {len(works_to_generate)} книг...")
    texts = [w.get_text_for_embedding() for w in works_to_generate]
    embeddings = model.encode(texts)
    for work, vec in zip(works_to_generate, embeddings):
        work.vector_json = json.dumps(vec.tolist())
    db.session.commit()
    print("Готово!")

def create_db_if_missing():
    db_path = os.path.join(basedir, 'heinlein.db')
    if not os.path.exists(db_path):
        with app.app_context():
            db.create_all()
            print(f"Автоматическая инициализация: файл {db_path} не найден. Таблицы созданы.")

if __name__ == '__main__':
    create_db_if_missing()
    app.run(debug=True)