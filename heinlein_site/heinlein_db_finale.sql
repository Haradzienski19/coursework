-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: newschema2
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `adaptations`
--

DROP TABLE IF EXISTS `adaptations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `adaptations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `work_id` int NOT NULL,
  `title_ru` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Название на русском',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `release_year` year DEFAULT NULL,
  `type` enum('Фильм','Сериал','Анимация','Радиопостановка') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `author` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Режиссер или создатель',
  `imdb_rating` decimal(3,1) DEFAULT NULL,
  `imdb_link` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Ссылка на страницу IMDB',
  PRIMARY KEY (`id`),
  KEY `work_id` (`work_id`),
  CONSTRAINT `adaptations_ibfk_1` FOREIGN KEY (`work_id`) REFERENCES `works` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adaptations`
--

LOCK TABLES `adaptations` WRITE;
/*!40000 ALTER TABLE `adaptations` DISABLE KEYS */;
INSERT INTO `adaptations` VALUES (1,21,'Звездный десант','Starship Troopers',1997,'Фильм','Пол Верховен',7.3,NULL),(2,18,'Кукловоды','The Puppet Masters',1994,'Фильм','Стюарт Орм',5.9,NULL),(3,61,'Патруль времени','Predestination',2014,'Фильм','Братья Спириг',7.4,NULL),(4,5,'Место назначения — Луна','Destination Moon',1950,'Фильм','Ирвинг Пичел',6.4,NULL);
/*!40000 ALTER TABLE `adaptations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collection_content`
--

DROP TABLE IF EXISTS `collection_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `collection_content` (
  `collection_id` int NOT NULL,
  `work_id` int NOT NULL,
  `page_number` int DEFAULT NULL,
  PRIMARY KEY (`collection_id`,`work_id`),
  KEY `work_id` (`work_id`),
  CONSTRAINT `collection_content_ibfk_1` FOREIGN KEY (`collection_id`) REFERENCES `collections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `collection_content_ibfk_2` FOREIGN KEY (`work_id`) REFERENCES `works` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collection_content`
--

LOCK TABLES `collection_content` WRITE;
/*!40000 ALTER TABLE `collection_content` DISABLE KEYS */;
/*!40000 ALTER TABLE `collection_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collections`
--

DROP TABLE IF EXISTS `collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `collections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `publication_year` year DEFAULT NULL,
  `isbn` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collections`
--

LOCK TABLES `collections` WRITE;
/*!40000 ALTER TABLE `collections` DISABLE KEYS */;
/*!40000 ALTER TABLE `collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cycles`
--

DROP TABLE IF EXISTS `cycles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cycles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title_ru` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title_original` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cycles`
--

LOCK TABLES `cycles` WRITE;
/*!40000 ALTER TABLE `cycles` DISABLE KEYS */;
INSERT INTO `cycles` VALUES (1,'История будущего','Future History',NULL),(2,'Подростковые романы','Heinlein juveniles',NULL),(3,'Мир как миф','World as Myth',NULL);
/*!40000 ALTER TABLE `cycles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `keywords`
--

DROP TABLE IF EXISTS `keywords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `keywords` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Например: Путешествия во времени, Марс',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `keywords`
--

LOCK TABLES `keywords` WRITE;
/*!40000 ALTER TABLE `keywords` DISABLE KEYS */;
INSERT INTO `keywords` VALUES (18,'Антиутопия'),(24,'Бессмертие'),(40,'Бизнес'),(45,'Бюрократия'),(6,'Взросление'),(5,'Военная фантастика'),(16,'Выживание'),(12,'Генетика'),(41,'Гражданство'),(44,'Дружба'),(26,'Индивидуализм'),(20,'Искусственный интеллект'),(50,'История'),(36,'Колонизация'),(27,'Компетентность'),(17,'Космоопера'),(30,'Космос'),(22,'Крионика'),(4,'Либертарианство'),(8,'Луна'),(7,'Марс'),(48,'Метафизика'),(35,'Милитаризм'),(31,'Мультивселенная'),(43,'Наука'),(29,'Парадокс'),(23,'Параллельные миры'),(3,'Политика'),(51,'Постапокалипсис'),(39,'Приключения'),(11,'Пришельцы'),(14,'Психология'),(2,'Путешествия во времени'),(34,'Рабство'),(42,'Расизм'),(13,'Революция'),(10,'Религия'),(19,'Сатира'),(9,'Сексуальность'),(33,'Семья'),(15,'Солипсизм'),(25,'Социальная фантастика'),(1,'Твердая НФ'),(53,'Телепатия'),(46,'Утопия'),(21,'Феминизм'),(38,'Философия'),(47,'Фэнтези'),(54,'Хоррор'),(37,'Шпионаж'),(28,'Экономика'),(49,'Эротика'),(32,'Этика');
/*!40000 ALTER TABLE `keywords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publishers`
--

DROP TABLE IF EXISTS `publishers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publishers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `country` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Штаб-квартира',
  `founded_year` int DEFAULT NULL COMMENT 'Год основания',
  `is_active` tinyint(1) DEFAULT '1' COMMENT 'Существует ли сейчас (1 - да, 0 - нет)',
  `website` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publishers`
--

LOCK TABLES `publishers` WRITE;
/*!40000 ALTER TABLE `publishers` DISABLE KEYS */;
INSERT INTO `publishers` VALUES (1,'G. P. Putnam\'s Sons','США','Нью-Йорк',1838,1,'https://www.penguinrandomhouse.com/publishers/gpputnamssons/'),(2,'Scribner\'s','США','Нью-Йорк',1846,1,'https://www.simonandschuster.com/publisher/scribner'),(3,'Astounding Science Fiction','США','Нью-Йорк',1930,0,NULL),(4,'The Magazine of Fantasy & Science Fiction','США','Нью-Йорк',1949,1,'https://www.sfsite.com/fsf/'),(5,'Doubleday','США','Нью-Йорк',1897,1,'https://knopfdoubleday.com/'),(6,'Argosy','США','Нью-Йорк',1882,0,NULL),(7,'Blue Book','США','Чикаго',1905,0,NULL),(8,'Gnome Press','США','Нью-Йорк',1948,0,NULL),(9,'Ballantine Books','США','Нью-Йорк',1952,1,'https://www.penguinrandomhouse.com/publishers/ballantine-books/');
/*!40000 ALTER TABLE `publishers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `work_keywords`
--

DROP TABLE IF EXISTS `work_keywords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_keywords` (
  `work_id` int NOT NULL,
  `keyword_id` int NOT NULL,
  PRIMARY KEY (`work_id`,`keyword_id`),
  KEY `keyword_id` (`keyword_id`),
  CONSTRAINT `work_keywords_ibfk_1` FOREIGN KEY (`work_id`) REFERENCES `works` (`id`) ON DELETE CASCADE,
  CONSTRAINT `work_keywords_ibfk_2` FOREIGN KEY (`keyword_id`) REFERENCES `keywords` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `work_keywords`
--

LOCK TABLES `work_keywords` WRITE;
/*!40000 ALTER TABLE `work_keywords` DISABLE KEYS */;
INSERT INTO `work_keywords` VALUES (16,2),(20,2),(23,2),(25,2),(28,2),(29,2),(33,2),(49,2),(60,2),(61,2),(18,3),(19,3),(21,3),(22,3),(23,3),(26,3),(26,4),(28,4),(6,5),(9,5),(19,5),(21,5),(42,5),(3,6),(5,6),(6,6),(7,6),(8,6),(9,6),(10,6),(11,6),(12,6),(13,6),(14,6),(15,6),(16,6),(17,6),(33,6),(35,6),(52,6),(7,7),(10,7),(17,7),(19,7),(22,7),(5,8),(26,8),(32,8),(38,8),(41,8),(44,8),(45,8),(2,10),(31,10),(18,11),(4,12),(57,15),(59,15),(20,22),(21,25),(22,25),(25,25),(26,25),(27,25),(23,26),(26,26),(28,26),(53,26),(8,27),(11,27),(26,27),(28,27),(30,27),(1,28),(26,28),(38,28),(60,29),(61,29),(28,31),(29,31),(32,31),(33,31),(3,33),(25,33),(6,35),(21,35),(15,37),(24,38),(34,38),(36,38),(37,38),(39,38),(40,38),(44,38),(45,38),(46,38),(47,38),(48,38),(50,38),(51,38),(54,38),(56,38),(58,38),(1,39),(2,39),(3,39),(4,39),(5,39),(6,39),(7,39),(8,39),(9,39),(10,39),(11,39),(12,39),(13,39),(14,39),(15,39),(16,39),(17,39),(18,39),(20,39),(24,39),(27,39),(29,39),(30,39),(31,39),(32,39),(34,39),(35,39),(36,39),(37,39),(38,39),(39,39),(40,39),(41,39),(42,39),(44,39),(45,39),(46,39),(47,39),(48,39),(49,39),(50,39),(51,39),(52,39),(53,39),(54,39),(55,39),(56,39),(57,39),(58,39),(59,39),(60,39),(61,39),(2,43),(4,43),(5,43),(6,43),(8,43),(11,43),(12,43),(13,43),(24,43),(30,43),(31,43),(34,43),(35,43),(36,43),(37,43),(39,43),(40,43),(41,43),(42,43),(44,43),(45,43),(46,43),(47,43),(48,43),(49,43),(50,43),(51,43),(52,43),(53,43),(54,43),(55,43),(56,43),(57,43),(58,43),(1,46),(27,46),(55,47),(14,53),(59,54);
/*!40000 ALTER TABLE `work_keywords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `works`
--

DROP TABLE IF EXISTS `works`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `works` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title_ru` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title_original` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `publication_year` year DEFAULT NULL,
  `work_type` enum('Роман','Повесть','Рассказ','Статья','Эссе') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `publisher_id` int DEFAULT NULL,
  `cycle_id` int DEFAULT NULL,
  `cycle_order` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `publisher_id` (`publisher_id`),
  KEY `cycle_id` (`cycle_id`),
  CONSTRAINT `works_ibfk_1` FOREIGN KEY (`publisher_id`) REFERENCES `publishers` (`id`) ON DELETE SET NULL,
  CONSTRAINT `works_ibfk_2` FOREIGN KEY (`cycle_id`) REFERENCES `cycles` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `works`
--

LOCK TABLES `works` WRITE;
/*!40000 ALTER TABLE `works` DISABLE KEYS */;
INSERT INTO `works` VALUES (1,'Нам, живущим','For Us, The Living',1939,'Роман','Человек из 1939 года погибает в автокатастрофе и просыпается в 2086 году в утопическом обществе. Роман исследует идеи социальной кредитной системы, экономики,自由 любви и политики, служа платформой для взглядов автора на идеальное будущее.',2,NULL,NULL),(2,'Шестая колонна','Sixth Column',1941,'Роман','США оккупированы паназиатскими захватчиками. Шесть выживших американских военных организуют сопротивление, используя передовую науку, замаскированную под религию, чтобы свергнуть оккупантов.',3,NULL,NULL),(3,'Дети Мафусаила','Methuselah\'s Children',1941,'Роман','Семьи Говарда — группа людей с долгой жизнью благодаря селекционному разведению. Преследуемые обществом, они угоняют космический корабль и бегут в космос в поисках новой родины.',3,1,NULL),(4,'Там, за гранью','Beyond This Horizon',1942,'Роман','В утопическом обществе с генной инженерией и дуэлями на пистолетах главный герой Гамильтон Феликс оказывается в центре заговора революционеров, недовольных скукой идеального мира.',3,NULL,NULL),(5,'Ракетный корабль «Галилео»','Rocket Ship Galileo',1947,'Роман','Трое подростков и их наставник строят в гараже атомную ракету. Несмотря на скептицизм окружающих, они отправляются на Луну, но обнаруживают, что она уже занята тайной базой беглых нацистов, готовящих удар по Земле.',2,2,NULL),(6,'Космический кадет','Space Cadet',1948,'Роман','История обучения Мэтта Додсона в элитном Межпланетном Патруле. Книга детально описывает тренировки, моральные дилеммы кадетов и их первое серьезное задание по разрешению конфликта на Венере.',2,2,NULL),(7,'Красная планета','Red Planet',1949,'Роман','Колонисты на Марсе вынуждены бороться с жесткой политикой Компании. Джим Марлоу и его инопланетный питомец Уиллис (шарообразное существо с фотографической памятью) оказываются в центре революции и контакта с древней марсианской цивилизацией.',2,2,NULL),(8,'Фермер в небе','Farmer in the Sky',1950,'Роман','Земля перенаселена, и семья Билла Лермера эмигрирует на Ганимед, спутник Юпитера. Им предстоит тяжелейшая работа по терраформированию ледяной глыбы в пригодный для жизни мир, борьба с природой и создание нового общества.',2,2,NULL),(9,'Между планетами','Between Planets',1951,'Роман','Дон Харви, подросток с Земли, оказывается в центре межпланетной войны между Землей и колониями на Венере и Марсе. Ему поручено доставить важное сообщение, полное приключений и интриг.',2,2,NULL),(10,'Космическое семейство Стоун','The Rolling Stones',1952,'Роман','Семья Стоун — эксцентричные лунные колонисты — покупает подержанный космический корабль и отправляется в тур по Солнечной системе, переживая комичные и опасные приключения.',2,2,NULL),(11,'Стармен Джонс','Starman Jones',1953,'Роман','Макс Джонс, фермерский парень с эйдетической памятью, сбегает с Земли и становится астронавигатором на звездолете. Ему приходится спасать корабль в гиперпространстве.',2,2,NULL),(12,'Звездный зверь','The Star Beast',1954,'Роман','Джон Томас Стюарт унаследовал инопланетного питомца Ламмокса, который оказывается принцессой чужой расы. Это приводит к дипломатическому кризису на Земле.',2,2,NULL),(13,'Тоннель в небе','Tunnel in the Sky',1955,'Роман','Студенты отправляются на незнакомую планету для сдачи финального экзамена по выживанию. Но когда связь с Землей обрывается, экзамен превращается в реальную борьбу за жизнь и построение цивилизации с нуля (своего рода «Повелитель мух» со счастливым концом).',2,2,NULL),(14,'Время для звезд','Time for the Stars',1956,'Роман','Близнецы Том и Пэт, обладающие телепатией, участвуют в межзвездной экспедиции. Один летит на корабле, другой остается на Земле, сталкиваясь с эффектами relativity.',2,2,NULL),(15,'Гражданин Галактики','Citizen of the Galaxy',1957,'Роман','Торби, мальчик-раб, купленный на невольничьем рынке старым нищим Баслимом, оказывается втянут в галактический шпионаж. В поисках своего происхождения он проходит путь от попрошайки до члена вольного торгового флота и офицера Гвардии.',2,2,NULL),(16,'Имею скафандр — готов путешествовать','Have Space Suit—Will Travel',1958,'Роман','Выиграв подержанный скафандр в конкурсе мыловаренной компании, Кип Рассел случайно оказывается похищенным «пиратами» вместе с гениальной девочкой Пиви. Им предстоит путешествие к Малому Магелланову Облаку и защита человечества на суде Галактического Трибунала.',2,2,NULL),(17,'Марсианка Подкейн','Podkayne of Mars',1963,'Роман','Подкейн Фрайс, марсианская девушка, отправляется в путешествие на Землю с братом и дядей. По пути они попадают в заговор, полный опасностей и интриг.',1,2,NULL),(18,'Кукловоды','The Puppet Masters',1951,'Роман','На Землю тайно высаживаются инопланетные паразиты, способные подчинять волю людей, прикрепляясь к их спинам. Агенты секретной службы пытаются остановить вторжение, пока «кукловоды» не захватили ключевых политиков и не подчинили всю планету.',5,NULL,NULL),(19,'Двойная звезда','Double Star',1956,'Роман','Великолепному, но безработному актеру Лоуренсу Смиту предлагают сыграть самую сложную роль в его жизни — подменить исчезнувшего лидера политической оппозиции. Ему приходится не только учить речи, но и перенимать личность политика, рискуя жизнью в межпланетных интригах.',5,NULL,NULL),(20,'Дверь в Лето','The Door into Summer',1957,'Роман','Изобретатель Дэниэл Бун Дэвис, обманутый партнерами и лишенный своей компании, ложится в «Длинный сон» (криоанабиоз), чтобы проснуться в будущем. Вместе со своим котом Питом он ищет способ вернуться в прошлое, чтобы исправить ошибки и отомстить обидчикам. Классика хронофантастики.',5,NULL,NULL),(21,'Звездный десант','Starship Troopers',1959,'Роман','В будущем гражданские права и право голоса предоставляются только ветеранам службы. Хуан «Джонни» Рико вступает в Мобильную Пехоту и проходит путь от новобранца до офицера в разгар жестокой межзвездной войны с расой арахнидов. Роман исследует темы гражданского долга, милитаризма и природы власти.',1,NULL,NULL),(22,'Чужак в чужой стране','Stranger in a Strange Land',1961,'Роман','Валентайн Майкл Смит — человек, воспитанный марсианами, — возвращается на Землю. Его иная логика, пси-способности и философия «гроккинга» (полного понимания) вызывают культурный шок и приводят к созданию нового религиозного движения, меняющего взгляды человечества на религию и секс.',1,NULL,NULL),(23,'Дорога славы','Glory Road',1963,'Роман','Ветеран войны Ивлин Сирил «Оскар» Гордон отвечает на газетное объявление, ищущее героя для опасного путешествия. Он оказывается в параллельном мире, где магия реальна, и становится защитником прекрасной Императрицы Стар, охраняя Яйцо Феникса. Редкий для Хайнлайна опыт в жанре чистого фэнтези.',1,NULL,NULL),(24,'Пасынки Вселенной','Orphans of the Sky',1963,'Роман','Обитатели гигантского корабля поколений забыли о своей миссии и считают, что корабль — это вся Вселенная. Хью Хойланд открывает истину и пытается вывести людей к звездам.',1,1,NULL),(25,'Свободное владение Фарнхэма','Farnham\'s Freehold',1964,'Роман','Во время ядерной атаки Хью Фарнхэм и его семья прячутся в бомбоубежище, но взрыв забрасывает их далеко в будущее. Они оказываются в мире, где социальные и расовые роли перевернуты: белые люди стали рабами, а правящая элита практикует каннибализм. Один из самых спорных романов автора.',1,NULL,NULL),(26,'Луна — суровая хозяйка','The Moon Is a Harsh Mistress',1966,'Роман','Лунная колония — суровое место, где воздух и вода стоят денег, а жизнь подчинена Главной ЭВМ. Группа заговорщиков во главе с одноруким компьютерщиком Манни и разумным суперкомпьютером Майком организует революцию против земной диктатуры под лозунгом «ТАНСТААФЛ» (Бесплатных завтраков не бывает).',1,NULL,NULL),(27,'Я не убоюсь зла','I Will Fear No Evil',1970,'Роман','Миллиардер Иоганн Себастьян Бах Смит, чье тело умирает от старости, решается на первую в мире пересадку мозга. Он просыпается в теле своей молодой секретарши Юнис. Роман исследует вопросы сексуальной идентичности, свободы воли и границ медицины в антиутопическом будущем.',1,NULL,NULL),(28,'Достаточно времени для любви','Time Enough for Love',1973,'Роман','Старейший член «Семьи Говарда», Лазарус Лонг, которому перевалило за 2000 лет, делится своими воспоминаниями. Книга представляет собой мозаику историй о любви, времени, генной инженерии и философии долгожителя, уставшего от жизни.',1,3,NULL),(29,'Число зверя','The Number of the Beast',1980,'Роман','Четверо героев на машине времени и пространства «Враведа», способной перемещаться через континуумы, путешествуют по мирам, созданным литературой (Страна Оз, Барсум и др.). Они обнаруживают, что вселенная устроена как «Мир как Миф», где авторы создают реальности своими произведениями.',9,3,NULL),(30,'Фрайди','Friday',1982,'Роман','Фрайди — искусственно созданный человек («искусственница»), работающая элитным курьером. В мире, который распадается на мелкие государства, она ищет свое место, семью и доказательство того, что у неё есть душа.',9,NULL,NULL),(31,'Джоб: Комедия справедливости','Job: A Comedy of Justice',1984,'Роман','Алекс Хергенсхаймер, набожный христианин, попадает в череду альтернативных реальностей, каждая из которых имеет свои странные законы. В конце пути ему предстоит встреча с Сатаной и самим Богом, чтобы выяснить, почему на его долю выпали такие испытания. Острая сатира на организованную религию.',9,NULL,NULL),(32,'Кот, проходивший сквозь стены','The Cat Who Walks Through Walls',1985,'Роман','Писатель и бывший военный полковник Колин Кэмпбелл оказывается втянут в межзвездный заговор. Книга объединяет персонажей из «Луна — суровая хозяйка» и других романов в единую мультивселенную. Важную роль играет кот Пиксель, который слишком молод, чтобы знать, что сквозь стены ходить нельзя.',1,3,NULL),(33,'Уплыть за закат','To Sail Beyond the Sunset',1987,'Роман','Последний роман Хайнлайна, опубликованный при жизни. Это мемуары Морин Джонсон, матери Лазаруса Лонга. Книга охватывает её жизнь с детства в начале XX века до путешествий во времени и пространстве в далеком будущем, связывая воедино все сюжетные линии «Истории будущего».',1,3,NULL),(34,'Линия жизни','Life-Line',1939,'Рассказ','Доктор Пинеро изобретает машину, способную точно предсказать дату смерти любого человека. Это вызывает панику у страховых компаний и ставит философский вопрос о предопределении.',3,1,1),(35,'Да будет свет!','Let There Be Light',1940,'Рассказ','Два ученых изобретают сверхэффективные солнечные панели, способные генерировать \"холодный свет\". Они борются с корпорациями, пытающимися подавить изобретение.',3,1,2),(36,'Дороги должны катиться','The Roads Must Roll',1940,'Повесть','В будущем транспортные дороги — это гигантские движущиеся платформы. Инженеры устраивают забастовку, требуя признания своей важности, что приводит к хаосу.',3,1,3),(37,'Взрыв всегда возможен','Blowups Happen',1940,'Рассказ','В атомной электростанции растет напряжение среди персонала: реактор — это едва контролируемый взрыв. Ученые ищут способ избежать катастрофы.',3,1,4),(38,'Человек, который продал Луну','The Man Who Sold the Moon',1950,'Повесть','Делос Д. Харриман, предприниматель, строит планы по колонизации Луны. Он манипулирует финансами и общественным мнением, чтобы осуществить первую лунную экспедицию.',8,1,5),(39,'Далила и космический монтажник','Delilah and the Space Rigger',1949,'Рассказ','На строительстве космической станции появляется женщина-радистка. Начальник против, но она доказывает свою ценность, преодолевая предрассудки.',7,1,6),(40,'Космический извозчик','Space Jockey',1947,'Рассказ','День из жизни пилота пассажирского ракетоносца на маршруте Земля-Луна. Он сталкивается с аварией и спасает корабль.',9,1,7),(41,'Реквием','Requiem',1940,'Рассказ','Д. Д. Харриман, богатый пионер космоса, в старости стремится на Луну вопреки здоровью. Он подкупает пилотов, чтобы осуществить мечту.',3,1,8),(42,'Долгая вахта','The Long Watch',1949,'Рассказ','Офицер Джон Дальквист предотвращает ядерный переворот на лунной базе, жертвуя собой ради спасения Земли.',6,1,9),(43,'Джентльмены, присядьте!','Gentlemen, Be Seated!',1948,'Рассказ','Трое мужчин заперты в туннеле на Луне из-за утечки воздуха. Они используют импровизированный метод — свои задницы — чтобы заткнуть дыру.',6,1,10),(44,'Темные ямы Луны','The Black Pits of Luna',1948,'Рассказ','Мальчик-скаут на Луне ищет потерявшегося брата, используя смекалку и скаутские навыки.',9,1,11),(45,'Как здорово вернуться!','It\'s Great to Be Back!',1947,'Рассказ','Пара колонистов с Луны возвращается на Землю, но тоскует по дому. Они обнаруживают, что предпочитают лунную жизнь.',9,1,12),(46,'А мы еще выгуливаем собак','We Also Walk Dogs',1941,'Рассказ','Компания \"Общие услуги\" берется за задачу: организовать конференцию на Земле с антигравитацией для инопланетян. Они изобретают устройство.',3,1,13),(47,'Поисковый луч','Searchlight',1962,'Рассказ','Слепая девочка-пианистка терпит крушение на Луне. Ее находят по музыкальному сигналу, используя ее талант.',4,1,14),(48,'Как бы нам её вернуть...','Ordeal in Space',1948,'Рассказ','Космонавт после аварии в открытом космосе развивает акрофобию. Вернувшись на Землю, он преодолевает страх неожиданным способом.',9,1,15),(49,'Зелёные холмы Земли','The Green Hills of Earth',1947,'Рассказ','Слепой поэт и певец космоса Рисслинг путешествует по Солнечной системе, сочиняя песни. История о том, как он спас корабль ценой своей жизни и написал знаменитую «Зеленые холмы Земли».',9,1,16),(50,'Логика империи','Logic of Empire',1941,'Повесть','На Венере процветает система контрактного рабства. Герой оказывается втянутым и размышляет о логике империй и эксплуатации.',3,1,17),(51,'Угроза с Земли','The Menace from Earth',1957,'Рассказ','На Луне девушка ревнует своего парня к туристке с Земли, которая может летать в низкой гравитации.',4,1,18),(52,'Если это будет продолжаться...','If This Goes On—',1940,'Повесть','В США установлена теократия под властью Пророка. Молодой солдат влюбляется и присоединяется к революции, чтобы свергнуть режим.',3,1,19),(53,'Ковентри','Coventry',1940,'Повесть','Человек, отвергающий общественный договор, сослан в \"Ковентри\" — анархическую зону. Там он обнаруживает хаос и меняет взгляды.',3,1,20),(54,'Неудачник','Misfit',1939,'Рассказ','Мальчик с математическим гением присоединяется к экипажу, перестраивающему астероид. Его талант спасает миссию.',3,1,21),(55,'Магия, инкорпорейтед','Magic, Inc.',1940,'Повесть','В мире, где магия реальна и регулируется, бизнесмен борется с монополией \"Магия, Инк.\", пытающейся контролировать всех магов.',3,NULL,NULL),(56,'Уолдо','Waldo',1942,'Повесть','Гений-инвалид Вальдо изобретает удаленные манипуляторы для операций. Он открывает паранаучные силы и исцеляет себя.',3,NULL,NULL),(57,'Они','They',1941,'Рассказ','Человек в психбольнице убежден, что весь мир — иллюзия, созданная для него. Он ищет правду о своем существовании.',3,NULL,NULL),(58,'И построил он дом...','And He Built a Crooked House',1941,'Рассказ','Архитектор строит дом в форме тессеракта — четырехмерного куба. Землетрясение складывает его в высшие измерения, заперев жильцов.',3,NULL,NULL),(59,'Неприятная профессия Джонатана Хоуга','The Unpleasant Profession of Jonathan Hoag',1942,'Повесть','Джонатан Хоаг нанимает детективов, чтобы узнать, чем он занимается днем, так как сам не помнит. Расследование раскрывает жуткую тайну реальности.',3,NULL,NULL),(60,'По собственным следам','By His Bootstraps',1941,'Повесть','Мужчина попадает в петлю путешествий во времени, встречаясь с самим собой в разных версиях. Он становится причиной своего собственного существования.',3,NULL,NULL),(61,'Все вы, зомби...','All You Zombies',1959,'Рассказ','Молодой человек обнаруживает, что на самом деле является одновременно и матерью, и отцом самому себе из-за сложной петли путешествий во времени и операций по смене пола. Самый известный парадокс в истории фантастики.',4,NULL,NULL);
/*!40000 ALTER TABLE `works` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-03  8:09:06
