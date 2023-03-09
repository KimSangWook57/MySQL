-- MySQL dump 10.13  Distrib 8.0.32, for Win64 (x86_64)
--
-- Host: localhost    Database: test01
-- ------------------------------------------------------
-- Server version	8.0.32

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
-- Table structure for table `견적서`
--

DROP TABLE IF EXISTS `견적서`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `견적서` (
  `견적서번호` int NOT NULL,
  `견적서날짜` date DEFAULT NULL,
  `접수자` varchar(45) DEFAULT NULL,
  `담당자` varchar(45) DEFAULT NULL,
  `공급가액` int DEFAULT NULL,
  `비고` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`견적서번호`),
  CONSTRAINT `fk_견적서_공급자` FOREIGN KEY (`견적서번호`) REFERENCES `공급자` (`공급자번호`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `견적서`
--

LOCK TABLES `견적서` WRITE;
/*!40000 ALTER TABLE `견적서` DISABLE KEYS */;
INSERT INTO `견적서` VALUES (1,'2023-03-08','홍길동','이인영',150000,'내용1'),(2,'2023-03-08','임꺽정','이인영',300000,'내용2'),(3,'2023-03-09','장길산','이인영',150000,'내용3'),(4,'2023-03-09','홍경래','이인영',450000,'내용4'),(5,'2023-03-10','마적도','이인영',1000000,'내용5');
/*!40000 ALTER TABLE `견적서` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `공급자`
--

DROP TABLE IF EXISTS `공급자`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `공급자` (
  `공급자번호` int NOT NULL,
  `상호` varchar(45) DEFAULT NULL,
  `대표성명` varchar(45) DEFAULT NULL,
  `주소` varchar(45) DEFAULT NULL,
  `업태` varchar(45) DEFAULT NULL,
  `종목` varchar(45) DEFAULT NULL,
  `전화번호` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`공급자번호`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `공급자`
--

LOCK TABLES `공급자` WRITE;
/*!40000 ALTER TABLE `공급자` DISABLE KEYS */;
INSERT INTO `공급자` VALUES (1,'가나다','홍길동','경기도','서비스','DB','010-0000-0000'),(2,'라마바','임꺽정','전라도','서비스','SQL','010-1111-1111'),(3,'사아자','장길산','경상도','서비스','JAVA','010-2222-2222'),(4,'카타파','홍경래','충청도','서비스','Python','010-3333-3333'),(5,'abc','마적도','강원도','서비스','React','010-4444-4444');
/*!40000 ALTER TABLE `공급자` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `내역`
--

DROP TABLE IF EXISTS `내역`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `내역` (
  `내역번호` int NOT NULL,
  `규격` varchar(45) DEFAULT NULL,
  `수량` int DEFAULT NULL,
  `단가` int DEFAULT NULL,
  `결제날짜` date DEFAULT NULL,
  PRIMARY KEY (`내역번호`),
  CONSTRAINT `fk_내역_견적서1` FOREIGN KEY (`내역번호`) REFERENCES `견적서` (`견적서번호`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `내역`
--

LOCK TABLES `내역` WRITE;
/*!40000 ALTER TABLE `내역` DISABLE KEYS */;
INSERT INTO `내역` VALUES (1,'MySQL',5,10000,'2023-03-08'),(2,'SQLite',10,5000,'2023-03-08'),(3,'자료구조',7,1000,'2023-03-09'),(4,'딕셔너리',20,100000,'2023-03-09'),(5,'날씨평가',17,25000,'2023-03-10');
/*!40000 ALTER TABLE `내역` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'test01'
--

--
-- Dumping routines for database 'test01'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-03-09 18:24:28
