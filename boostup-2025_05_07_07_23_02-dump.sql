-- MySQL dump 10.13  Distrib 8.0.41, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: boost-up
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Alergeno_Proteina`
--

DROP TABLE IF EXISTS `Alergeno_Proteina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Alergeno_Proteina` (
  `id_alergeno` int NOT NULL AUTO_INCREMENT,
  `proteina` int NOT NULL,
  `tipo_alergeno` int NOT NULL,
  PRIMARY KEY (`id_alergeno`),
  KEY `Alergeno_Proteina_Proteina_id_proteina_fk` (`proteina`),
  KEY `Alergeno_Proteina_Tipo_Alergeno_id_tipo_alergeno_fk` (`tipo_alergeno`),
  CONSTRAINT `Alergeno_Proteina_Proteina_id_proteina_fk` FOREIGN KEY (`proteina`) REFERENCES `Proteina` (`id_proteina`) ON UPDATE CASCADE,
  CONSTRAINT `Alergeno_Proteina_Tipo_Alergeno_id_tipo_alergeno_fk` FOREIGN KEY (`tipo_alergeno`) REFERENCES `Tipo_Alergeno` (`id_tipo_alergeno`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Alergeno_Proteina`
--

LOCK TABLES `Alergeno_Proteina` WRITE;
/*!40000 ALTER TABLE `Alergeno_Proteina` DISABLE KEYS */;
INSERT INTO `Alergeno_Proteina` VALUES (1,1,1),(2,2,2);
/*!40000 ALTER TABLE `Alergeno_Proteina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Alergia_Usuario`
--

DROP TABLE IF EXISTS `Alergia_Usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Alergia_Usuario` (
  `id_alergia` int NOT NULL AUTO_INCREMENT,
  `usuario` varchar(255) NOT NULL,
  `tipo_alergeno` int NOT NULL,
  PRIMARY KEY (`id_alergia`),
  KEY `Alergia_Usuario_Usuario_email_fk` (`usuario`),
  KEY `Alergia_Usuario_Tipo_Alergeno_id_tipo_alergeno_fk` (`tipo_alergeno`),
  CONSTRAINT `Alergia_Usuario_Tipo_Alergeno_id_tipo_alergeno_fk` FOREIGN KEY (`tipo_alergeno`) REFERENCES `Tipo_Alergeno` (`id_tipo_alergeno`) ON UPDATE CASCADE,
  CONSTRAINT `Alergia_Usuario_Usuario_email_fk` FOREIGN KEY (`usuario`) REFERENCES `Usuario` (`email`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Alergia_Usuario`
--

LOCK TABLES `Alergia_Usuario` WRITE;
/*!40000 ALTER TABLE `Alergia_Usuario` DISABLE KEYS */;
INSERT INTO `Alergia_Usuario` VALUES (2,'danamora700@gmail.com',1),(3,'mzl.salva@gmail.com',2),(6,'mzl.salva@gmail.com',2),(10,'emmanuel369@gmail.com',1),(11,'dafely306@gmail.com',1),(12,'dafely306@gmail.com',1),(17,'panchiloholly@gmail.com',1),(18,'elyoly@hotmail.com',1),(20,'a21300624@ceti.mx',2);
/*!40000 ALTER TABLE `Alergia_Usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Cantidades`
--

DROP TABLE IF EXISTS `Cantidades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Cantidades` (
  `id_cantidades` int NOT NULL AUTO_INCREMENT,
  `proteina_gr` tinyint unsigned NOT NULL,
  `curcuma_gr` tinyint unsigned NOT NULL,
  PRIMARY KEY (`id_cantidades`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Cantidades`
--

LOCK TABLES `Cantidades` WRITE;
/*!40000 ALTER TABLE `Cantidades` DISABLE KEYS */;
INSERT INTO `Cantidades` VALUES (1,13,2),(2,25,2),(3,28,5),(4,20,9),(5,16,7),(6,23,10),(7,19,9),(19,20,2),(20,22,2),(22,21,2);
/*!40000 ALTER TABLE `Cantidades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Compra`
--

DROP TABLE IF EXISTS `Compra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Compra` (
  `id_compra` int NOT NULL AUTO_INCREMENT,
  `pedido` varchar(64) NOT NULL,
  `monto_total` float NOT NULL,
  `fec_hora_compra` datetime NOT NULL,
  PRIMARY KEY (`id_compra`),
  KEY `Compra_Pedido_id_pedido_fk` (`pedido`),
  CONSTRAINT `Compra_Pedido_id_pedido_fk` FOREIGN KEY (`pedido`) REFERENCES `Pedido` (`id_pedido`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Compra`
--

LOCK TABLES `Compra` WRITE;
/*!40000 ALTER TABLE `Compra` DISABLE KEYS */;
INSERT INTO `Compra` VALUES (8,'afcbf616751388c608fdc0380e07527007f19338823f88a326d3b9a058f91673',80,'2025-03-18 01:08:53'),(9,'35b2a5d048fb1a1a41d87b464d2fedcd43db784bd960abfb70d9a12f3f2d8a88',70,'2025-03-19 01:00:51'),(10,'edf45706ca1b4e0e51f903f7df57368cd04e51a0569c3d6be386200e5847a7e0',70,'2025-03-20 01:05:26'),(11,'0bce1738f044bad798aa47b19c5526aec5c7e9269e343a27f07cdbf78c577213',70,'2025-03-20 01:11:36'),(12,'e1fc86eb9fca2ff2b5da6299fc88f484e2785cae7cfabcf73e58738d3b52ddf7',80,'2025-03-20 03:47:18'),(13,'bcb93f790639e6a40802438a3933fb0c5297cbdaaa4be87a17ffed18f3b20bdd',70,'2025-03-20 03:49:49'),(14,'afe9cddc631fe64d770ed5e4662ebd801ee368041d4bc2d13facd6ccf267b261',80,'2025-03-23 21:14:34'),(15,'387e57a8b3c58bdf4c5dcf51683a64988408284736ed31c4c1fab3b256897124',80,'2025-04-19 20:11:19'),(16,'78f2110345ce0da0d18483ed38a5e651001decebc85d26e918838348c595c402',80,'2025-04-29 05:34:14'),(17,'d5fd1c69e3042a7413d31e166e9d1cdab08c5d66c7b9eaeb445eaf80b71ce49b',80,'2025-04-29 05:35:42'),(18,'9c0c29cac8b0806204256c2bcfc393f04e6ea7451a6b1d3dac0519acc228c2ef',79.98,'2025-04-29 05:41:35'),(19,'fcdd205ba7bf3a434c91b20885d7bfa1f4ae428e2e0fe5b293d8fc1f4f355f02',80,'2025-05-01 23:58:45'),(20,'e538efad5ba178aa913c56b82245a83cfbee2ce1016024ba7d3a759260deb73e',80,'2025-05-02 00:16:50'),(21,'5a36fbb8767983b395ec72955a80d4c3c79bd22a7dda84c7b71db1326d9c94b0',70,'2025-05-06 01:07:04'),(22,'03589863301e468860376dbd17d755f4661484249e2b350ac582d91e4552b3c0',70,'2025-05-06 02:00:16'),(23,'e69dbaa7ada43bbd18c01c5b4f4d4d8fc17a8e4eac4501c2bf5cc2aea0ffa9b2',70,'2025-05-06 02:12:29'),(24,'d4006cb37bed2bb998fdc6180fe0fc4045ebc9eb9834015e2ff06c250198ed8d',70,'2025-05-06 02:16:00'),(25,'1529920d250b854f3ccf8d6e7515339487c71ea7e89acf45fdc4cffc6c0047ec',70,'2025-05-06 07:05:41'),(26,'9a6b3c06e968e5667f689f8900dd1f2e0264253bc39e1ce75dcc3e96c9fb384f',70,'2025-05-06 07:07:02'),(27,'f1ea253faac333a8f8d086876fa0987bf7b5148d024e3348f2536f8ed3314541',80,'2025-05-06 07:20:09'),(28,'338958692290ea0efebb3992edf30401c57ede7f666a3d1d894f2394e4f1b290',79.98,'2025-05-06 08:32:10'),(29,'7343f5ebf20809fd2773e32552a04f922b3457c9dbb39e0f2c5e5867d09e0e6d',80,'2025-05-06 08:48:10'),(30,'0a73060f045dac88f79ef1c1f54887dd7e2d68ed5db47144cd1741cd2c94ecc3',70,'2025-05-06 08:48:49'),(31,'c4efc0ec1ab9c6734cb3eb62cea50004dc488a09c08ad330c90361fc6409aa9d',80,'2025-05-06 09:17:57'),(32,'f396ab781ff43641701a95082d3a2361e643810c2d572b5464d414a9cbc5bd0e',80,'2025-05-06 09:19:37'),(33,'fccbf15ec8cfd3e95172bf3f07b127da6d45f341561a1e9c8df5cf345d6594b1',70,'2025-05-06 22:04:01'),(34,'c281b648313602af1aa3210792d4f4b79a258edfebbe5070af486268bac20291',70,'2025-05-06 22:19:05'),(35,'7fa370cfff84d176136a707a3158731703fcea1ddb0abe8c8b64aa6af204eedd',80,'2025-05-06 22:23:50'),(36,'c910a58334c3b775a02fdd248d01b866e804a3d2152a4332b131a8f787392872',80,'2025-05-06 22:25:31'),(37,'72312b4d0b8471cfe32087987ea9c36a794c57e073f8de28dd658031be4d7b3c',70,'2025-05-07 00:02:13'),(38,'5326aaeda3bc450718c9fc5759fa8e1cda36bf543faebcb24ce67787524a7826',80,'2025-05-07 00:09:26'),(39,'021b79ab62b0e15239910010dfa37be36dfe1de36610a4721d5db347da9823ab',80,'2025-05-07 00:25:09'),(40,'36a0233395fedd88bcbddcf2cdf81f1ebab4e092186f11e69721c19e30cf70fc',80,'2025-05-07 00:45:10'),(41,'0046bf00b1d561c76a39a8273e59cbdc13d85109f1c28452ca397015e0333be1',80,'2025-05-07 01:10:58'),(42,'e96c2eb7b955c6e24f47770625853f3020ea35d847ed40464c71681c6c772cdf',80,'2025-05-07 01:21:53'),(43,'086a4dfff6b1ae81b2c5035be02d7ba687fca6d6c4f7d1b24f3d2a129f7a1d80',80,'2025-05-07 01:24:20'),(44,'4fd681c40850194294eaf2118a2b2ac9cdb8c8128b5f29b80e3455def8f50963',80,'2025-05-07 01:25:04'),(45,'d4b983e3efe84e08319e3b7415911ce21a8207f1c4cdfcdc9b532143b516a99a',70,'2025-05-07 01:26:14'),(46,'394b89b169d453ae72d5b8c72d7fb50c0ad205a2bf311311aca11b622c3bdcbb',80,'2025-05-07 01:29:50'),(47,'ae82ae0013d6dcb2d4a376f6cc1a7e082eafefa59ab47e8662b48ea19be0c7bb',80,'2025-05-07 01:39:47'),(48,'da9cb915498bf960177ae2876e5adf89a38ff6d6f4af4f3b4c1ccfef23f67286',70,'2025-05-07 01:42:44');
/*!40000 ALTER TABLE `Compra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Curcuma`
--

DROP TABLE IF EXISTS `Curcuma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Curcuma` (
  `id_curcuma` int NOT NULL AUTO_INCREMENT,
  `marca` int NOT NULL,
  `cont_curcuminoide` float NOT NULL,
  `cont_gingerol` float NOT NULL,
  `precauciones` varchar(500) DEFAULT NULL,
  `fec_actualizacion` date NOT NULL,
  `precio` float NOT NULL,
  PRIMARY KEY (`id_curcuma`),
  KEY `Curcuma_Marca_id_marca_fk` (`marca`),
  CONSTRAINT `Curcuma_Marca_id_marca_fk` FOREIGN KEY (`marca`) REFERENCES `Marca` (`id_marca`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Curcuma`
--

LOCK TABLES `Curcuma` WRITE;
/*!40000 ALTER TABLE `Curcuma` DISABLE KEYS */;
INSERT INTO `Curcuma` VALUES (1,3,100,100,'ninguna','2025-01-25',10);
/*!40000 ALTER TABLE `Curcuma` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Dueno`
--

DROP TABLE IF EXISTS `Dueno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Dueno` (
  `usuario_dueno` varchar(100) NOT NULL,
  `maquina` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `password` varchar(64) NOT NULL,
  PRIMARY KEY (`usuario_dueno`),
  KEY `Dueno_Maquina_id_maquina_fk` (`maquina`),
  CONSTRAINT `Dueno_Maquina_id_maquina_fk` FOREIGN KEY (`maquina`) REFERENCES `Maquina` (`id_maquina`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Dueno`
--

LOCK TABLES `Dueno` WRITE;
/*!40000 ALTER TABLE `Dueno` DISABLE KEYS */;
INSERT INTO `Dueno` VALUES ('chavaown',1,'Salvador','Arana','$2a$12$tuPFkp7SaO5IR1iCjBLQe.iQge/rgq9zgTo13f3.ki9EhJLkcu9Ta'),('dafnetech',1,'Dafne Elizabeth','Vazquez Ortega','15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225');
/*!40000 ALTER TABLE `Dueno` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Fallo`
--

DROP TABLE IF EXISTS `Fallo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Fallo` (
  `id_fallo` int NOT NULL AUTO_INCREMENT,
  `maquina` int NOT NULL,
  `tipo_fallo` int NOT NULL,
  `fec_hora` datetime NOT NULL,
  `descripcion` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id_fallo`),
  KEY `Fallo_Maquina_id_maquina_fk` (`maquina`),
  KEY `Fallo_Tipo_Fallo_id_tipo_fallo_fk` (`tipo_fallo`),
  CONSTRAINT `Fallo_Maquina_id_maquina_fk` FOREIGN KEY (`maquina`) REFERENCES `Maquina` (`id_maquina`) ON UPDATE CASCADE,
  CONSTRAINT `Fallo_Tipo_Fallo_id_tipo_fallo_fk` FOREIGN KEY (`tipo_fallo`) REFERENCES `Tipo_Fallo` (`id_tipo_fallo`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Fallo`
--

LOCK TABLES `Fallo` WRITE;
/*!40000 ALTER TABLE `Fallo` DISABLE KEYS */;
INSERT INTO `Fallo` VALUES (1,1,1,'2025-01-25 00:11:41','Prueba de fallo 1'),(2,1,1,'2025-01-25 11:41:00','prueba de fallo 2'),(3,1,1,'2025-05-07 13:09:09','No jodas la maquina se pudrio'),(4,1,1,'2025-05-07 13:16:40','Ya se volvio a safar el dese de la desa');
/*!40000 ALTER TABLE `Fallo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Historial_Humedad`
--

DROP TABLE IF EXISTS `Historial_Humedad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Historial_Humedad` (
  `id_humedad` int NOT NULL AUTO_INCREMENT,
  `maquina` int NOT NULL,
  `humedad` float DEFAULT NULL,
  `fecha_hora` datetime DEFAULT NULL,
  PRIMARY KEY (`id_humedad`),
  KEY `Historial_Humedad_Maquina_id_maquina_fk` (`maquina`),
  CONSTRAINT `Historial_Humedad_Maquina_id_maquina_fk` FOREIGN KEY (`maquina`) REFERENCES `Maquina` (`id_maquina`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Historial_Humedad`
--

LOCK TABLES `Historial_Humedad` WRITE;
/*!40000 ALTER TABLE `Historial_Humedad` DISABLE KEYS */;
INSERT INTO `Historial_Humedad` VALUES (1,1,123,'2025-02-02 23:58:20');
/*!40000 ALTER TABLE `Historial_Humedad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Inv_Curcuma`
--

DROP TABLE IF EXISTS `Inv_Curcuma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Inv_Curcuma` (
  `id_inv_curcuma` int NOT NULL AUTO_INCREMENT,
  `curcuma` int NOT NULL,
  `maquina` int NOT NULL,
  `cantidad_gr` int NOT NULL,
  `fec_caducidad` date NOT NULL,
  `fec_ult_abasto` datetime NOT NULL,
  `fec_prev_abasto` date DEFAULT NULL,
  `fec_limite_abasto` date DEFAULT NULL,
  PRIMARY KEY (`id_inv_curcuma`),
  KEY `Inv_Curcuma_Curcuma_id_curcuma_fk` (`curcuma`),
  KEY `Inv_Curcuma_Maquina_id_maquina_fk` (`maquina`),
  CONSTRAINT `Inv_Curcuma_Curcuma_id_curcuma_fk` FOREIGN KEY (`curcuma`) REFERENCES `Curcuma` (`id_curcuma`) ON UPDATE CASCADE,
  CONSTRAINT `Inv_Curcuma_Maquina_id_maquina_fk` FOREIGN KEY (`maquina`) REFERENCES `Maquina` (`id_maquina`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Inv_Curcuma`
--

LOCK TABLES `Inv_Curcuma` WRITE;
/*!40000 ALTER TABLE `Inv_Curcuma` DISABLE KEYS */;
INSERT INTO `Inv_Curcuma` VALUES (1,1,1,100,'2026-05-06','2025-05-06 06:11:07','2025-05-06','2025-12-06');
/*!40000 ALTER TABLE `Inv_Curcuma` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Inv_Proteina`
--

DROP TABLE IF EXISTS `Inv_Proteina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Inv_Proteina` (
  `id_inv_proteina` int NOT NULL AUTO_INCREMENT,
  `proteina` int NOT NULL,
  `maquina` int NOT NULL,
  `cantidad_gr` int NOT NULL,
  `fec_caducidad` date NOT NULL,
  `fec_ult_abasto` datetime NOT NULL,
  `fec_prev_abasto` date DEFAULT NULL,
  `fec_limite_abasto` date DEFAULT NULL,
  PRIMARY KEY (`id_inv_proteina`),
  KEY `Inv_Proteina_Proteina_id_proteina_fk` (`proteina`),
  KEY `Inv_Proteina___fk` (`maquina`),
  CONSTRAINT `Inv_Proteina___fk` FOREIGN KEY (`maquina`) REFERENCES `Maquina` (`id_maquina`) ON UPDATE CASCADE,
  CONSTRAINT `Inv_Proteina_Proteina_id_proteina_fk` FOREIGN KEY (`proteina`) REFERENCES `Proteina` (`id_proteina`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Inv_Proteina`
--

LOCK TABLES `Inv_Proteina` WRITE;
/*!40000 ALTER TABLE `Inv_Proteina` DISABLE KEYS */;
INSERT INTO `Inv_Proteina` VALUES (1,1,1,1337,'2025-05-07','2025-05-07 01:59:20','2025-05-07',NULL),(2,2,1,100,'2025-01-30','2025-03-30 01:05:55','2025-03-18','2025-03-20');
/*!40000 ALTER TABLE `Inv_Proteina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Inv_Saborizante`
--

DROP TABLE IF EXISTS `Inv_Saborizante`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Inv_Saborizante` (
  `id_inv_sabor` int NOT NULL AUTO_INCREMENT,
  `saborizante` int NOT NULL,
  `maquina` int NOT NULL,
  `cantidad_ml` int NOT NULL,
  `fec_caducidad` date NOT NULL,
  `fec_ult_abasto` datetime NOT NULL,
  `fec_prev_abasto` date DEFAULT NULL,
  `fec_limite_abasto` date DEFAULT NULL,
  PRIMARY KEY (`id_inv_sabor`),
  KEY `Inv_Saborizante_Maquina_id_maquina_fk` (`maquina`),
  KEY `Inv_Saborizante_Saborizante_id_saborizante_fk` (`saborizante`),
  CONSTRAINT `Inv_Saborizante_Maquina_id_maquina_fk` FOREIGN KEY (`maquina`) REFERENCES `Maquina` (`id_maquina`) ON UPDATE CASCADE,
  CONSTRAINT `Inv_Saborizante_Saborizante_id_saborizante_fk` FOREIGN KEY (`saborizante`) REFERENCES `Saborizante` (`id_saborizante`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Inv_Saborizante`
--

LOCK TABLES `Inv_Saborizante` WRITE;
/*!40000 ALTER TABLE `Inv_Saborizante` DISABLE KEYS */;
INSERT INTO `Inv_Saborizante` VALUES (1,1,1,90,'2025-06-06','2025-05-06 06:11:46','2025-05-06','2025-06-30');
/*!40000 ALTER TABLE `Inv_Saborizante` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Maquina`
--

DROP TABLE IF EXISTS `Maquina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Maquina` (
  `id_maquina` int NOT NULL AUTO_INCREMENT,
  `ubicacion` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id_maquina`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Maquina`
--

LOCK TABLES `Maquina` WRITE;
/*!40000 ALTER TABLE `Maquina` DISABLE KEYS */;
INSERT INTO `Maquina` VALUES (1,'C. Nueva Escocia 1885, Providencia 5a Secc.'),(2,'Av Naciones Unidas 6700, Loma Real, 45129 Zapopan, Jal.');
/*!40000 ALTER TABLE `Maquina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Marca`
--

DROP TABLE IF EXISTS `Marca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Marca` (
  `id_marca` int NOT NULL AUTO_INCREMENT,
  `marca` varchar(100) NOT NULL,
  PRIMARY KEY (`id_marca`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Marca`
--

LOCK TABLES `Marca` WRITE;
/*!40000 ALTER TABLE `Marca` DISABLE KEYS */;
INSERT INTO `Marca` VALUES (1,'Birdman'),(2,'Deiman'),(3,'Nature Heart'),(4,'Hero Sport');
/*!40000 ALTER TABLE `Marca` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Medidas`
--

DROP TABLE IF EXISTS `Medidas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Medidas` (
  `id_medidas` int NOT NULL AUTO_INCREMENT,
  `imc` float NOT NULL,
  `peso_kg` tinyint unsigned DEFAULT NULL,
  `talla_cm` tinyint unsigned NOT NULL,
  `cintura_cm` tinyint unsigned NOT NULL,
  `cadera_cm` tinyint unsigned NOT NULL,
  `circ_brazo_cm` tinyint unsigned NOT NULL,
  `fec_actualizacion` date NOT NULL,
  PRIMARY KEY (`id_medidas`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Medidas`
--

LOCK TABLES `Medidas` WRITE;
/*!40000 ALTER TABLE `Medidas` DISABLE KEYS */;
INSERT INTO `Medidas` VALUES (1,12.5,32,160,81,90,20,'2025-05-06'),(2,25.6173,83,180,120,107,31,'2025-05-01'),(3,22.22,72,180,85,85,25,'2025-01-29'),(4,26.8274,85,178,110,90,34,'2025-03-12'),(5,22.4914,65,170,70,85,20,'2025-03-23'),(6,25.8546,81,177,96,92,30,'2025-03-23'),(18,24.2188,62,160,85,95,30,'2025-05-05'),(19,33.4622,90,164,100,130,40,'2025-05-05'),(21,23.4375,60,160,90,90,50,'2025-05-07');
/*!40000 ALTER TABLE `Medidas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Pedido`
--

DROP TABLE IF EXISTS `Pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Pedido` (
  `id_pedido` varchar(64) NOT NULL,
  `usuario` varchar(255) DEFAULT NULL,
  `proteina` int NOT NULL,
  `curcuma` int DEFAULT NULL,
  `saborizante` int NOT NULL,
  `maquina_canje` int DEFAULT NULL,
  `estado_canje` enum('canjeado','no_canjeado') NOT NULL,
  `fec_hora_canje` datetime DEFAULT NULL,
  `proteina_gr` tinyint NOT NULL,
  `curcuma_gr` tinyint DEFAULT NULL,
  PRIMARY KEY (`id_pedido`),
  KEY `Pedido_Curcuma_id_curcuma_fk` (`curcuma`),
  KEY `Pedido_Maquina_id_maquina_fk` (`maquina_canje`),
  KEY `Pedido_Proteina_id_proteina_fk` (`proteina`),
  KEY `Pedido___fk` (`usuario`),
  KEY `Pedido___fk_2` (`saborizante`),
  CONSTRAINT `Pedido___fk` FOREIGN KEY (`usuario`) REFERENCES `Usuario` (`email`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Pedido___fk_2` FOREIGN KEY (`saborizante`) REFERENCES `Saborizante` (`id_saborizante`) ON UPDATE CASCADE,
  CONSTRAINT `Pedido_Curcuma_id_curcuma_fk` FOREIGN KEY (`curcuma`) REFERENCES `Curcuma` (`id_curcuma`) ON UPDATE CASCADE,
  CONSTRAINT `Pedido_Maquina_id_maquina_fk` FOREIGN KEY (`maquina_canje`) REFERENCES `Maquina` (`id_maquina`) ON UPDATE CASCADE,
  CONSTRAINT `Pedido_Proteina_id_proteina_fk` FOREIGN KEY (`proteina`) REFERENCES `Proteina` (`id_proteina`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Pedido`
--

LOCK TABLES `Pedido` WRITE;
/*!40000 ALTER TABLE `Pedido` DISABLE KEYS */;
INSERT INTO `Pedido` VALUES ('0046bf00b1d561c76a39a8273e59cbdc13d85109f1c28452ca397015e0333be1','danamora700@gmail.com',2,1,1,NULL,'no_canjeado',NULL,28,5),('021b79ab62b0e15239910010dfa37be36dfe1de36610a4721d5db347da9823ab','mzl.salva@gmail.com',1,1,1,1,'canjeado','2025-05-07 05:33:24',25,2),('03589863301e468860376dbd17d755f4661484249e2b350ac582d91e4552b3c0','dafely306@gmail.com',1,NULL,3,NULL,'no_canjeado',NULL,12,NULL),('06ea50ccb4003726b70053fb4bad7c27b1f4a419ef1dbb2ac9fe05d1bb67bf1b','dafely306@gmail.com',2,1,1,NULL,'no_canjeado',NULL,12,2),('086a4dfff6b1ae81b2c5035be02d7ba687fca6d6c4f7d1b24f3d2a129f7a1d80','danamora700@gmail.com',2,1,1,NULL,'no_canjeado',NULL,28,5),('0a73060f045dac88f79ef1c1f54887dd7e2d68ed5db47144cd1741cd2c94ecc3',NULL,4,NULL,2,NULL,'no_canjeado',NULL,21,NULL),('0bce1738f044bad798aa47b19c5526aec5c7e9269e343a27f07cdbf78c577213','mzl.salva@gmail.com',1,NULL,2,NULL,'no_canjeado',NULL,40,NULL),('0dbedbba615898453b0c34a7d7d0891175360b66ba8088a4b9a23e0aca714b5f','mzl.salva@gmail.com',1,NULL,1,NULL,'no_canjeado',NULL,25,NULL),('11cee14e3327ccc051791716aeb4d7ac80eca5fbae3c06e82bca87c1c4e31205','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('1366f30184e3b52829fa601c4a91919f1a79b9fd80027d81ce407426be73d58f','dafely306@gmail.com',2,1,1,NULL,'no_canjeado',NULL,13,2),('14fe7bdf9ee888c69c2b0190517a35ed0134b94643562b4438b9994e27b68092','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,40,7),('1529920d250b854f3ccf8d6e7515339487c71ea7e89acf45fdc4cffc6c0047ec','dafely306@gmail.com',1,NULL,3,NULL,'no_canjeado',NULL,12,NULL),('2433af9ae2c457d44a834a7aaf66a58624e1f9a6abbe33b14062496083c92505','dafely306@gmail.com',1,1,1,NULL,'no_canjeado',NULL,13,2),('338958692290ea0efebb3992edf30401c57ede7f666a3d1d894f2394e4f1b290','dafely306@gmail.com',2,1,2,NULL,'no_canjeado',NULL,12,2),('340f7ab92d67225f4af50fe1e3cdb894ea4e9c8d2f23a536b8d659868b1a5d0d','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('35b2a5d048fb1a1a41d87b464d2fedcd43db784bd960abfb70d9a12f3f2d8a88','mzl.salva@gmail.com',1,NULL,2,NULL,'no_canjeado',NULL,40,NULL),('36a0233395fedd88bcbddcf2cdf81f1ebab4e092186f11e69721c19e30cf70fc','danamora700@gmail.com',1,1,1,NULL,'no_canjeado',NULL,28,5),('387e57a8b3c58bdf4c5dcf51683a64988408284736ed31c4c1fab3b256897124','mzl.salva@gmail.com',1,1,1,1,'canjeado','2025-05-07 05:33:24',40,7),('394b89b169d453ae72d5b8c72d7fb50c0ad205a2bf311311aca11b622c3bdcbb','danamora700@gmail.com',1,1,1,NULL,'no_canjeado',NULL,28,5),('3a10234941b12a1322f3ee65c27ae053995a81aa02b85ddbdab1c9288e9b0c9d','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('4a26888cde353b4a4a7cc53778e9e4d0b63b33409f45bfa24473ebcb76f4bac7','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('4fd681c40850194294eaf2118a2b2ac9cdb8c8128b5f29b80e3455def8f50963','panchiloholly@gmail.com',1,1,2,NULL,'no_canjeado',NULL,20,2),('5326aaeda3bc450718c9fc5759fa8e1cda36bf543faebcb24ce67787524a7826','dafely306@gmail.com',2,1,2,NULL,'no_canjeado',NULL,13,2),('558aa7d1b35289d665875efd6e80e12758a0791cc9b73ff9a04788d038aeaf3b','mzl.salva@gmail.com',2,1,2,NULL,'no_canjeado',NULL,40,7),('5a36fbb8767983b395ec72955a80d4c3c79bd22a7dda84c7b71db1326d9c94b0','mzl.salva@gmail.com',1,NULL,1,1,'canjeado','2025-05-07 05:33:24',25,NULL),('70136b14408d4ef1fc81f06c023e3f6ed56356891efacd570abc8682198f1ed3','dafely306@gmail.com',2,1,2,NULL,'no_canjeado',NULL,13,2),('72312b4d0b8471cfe32087987ea9c36a794c57e073f8de28dd658031be4d7b3c','dafely306@gmail.com',1,NULL,3,NULL,'no_canjeado',NULL,13,NULL),('7343f5ebf20809fd2773e32552a04f922b3457c9dbb39e0f2c5e5867d09e0e6d',NULL,3,1,3,NULL,'no_canjeado',NULL,21,2),('78f2110345ce0da0d18483ed38a5e651001decebc85d26e918838348c595c402','mzl.salva@gmail.com',1,1,1,1,'canjeado','2025-04-07 05:33:24',40,7),('7cb0e72324b99c3e9852069f77f7b8b882b018e2b226683cfb86a293315b114a','panchiloholly@gmail.com',2,1,2,NULL,'no_canjeado',NULL,20,2),('7fa370cfff84d176136a707a3158731703fcea1ddb0abe8c8b64aa6af204eedd','dafely306@gmail.com',2,1,1,NULL,'no_canjeado',NULL,13,2),('82cfd3c291004c5c9b53788252b27d0cedc1ac2061e4fa34132e5de4447d4741','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('8564e5a6b4c7f01273de2d696a05e52def81de8132d4999c55d2929168226db1','panchiloholly@gmail.com',2,1,2,NULL,'no_canjeado',NULL,20,2),('8cc533da27d111c283181e0a380ee20303b6b2943699ab679ed0a61e3f29aeb6','mzl.salva@gmail.com',2,1,1,NULL,'no_canjeado',NULL,25,2),('970bc33b4d63e31b3703ac799457f500b89ebd0414d92f404b5601e9c9db5e22','dafely306@gmail.com',1,NULL,3,NULL,'no_canjeado',NULL,12,NULL),('9a6b3c06e968e5667f689f8900dd1f2e0264253bc39e1ce75dcc3e96c9fb384f','dafely306@gmail.com',1,NULL,3,NULL,'no_canjeado',NULL,12,NULL),('9c0c29cac8b0806204256c2bcfc393f04e6ea7451a6b1d3dac0519acc228c2ef','mzl.salva@gmail.com',2,1,3,1,'canjeado','2025-04-07 05:33:24',40,7),('a1e1d02bde490103789766ca3a45b7af09d42cd7364a87cd9991ebf822cb4837','panchiloholly@gmail.com',1,1,2,NULL,'no_canjeado',NULL,20,2),('a28eddc9cd9fa8c3dc050d138ad6bdece07fe8f972cda2bcd5bd403b66da87f9','dafely306@gmail.com',2,NULL,1,NULL,'no_canjeado',NULL,13,NULL),('a41f825202722e0bf4da5c546eb9423865355c7a9d2505e4fc4fd41f522fe2f2','dafely306@gmail.com',2,NULL,1,NULL,'no_canjeado',NULL,12,NULL),('ae82ae0013d6dcb2d4a376f6cc1a7e082eafefa59ab47e8662b48ea19be0c7bb','danamora700@gmail.com',1,1,1,NULL,'no_canjeado',NULL,28,5),('afcbf616751388c608fdc0380e07527007f19338823f88a326d3b9a058f91673','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,40,7),('afe9cddc631fe64d770ed5e4662ebd801ee368041d4bc2d13facd6ccf267b261','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,40,7),('b10a2a84a43c4fdd56582aa2c20cedc2d5b56f30fbf7cb0de7c22a518ea29347','mzl.salva@gmail.com',2,1,1,NULL,'no_canjeado',NULL,25,2),('b68d71d32d317a6c6bad2181dec87abd383245ce37f8f84d242ae8ff361fb86f','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('bcb93f790639e6a40802438a3933fb0c5297cbdaaa4be87a17ffed18f3b20bdd','mzl.salva@gmail.com',1,NULL,3,NULL,'no_canjeado',NULL,40,NULL),('c281b648313602af1aa3210792d4f4b79a258edfebbe5070af486268bac20291','dafely306@gmail.com',1,NULL,2,NULL,'no_canjeado',NULL,13,NULL),('c4efc0ec1ab9c6734cb3eb62cea50004dc488a09c08ad330c90361fc6409aa9d','dafely306@gmail.com',2,1,2,NULL,'no_canjeado',NULL,13,2),('c910a58334c3b775a02fdd248d01b866e804a3d2152a4332b131a8f787392872','dafely306@gmail.com',1,1,2,NULL,'no_canjeado',NULL,13,2),('cb5bc1a3fc01aab67eb64b3be978acb1a755ba309abe4a3e59d71e1138ca0007','dafely306@gmail.com',1,1,1,NULL,'no_canjeado',NULL,12,2),('cdf9ccb9c68137b575e6e0d60e23fd23b1d946b659b9220200f87f2674b5e4db','dafely306@gmail.com',1,NULL,3,NULL,'no_canjeado',NULL,12,NULL),('d4006cb37bed2bb998fdc6180fe0fc4045ebc9eb9834015e2ff06c250198ed8d','dafely306@gmail.com',1,NULL,3,NULL,'no_canjeado',NULL,12,NULL),('d4b983e3efe84e08319e3b7415911ce21a8207f1c4cdfcdc9b532143b516a99a','panchiloholly@gmail.com',2,NULL,2,NULL,'no_canjeado',NULL,20,NULL),('d5fd1c69e3042a7413d31e166e9d1cdab08c5d66c7b9eaeb445eaf80b71ce49b','mzl.salva@gmail.com',1,1,2,1,'canjeado','2025-04-07 05:33:24',40,7),('da9cb915498bf960177ae2876e5adf89a38ff6d6f4af4f3b4c1ccfef23f67286','danamora700@gmail.com',2,NULL,1,NULL,'no_canjeado',NULL,28,NULL),('e1fc86eb9fca2ff2b5da6299fc88f484e2785cae7cfabcf73e58738d3b52ddf7','danamora700@gmail.com',1,1,1,NULL,'no_canjeado',NULL,40,7),('e538efad5ba178aa913c56b82245a83cfbee2ce1016024ba7d3a759260deb73e','danamora700@gmail.com',1,1,2,NULL,'no_canjeado',NULL,40,7),('e69dbaa7ada43bbd18c01c5b4f4d4d8fc17a8e4eac4501c2bf5cc2aea0ffa9b2','dafely306@gmail.com',1,NULL,3,NULL,'no_canjeado',NULL,12,NULL),('e96c2eb7b955c6e24f47770625853f3020ea35d847ed40464c71681c6c772cdf','danamora700@gmail.com',2,1,1,NULL,'no_canjeado',NULL,28,5),('ea912abd1db798c47ed2cf111442e2ed5a3247c417da02a8965c698ecc20000b','dafely306@gmail.com',3,1,2,NULL,'no_canjeado',NULL,13,2),('ed22db2458f13e60d949f2068272a6cb811eb5bf3d4ce27e909bfca8db1a53f5','panchiloholly@gmail.com',1,1,1,NULL,'no_canjeado',NULL,20,2),('edf45706ca1b4e0e51f903f7df57368cd04e51a0569c3d6be386200e5847a7e0','dafely306@gmail.com',1,NULL,2,NULL,'canjeado',NULL,40,NULL),('f104bebbc01b2609edf9130c249f74364e07564cd2a44dd2ee7e472a7722126c','dafely306@gmail.com',1,NULL,3,NULL,'no_canjeado',NULL,12,NULL),('f19c5ab6d5070f67fb6034b45667ecb3e8fba944c34641c9912e49a1ceeb2acc','danamora700@gmail.com',1,1,1,NULL,'no_canjeado',NULL,28,5),('f1ea253faac333a8f8d086876fa0987bf7b5148d024e3348f2536f8ed3314541','dafely306@gmail.com',1,1,3,NULL,'no_canjeado',NULL,12,2),('f1ee94f9b51c2a6466e1e7c4c740f61cb4d3358355e7e1e9e3befd4a57fbb595','dafely306@gmail.com',2,1,2,NULL,'no_canjeado',NULL,13,2),('f396ab781ff43641701a95082d3a2361e643810c2d572b5464d414a9cbc5bd0e','dafely306@gmail.com',2,1,1,NULL,'canjeado',NULL,13,2),('f6e705ce12bb6488bddabc6d93f25610db7a4a99f85aa4b4370670136177029e','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('f7536056005c2c0d14d3bbc0c11cf33d39a0618aed89d54176fced591ea6da2d','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('fccbf15ec8cfd3e95172bf3f07b127da6d45f341561a1e9c8df5cf345d6594b1','dafely306@gmail.com',2,NULL,1,NULL,'no_canjeado',NULL,13,NULL),('fcdd205ba7bf3a434c91b20885d7bfa1f4ae428e2e0fe5b293d8fc1f4f355f02','dafely306@gmail.com',1,1,1,NULL,'no_canjeado',NULL,40,7),('fd4954b5b52aeeaca9642b49ee1ba6f091c69e3ee96332df6611a851c6610444','panchiloholly@gmail.com',2,NULL,2,NULL,'no_canjeado',NULL,20,NULL);
/*!40000 ALTER TABLE `Pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Proteina`
--

DROP TABLE IF EXISTS `Proteina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Proteina` (
  `id_proteina` int NOT NULL AUTO_INCREMENT,
  `marca` int NOT NULL,
  `tipo_proteina` enum('Animal','Vegetal') DEFAULT NULL,
  `nombre` varchar(30) NOT NULL,
  `cont_nutricional` varchar(1000) NOT NULL,
  `densidad_proteica` float NOT NULL,
  `fec_actualizacion` date NOT NULL,
  `precio` float NOT NULL,
  PRIMARY KEY (`id_proteina`),
  KEY `Proteina_Marca_id_marca_fk` (`marca`),
  CONSTRAINT `Proteina_Marca_id_marca_fk` FOREIGN KEY (`marca`) REFERENCES `Marca` (`id_marca`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Proteina`
--

LOCK TABLES `Proteina` WRITE;
/*!40000 ALTER TABLE `Proteina` DISABLE KEYS */;
INSERT INTO `Proteina` VALUES (1,1,'Vegetal','Falcon Protein','Proteinas: muchas',0.8,'2025-01-25',70),(2,4,'Animal','Pure And Natural','Proteinas: muchas',0.9,'2025-01-28',70),(3,1,'Vegetal','Proteina buena','Proteinas: muchas',0.9,'2025-05-06',70),(4,4,'Animal','proteina chida','Proteinas: muchas',0.9,'2025-05-06',70);
/*!40000 ALTER TABLE `Proteina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Sabor`
--

DROP TABLE IF EXISTS `Sabor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Sabor` (
  `id_sabor` int NOT NULL AUTO_INCREMENT,
  `sabor` varchar(100) NOT NULL,
  PRIMARY KEY (`id_sabor`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Sabor`
--

LOCK TABLES `Sabor` WRITE;
/*!40000 ALTER TABLE `Sabor` DISABLE KEYS */;
INSERT INTO `Sabor` VALUES (1,'Chocolate'),(2,'Vainilla'),(3,'Fresa');
/*!40000 ALTER TABLE `Sabor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Saborizante`
--

DROP TABLE IF EXISTS `Saborizante`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Saborizante` (
  `id_saborizante` int NOT NULL AUTO_INCREMENT,
  `marca` int NOT NULL,
  `sabor` int NOT NULL,
  `tipo_saborizante` int NOT NULL,
  `cont_calorico` smallint NOT NULL,
  `fec_actualizacion` date NOT NULL,
  `porcion` int NOT NULL,
  PRIMARY KEY (`id_saborizante`),
  KEY `Saborizante_Marca_id_marca_fk` (`marca`),
  KEY `Saborizante_Sabor_id_sabor_fk` (`sabor`),
  KEY `Saborizante_Tipo_Saborizante_id_tipo_saborizante_fk` (`tipo_saborizante`),
  CONSTRAINT `Saborizante_Marca_id_marca_fk` FOREIGN KEY (`marca`) REFERENCES `Marca` (`id_marca`) ON UPDATE CASCADE,
  CONSTRAINT `Saborizante_Sabor_id_sabor_fk` FOREIGN KEY (`sabor`) REFERENCES `Sabor` (`id_sabor`) ON UPDATE CASCADE,
  CONSTRAINT `Saborizante_Tipo_Saborizante_id_tipo_saborizante_fk` FOREIGN KEY (`tipo_saborizante`) REFERENCES `Tipo_Saborizante` (`id_tipo_saborizante`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Saborizante`
--

LOCK TABLES `Saborizante` WRITE;
/*!40000 ALTER TABLE `Saborizante` DISABLE KEYS */;
INSERT INTO `Saborizante` VALUES (1,2,1,1,100,'2025-01-25',100),(2,2,2,1,50,'2025-01-31',50),(3,2,3,1,20,'2025-01-31',10);
/*!40000 ALTER TABLE `Saborizante` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tecnico`
--

DROP TABLE IF EXISTS `Tecnico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tecnico` (
  `usuario_tecnico` varchar(100) NOT NULL,
  `maquina` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `password` varchar(64) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`usuario_tecnico`),
  KEY `Tecnico_Maquina_id_maquina_fk` (`maquina`),
  CONSTRAINT `Tecnico_Maquina_id_maquina_fk` FOREIGN KEY (`maquina`) REFERENCES `Maquina` (`id_maquina`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tecnico`
--

LOCK TABLES `Tecnico` WRITE;
/*!40000 ALTER TABLE `Tecnico` DISABLE KEYS */;
INSERT INTO `Tecnico` VALUES ('chavatech',1,'Salvador','Arana','$2a$12$We6CncT0PaX/w0xCTqKeyewJjPxPe0hyYRWeD/ZmPn7OxU9qHyujy','mazl0nf3k@gmail.com'),('danatech',1,'Dana Sofia','Mora Villalobos','15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225','danamora700@gmail.com');
/*!40000 ALTER TABLE `Tecnico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tipo_Alergeno`
--

DROP TABLE IF EXISTS `Tipo_Alergeno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tipo_Alergeno` (
  `id_tipo_alergeno` int NOT NULL AUTO_INCREMENT,
  `alergeno` varchar(30) NOT NULL,
  PRIMARY KEY (`id_tipo_alergeno`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tipo_Alergeno`
--

LOCK TABLES `Tipo_Alergeno` WRITE;
/*!40000 ALTER TABLE `Tipo_Alergeno` DISABLE KEYS */;
INSERT INTO `Tipo_Alergeno` VALUES (1,'Productos Lácteos'),(2,'Productos Radioactivos');
/*!40000 ALTER TABLE `Tipo_Alergeno` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tipo_Fallo`
--

DROP TABLE IF EXISTS `Tipo_Fallo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tipo_Fallo` (
  `id_tipo_fallo` int NOT NULL AUTO_INCREMENT,
  `nombre_fallo` varchar(50) NOT NULL,
  `descripcion` varchar(500) NOT NULL,
  PRIMARY KEY (`id_tipo_fallo`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tipo_Fallo`
--

LOCK TABLES `Tipo_Fallo` WRITE;
/*!40000 ALTER TABLE `Tipo_Fallo` DISABLE KEYS */;
INSERT INTO `Tipo_Fallo` VALUES (1,'Otro','Especificalo');
/*!40000 ALTER TABLE `Tipo_Fallo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tipo_Saborizante`
--

DROP TABLE IF EXISTS `Tipo_Saborizante`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tipo_Saborizante` (
  `id_tipo_saborizante` int NOT NULL AUTO_INCREMENT,
  `tipo_saborizante` varchar(100) NOT NULL,
  PRIMARY KEY (`id_tipo_saborizante`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tipo_Saborizante`
--

LOCK TABLES `Tipo_Saborizante` WRITE;
/*!40000 ALTER TABLE `Tipo_Saborizante` DISABLE KEYS */;
INSERT INTO `Tipo_Saborizante` VALUES (1,'Natural');
/*!40000 ALTER TABLE `Tipo_Saborizante` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Usuario`
--

DROP TABLE IF EXISTS `Usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Usuario` (
  `email` varchar(255) NOT NULL,
  `medidas` int DEFAULT NULL,
  `cantidades` int DEFAULT NULL,
  `password` varchar(64) NOT NULL,
  `sexo` enum('Masculino','Femenino') NOT NULL,
  `fec_registro` date NOT NULL,
  `username` varchar(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `edad` tinyint NOT NULL,
  `fec_nacimiento` date NOT NULL,
  PRIMARY KEY (`email`),
  KEY `Usuario_Cantidades_id_cantidades_fk` (`cantidades`),
  KEY `Usuario_Medidas_id_medidas_fk` (`medidas`),
  CONSTRAINT `Usuario_Cantidades_id_cantidades_fk` FOREIGN KEY (`cantidades`) REFERENCES `Cantidades` (`id_cantidades`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Usuario_Medidas_id_medidas_fk` FOREIGN KEY (`medidas`) REFERENCES `Medidas` (`id_medidas`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Usuario`
--

LOCK TABLES `Usuario` WRITE;
/*!40000 ALTER TABLE `Usuario` DISABLE KEYS */;
INSERT INTO `Usuario` VALUES ('a21300624@ceti.mx',21,22,'$2b$12$X6hDk2IJsBf1f90elWxEaeakNSrJhODpmbHO470AdCJ/zvMKAZ4kW','Masculino','2025-05-07','Tay','Taylor','Swift ',18,'2006-06-03'),('dafely306@gmail.com',1,1,'$2b$12$Czf6AA8msiL.fqdDojLa9OxWtLsmdGhXWQo92bowXNEBkcUGymZ2K','Femenino','2025-03-09','Dafne','Dafne ','Vazquez',18,'2006-06-03'),('danamora700@gmail.com',3,3,'$2b$12$PHMTdb7hZcWNKCs002nfr.dFrVUUAn852QnrIffatQKtmNN8R8t5C','Femenino','2025-01-29','Dana','Dana Sofia','Mora Villalobos',18,'2006-06-10'),('elyoly@hotmail.com',19,20,'$2b$12$UygW9gXIK9fGB4azEaAAsOBQwHNKKlPFabuz4Lr.RaMQvjmbqWgk.','Femenino','2025-05-05','Elyoly','Elisa','Ortega',54,'1970-12-14'),('emmanuel369@gmail.com',6,6,'$2b$12$ET5Jtqej6jLQT7WtYW2cmuE2m4B2q/sEHPat7ukHBpcdtNlFd.G0a','Masculino','2025-03-23','Emmonuel','Emmanuel','Cruz',19,'2006-03-06'),('mzl.salva@gmail.com',2,2,'$2b$12$3F3TnKZyTUe07MyprBPmOOAIV5f6h2VY1sr5XA7TmE3HnjIAZhv0i','Masculino','2025-01-29','Zynths','Salvador','Arana',22,'2002-09-18'),('panchiloholly@gmail.com',18,19,'$2b$12$CBiFLz7TBFlVVqe3G0Tejuxk.0FkfVT7D3QRfG2t1doFFUkgDl4C6','Femenino','2025-05-05','Nanely','Dafne Elizabeth ','Vazquez Ortega ',18,'2006-06-03'),('twinsdafxitla@gmail.com',5,5,'$2b$12$8jYRgvcfZmHlADRfZaqjH.KCEhkoyKLMbpFH1HJJlgJh3rvTEFKD.','Femenino','2025-03-23','Xitla','Xitlalli','Cruz',18,'2006-06-03');
/*!40000 ALTER TABLE `Usuario` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-07  7:23:32
