-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Alergia_Usuario`
--

LOCK TABLES `Alergia_Usuario` WRITE;
/*!40000 ALTER TABLE `Alergia_Usuario` DISABLE KEYS */;
INSERT INTO `Alergia_Usuario` VALUES (2,'dafely306@gmail.com',1),(4,'danamora700@gmail.com',1);
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Cantidades`
--

LOCK TABLES `Cantidades` WRITE;
/*!40000 ALTER TABLE `Cantidades` DISABLE KEYS */;
INSERT INTO `Cantidades` VALUES (1,20,9),(2,40,7),(3,28,5),(4,35,5),(5,35,5),(6,26,10);
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Compra`
--

LOCK TABLES `Compra` WRITE;
/*!40000 ALTER TABLE `Compra` DISABLE KEYS */;
INSERT INTO `Compra` VALUES (1,'pedido_prueba',100,'2025-02-25 00:15:06'),(3,'pedido2',10.25,'2025-02-01 00:13:16'),(4,'pedido3',147,'2025-02-27 00:13:34'),(5,'8a750ee4b67cd4da035f51f673b0b9899e951b98428a8114c45437977609a0ae',60,'2025-03-02 20:23:00');
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
INSERT INTO `Dueno` VALUES ('dafnetech',1,'Dafne Elizabeth','Vazquez Ortega','15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Fallo`
--

LOCK TABLES `Fallo` WRITE;
/*!40000 ALTER TABLE `Fallo` DISABLE KEYS */;
INSERT INTO `Fallo` VALUES (1,1,1,'2025-01-25 00:11:41','Prueba de fallo 1'),(2,1,1,'2025-01-25 11:41:00','prueba de fallo 2');
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
INSERT INTO `Inv_Curcuma` VALUES (1,1,1,92,'2025-01-31','2025-01-25 00:09:57','2025-03-28','2025-03-30');
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
INSERT INTO `Inv_Proteina` VALUES (1,1,1,42,'2025-09-15','2025-02-03 00:00:00','2025-03-20','2025-03-22'),(2,2,1,100,'2025-01-30','2025-03-30 01:05:55','2025-03-18','2025-03-20');
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
INSERT INTO `Inv_Saborizante` VALUES (1,1,1,42,'2025-09-15','2025-02-03 00:00:00','2025-03-18','2025-03-20');
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Marca`
--

LOCK TABLES `Marca` WRITE;
/*!40000 ALTER TABLE `Marca` DISABLE KEYS */;
INSERT INTO `Marca` VALUES (1,'Birdman'),(2,'Deiman'),(3,'Nature Heart');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Medidas`
--

LOCK TABLES `Medidas` WRITE;
/*!40000 ALTER TABLE `Medidas` DISABLE KEYS */;
INSERT INTO `Medidas` VALUES (1,20.76,60,170,80,85,20,'2025-01-29'),(2,24.22,70,170,65,75,17,'2025-01-29'),(3,22.22,72,180,85,85,25,'2025-01-29'),(4,23.44,60,160,70,80,22,'2025-03-02');
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
INSERT INTO `Pedido` VALUES ('8826d54ee61dc3efbfae6be5458323519b5bcfe9a75b542be9b1acdcfef8737b','dafely306@gmail.com',2,1,2,NULL,'no_canjeado',NULL,32,10),('8a750ee4b67cd4da035f51f673b0b9899e951b98428a8114c45437977609a0ae','danamora700@gmail.com',1,NULL,1,NULL,'no_canjeado',NULL,25,NULL),('e7a37cbe75f56c5e77d62baaf12210c13dc7757441c0c60e883d5e0229385627','dafely306@gmail.com',2,NULL,2,NULL,'no_canjeado',NULL,32,NULL),('pedido_prueba','dafely306@gmail.com',1,1,1,1,'no_canjeado','2025-01-25 00:13:09',10,5),('pedido2','dafely306@gmail.com',2,1,1,2,'canjeado','2025-03-02 21:39:25',5,2),('pedido3','dafely306@gmail.com',1,NULL,3,1,'no_canjeado','2025-01-31 00:09:46',20,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Proteina`
--

LOCK TABLES `Proteina` WRITE;
/*!40000 ALTER TABLE `Proteina` DISABLE KEYS */;
INSERT INTO `Proteina` VALUES (1,1,'Vegetal','Falcon Protein','Proteinas: muchas',1.5,'2025-01-25',70),(2,2,'Animal','Pure And Natural','Proteinas: muchas',2,'2025-01-28',69.99);
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
INSERT INTO `Tecnico` VALUES ('danatech',1,'Dana Sofia','Mora Villalobos','15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225','danamora700@gmail.com');
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
  CONSTRAINT `Usuario_Cantidades_id_cantidades_fk` FOREIGN KEY (`cantidades`) REFERENCES `Cantidades` (`id_cantidades`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Usuario_Medidas_id_medidas_fk` FOREIGN KEY (`medidas`) REFERENCES `Medidas` (`id_medidas`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Usuario`
--

LOCK TABLES `Usuario` WRITE;
/*!40000 ALTER TABLE `Usuario` DISABLE KEYS */;
INSERT INTO `Usuario` VALUES ('dafely306@gmail.com',1,1,'$2a$12$sJeYHLiXu20OBxpw8MZ3V.hCuIPJwLeNdDenaGC9NmmQseelesAKm','Femenino','2025-01-29','Dafne','Dafne Elizabeth','Vazquez Ortega',18,'2006-06-03'),('danamora700@gmail.com',3,3,'$2a$12$lFATc4HOqXOB.gOzQ1ByruZX8luouPbh9MFfgB00pxsshXbby16Vq','Femenino','2025-01-29','Dana','Dana Sofia','Mora Villalobos',18,'2006-06-10'),('mazl0nf3k@gmail.com',NULL,NULL,'$2b$12$mD2UvUfuCzGwjItHl3BAWuQ/S3yfWwt9n10ifLv6H/dcVq9aiZb92','Masculino','2025-03-05','String','Juan','Perez',25,'2000-03-05'),('mzl.salva@gmail.com',2,2,'$2a$12$297EVRIerlZrJgB9RbhWqe.jrIMtKADQrS.r8KV5wgYq4W1wN1Q5u','Masculino','2025-01-29','Salvador','Salvador Chava','Arana Mercado',22,'2002-09-18');
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

-- Dump completed on 2025-03-05  4:57:10
