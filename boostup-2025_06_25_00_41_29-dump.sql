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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Alergeno_Proteina`
--

LOCK TABLES `Alergeno_Proteina` WRITE;
/*!40000 ALTER TABLE `Alergeno_Proteina` DISABLE KEYS */;
INSERT INTO `Alergeno_Proteina` VALUES (1,2,1),(2,1,2),(3,1,3),(4,1,4),(5,1,5);
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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Alergia_Usuario`
--

LOCK TABLES `Alergia_Usuario` WRITE;
/*!40000 ALTER TABLE `Alergia_Usuario` DISABLE KEYS */;
INSERT INTO `Alergia_Usuario` VALUES (2,'danamora700@gmail.com',1),(3,'mzl.salva@gmail.com',2),(6,'mzl.salva@gmail.com',3),(10,'emmanuel369@gmail.com',1),(11,'dafely306@gmail.com',3),(12,'dafely306@gmail.com',4),(17,'panchiloholly@gmail.com',1),(21,'a21300624@ceti.mx',3);
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
  `curcuma_gr` float NOT NULL,
  PRIMARY KEY (`id_cantidades`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Cantidades`
--

LOCK TABLES `Cantidades` WRITE;
/*!40000 ALTER TABLE `Cantidades` DISABLE KEYS */;
INSERT INTO `Cantidades` VALUES (1,13,34.23),(2,25,34.23),(3,28,34.23),(4,20,34.23),(5,16,34.23),(6,23,34.23),(7,19,34.23),(19,20,34.23),(23,19,34.23),(24,21,34.23),(25,20,34.23),(26,17,34.23),(27,22,34.23),(28,22,34.23),(29,22,34.23);
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
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Compra`
--

LOCK TABLES `Compra` WRITE;
/*!40000 ALTER TABLE `Compra` DISABLE KEYS */;
INSERT INTO `Compra` VALUES (8,'afcbf616751388c608fdc0380e07527007f19338823f88a326d3b9a058f91673',80,'2025-03-18 01:08:53'),(9,'35b2a5d048fb1a1a41d87b464d2fedcd43db784bd960abfb70d9a12f3f2d8a88',70,'2025-03-19 01:00:51'),(10,'edf45706ca1b4e0e51f903f7df57368cd04e51a0569c3d6be386200e5847a7e0',70,'2025-03-20 01:05:26'),(11,'0bce1738f044bad798aa47b19c5526aec5c7e9269e343a27f07cdbf78c577213',70,'2025-03-20 01:11:36'),(12,'e1fc86eb9fca2ff2b5da6299fc88f484e2785cae7cfabcf73e58738d3b52ddf7',80,'2025-03-20 03:47:18'),(13,'bcb93f790639e6a40802438a3933fb0c5297cbdaaa4be87a17ffed18f3b20bdd',70,'2025-03-20 03:49:49'),(14,'afe9cddc631fe64d770ed5e4662ebd801ee368041d4bc2d13facd6ccf267b261',80,'2025-03-23 21:14:34'),(15,'387e57a8b3c58bdf4c5dcf51683a64988408284736ed31c4c1fab3b256897124',80,'2025-04-19 20:11:19'),(16,'78f2110345ce0da0d18483ed38a5e651001decebc85d26e918838348c595c402',80,'2025-04-29 05:34:14'),(17,'d5fd1c69e3042a7413d31e166e9d1cdab08c5d66c7b9eaeb445eaf80b71ce49b',80,'2025-04-29 05:35:42'),(18,'9c0c29cac8b0806204256c2bcfc393f04e6ea7451a6b1d3dac0519acc228c2ef',80,'2025-04-29 05:41:35'),(19,'fcdd205ba7bf3a434c91b20885d7bfa1f4ae428e2e0fe5b293d8fc1f4f355f02',80,'2025-05-01 23:58:45'),(20,'e538efad5ba178aa913c56b82245a83cfbee2ce1016024ba7d3a759260deb73e',80,'2025-05-02 00:16:50'),(21,'5a36fbb8767983b395ec72955a80d4c3c79bd22a7dda84c7b71db1326d9c94b0',70,'2025-05-06 01:07:04'),(22,'03589863301e468860376dbd17d755f4661484249e2b350ac582d91e4552b3c0',70,'2025-05-06 02:00:16'),(23,'e69dbaa7ada43bbd18c01c5b4f4d4d8fc17a8e4eac4501c2bf5cc2aea0ffa9b2',70,'2025-05-06 02:12:29'),(24,'d4006cb37bed2bb998fdc6180fe0fc4045ebc9eb9834015e2ff06c250198ed8d',70,'2025-05-06 02:16:00'),(25,'1529920d250b854f3ccf8d6e7515339487c71ea7e89acf45fdc4cffc6c0047ec',70,'2025-05-06 07:05:41'),(26,'9a6b3c06e968e5667f689f8900dd1f2e0264253bc39e1ce75dcc3e96c9fb384f',70,'2025-05-06 07:07:02'),(27,'f1ea253faac333a8f8d086876fa0987bf7b5148d024e3348f2536f8ed3314541',80,'2025-05-06 07:20:09'),(28,'338958692290ea0efebb3992edf30401c57ede7f666a3d1d894f2394e4f1b290',80,'2025-05-06 08:32:10'),(29,'7343f5ebf20809fd2773e32552a04f922b3457c9dbb39e0f2c5e5867d09e0e6d',80,'2025-05-06 08:48:10'),(30,'0a73060f045dac88f79ef1c1f54887dd7e2d68ed5db47144cd1741cd2c94ecc3',70,'2025-05-06 08:48:49'),(31,'c4efc0ec1ab9c6734cb3eb62cea50004dc488a09c08ad330c90361fc6409aa9d',80,'2025-05-06 09:17:57'),(32,'f396ab781ff43641701a95082d3a2361e643810c2d572b5464d414a9cbc5bd0e',80,'2025-05-06 09:19:37'),(33,'fccbf15ec8cfd3e95172bf3f07b127da6d45f341561a1e9c8df5cf345d6594b1',70,'2025-05-06 22:04:01'),(34,'c281b648313602af1aa3210792d4f4b79a258edfebbe5070af486268bac20291',70,'2025-05-06 22:19:05'),(35,'7fa370cfff84d176136a707a3158731703fcea1ddb0abe8c8b64aa6af204eedd',80,'2025-05-06 22:23:50'),(36,'c910a58334c3b775a02fdd248d01b866e804a3d2152a4332b131a8f787392872',80,'2025-05-06 22:25:31'),(37,'72312b4d0b8471cfe32087987ea9c36a794c57e073f8de28dd658031be4d7b3c',70,'2025-05-07 00:02:13'),(38,'5326aaeda3bc450718c9fc5759fa8e1cda36bf543faebcb24ce67787524a7826',80,'2025-05-07 00:09:26'),(39,'021b79ab62b0e15239910010dfa37be36dfe1de36610a4721d5db347da9823ab',80,'2025-05-07 00:25:09'),(40,'36a0233395fedd88bcbddcf2cdf81f1ebab4e092186f11e69721c19e30cf70fc',80,'2025-05-07 00:45:10'),(41,'0046bf00b1d561c76a39a8273e59cbdc13d85109f1c28452ca397015e0333be1',80,'2025-05-07 01:10:58'),(42,'e96c2eb7b955c6e24f47770625853f3020ea35d847ed40464c71681c6c772cdf',80,'2025-05-07 01:21:53'),(43,'086a4dfff6b1ae81b2c5035be02d7ba687fca6d6c4f7d1b24f3d2a129f7a1d80',80,'2025-05-07 01:24:20'),(44,'4fd681c40850194294eaf2118a2b2ac9cdb8c8128b5f29b80e3455def8f50963',80,'2025-05-07 01:25:04'),(45,'d4b983e3efe84e08319e3b7415911ce21a8207f1c4cdfcdc9b532143b516a99a',70,'2025-05-07 01:26:14'),(46,'394b89b169d453ae72d5b8c72d7fb50c0ad205a2bf311311aca11b622c3bdcbb',80,'2025-05-07 01:29:50'),(47,'ae82ae0013d6dcb2d4a376f6cc1a7e082eafefa59ab47e8662b48ea19be0c7bb',80,'2025-05-07 01:39:47'),(48,'da9cb915498bf960177ae2876e5adf89a38ff6d6f4af4f3b4c1ccfef23f67286',70,'2025-05-07 01:42:44'),(49,'22bf7791333d56b5ea121c9d1b74314b58b5183acb1603133460c617c470fdd7',80,'2025-05-07 18:20:23'),(50,'d720940e1b7d52e5c674e13b73367befb535cab172fa562a6c8e3a272785f4ac',80,'2025-05-08 02:11:32'),(51,'600c58812ee5824a074dc967e4c9f3daf7fae54897491c43387e9c001f36869d',80,'2025-05-08 02:35:53'),(52,'fb2053ed5695b5c0696b3aab80b3a0e322fec3736ab29e63d541dc0ae598db5d',80,'2025-05-08 03:38:13'),(53,'5223f66b5b20f081ef0b84798d4a26d821529016618012d3bc960bdff627d6f7',80,'2025-05-08 03:39:41'),(54,'ecf24a43952e1e584f9a223e727b2c11ad11021247446e512fe6b6772f0b3637',80,'2025-05-08 03:49:58'),(55,'74b71bfd3e34e87f85afd3a3398f52fba8cd5d4c517a3384b3e69f208926c87d',80,'2025-05-08 08:10:26'),(56,'ee2bf9ae81e68bb48305dbff7c12fda190b87faca213082def4cdb1e7da8c67a',80,'2025-05-08 08:22:45'),(57,'2762e49f6928090055068934c5f06006fd209ad79ef3b8a396cc66973c22446a',80,'2025-05-09 19:45:32'),(58,'6a1fdb990403fcdecab95f65d3fe293184dce1572694fdc0365d1a5e1e1b47e6',70,'2025-05-09 19:48:44'),(59,'52ff536d5eaeee93baf66d6832ff676abc70267edc84aa3277f9723593372d5e',80,'2025-05-18 23:04:27'),(60,'84e8049a1487657f78f0787917f27df805c70fa8e847586063d6bff89e723772',70,'2025-05-18 23:04:52'),(61,'a28db83d21b3a329274d2721c0d1d9542c3f4584b2acc9754e645310bb58a3bf',70,'2025-05-18 23:19:12'),(62,'0c755a9b3e31d9d7baa557569fa10b8b5e8c5e555f66f370b5bf4ef93274e9bb',80,'2025-05-19 00:20:32'),(63,'975cf948441ad9586778bcd0995aba73074fa24c743125bf2f9dbd0a360c2563',80,'2025-05-19 00:24:43'),(64,'5a186cefb76dd3d9698a92fdbba5cab00ce0f585c2fa259d43cc6337792d7a98',80,'2025-05-19 00:47:32'),(65,'4a17d603bd429a156d29867df91bfc4d740c59f8de9b6f3a6fd761a5ea52fd6c',70,'2025-05-19 01:36:30'),(66,'69251b5f764fa60b6a796ec5072cd2ef51d4e5fa3e25c3ab43e01913d1f8fe4d',70,'2025-05-19 01:38:44'),(67,'cce74d4e72e2e3a5ee812a04417b52c67b2d9ec51721853657854f1fa75a726f',70,'2025-05-19 01:48:33'),(68,'58103e2df61bfeb5fda9cb1fed0a889834a969874652cc6ad7b15bef44b2819d',70,'2025-05-19 01:52:42'),(69,'d4fb9bcb9f3218f0d02eacf6daaabd090e0ab13c1e7a85b026c0443e8d206749',70,'2025-05-19 01:57:03'),(70,'389dd7eb8dee55b7046ea0d70490acbe5df63f7dedb70b48b598e10905e029b1',70,'2025-05-19 01:58:00'),(71,'0e304c78cbc0f5f656c89637bfdc6365e84bbe2857d35f46ad03e56432b9d257',70,'2025-05-19 03:12:42'),(72,'273f299232888d9625938d2bf543fc7227a826f9d9eb392e34fb6f0df3f39e72',70,'2025-05-19 21:52:45'),(73,'f36580290b1afa86275992eba2b032ce86e3cfe5e6e3f14fd540a6efe3bed258',80,'2025-05-19 21:53:32'),(74,'97e27ad9e1dbc739a487046c31999fd7378cca5f59ef6619b7c424432824c719',80,'2025-05-19 21:57:39'),(75,'e13bda611c9e7f365e60b551b1069efbc9ab61bda23b63c1853538b6d9d9bd0c',70,'2025-05-19 21:58:09'),(76,'054d74c50511a787058380651a62d6bc4a509795ffab75d82ee82ae5d740ea0e',80,'2025-05-20 08:47:20'),(77,'818fb8ac7439bbe71c89c9c89b0116e13dda38530735c2d504f919e05acd3bb2',80,'2025-05-20 08:59:49'),(78,'6aa34f95bfa9b4493fd9e6f3a8668d0a0e2a3bb9bc9e4a481ed2b6cd801c5123',80,'2025-05-21 08:36:46'),(79,'5407c5ac35f930512279a2cc71a23a0df673abd5e47ca37cb7ce3c99f2e8224f',80,'2025-05-21 10:31:18'),(80,'f830bfe505ea3212afa1db9261e8be7f309e2036dff794d6667a3c536a09c799',70,'2025-05-23 11:47:55'),(81,'69ed173d0686aa770e84134f6cb42525f7a9e0e9ca513ab2769ed173d0686aa7',80,'2025-05-25 20:59:54'),(82,'DONT_REDEEM_ME_b356536bef06acd15f525a7f5a9a4ef3f46b04e8b9f04c9e7',70,'2025-05-25 21:17:52'),(83,'063a4ec7f6c506bcfb0409c3e38683937aa2334e9f9ba61b39ba4172667f9c7a',80,'2025-05-27 05:50:30'),(84,'f5879fa215bb12f31bb08ecd01e7b7085b3adc4bd72591026f4c8aca87ac6ea1',80,'2025-05-27 05:54:17'),(85,'23764e6a17f7498cfb3163c97794edc50bcd10cc3ce900a9e6b4036c464c99e8',70,'2025-05-28 16:10:20'),(86,'05a75ee9fcb61b149d8de8ec209db31e6daca86306505bc3f49f0b1d75bb800d',80,'2025-06-07 23:17:34'),(87,'002de412c34d0df25fe36a663507915a5734a3ea292fa5693cc5b0e5c0fbe74c',80,'2025-06-07 23:21:32'),(88,'NO_INGREDIENTES_faaba12fea6cd9de54d3a7112b830d05572816c7a5db4fef',80,'2025-06-08 20:28:12'),(89,'HUMEDAD_ALTA_acd8183936f846dec0556fe6e830b6236e01a2760b6915dce4f',70,'2025-06-08 21:43:01'),(90,'445307c84fe6c22f540d7e0755b90b55e0f45117ed019aa99c5a6cbd63bbf4af',80,'2025-06-09 00:29:41'),(91,'28d4c3e757890fb88006d4b124722a46f3cd07083b9989a7eb1bb779a51b754c',70,'2025-06-09 00:35:36'),(92,'3afb0c26bb89bf68ad98b8fc3462ed343a3a784bca01fbca0e7e48e2b5732f89',70,'2025-06-09 09:42:08'),(93,'83fde1500bb6fc526761eba37ceace1a810610e509669c90a825498cbea6c1a7',70,'2025-06-09 09:44:02'),(94,'0b5c1218de77e3c6889e45b9d96c3233891d1794365fa192a4a51aa51f7299df',70,'2025-06-09 10:00:58'),(95,'83a718568404004669452e531459ff3369476e957999b070d321f966ae4688ed',80,'2025-06-09 10:12:16'),(96,'3712644aedcff77540d7a856514d9786121b0dffa4d0ce4bf9226d829f269b42',70,'2025-06-09 10:25:14'),(97,'dd0bbb5c0fe48716429e0798b78bf09e471275ba5283a850671541e15be5621e',70,'2025-06-09 10:31:51'),(98,'dbef681e3f15ea3b90319dd94d313df8f4c416ba56a0179a7b57f755a73721b2',70,'2025-06-09 10:42:06'),(99,'ac97bda8f80ee7edfb423d91189da4ff8ca3ab2e3276c4a6d419515faf9ce4ef',70,'2025-06-09 10:44:19'),(100,'83d5c69b7f5f9e74372923a0ddb92632778be83d1b2ab14ad685e1c4c15a82a2',70,'2025-06-09 10:58:46'),(101,'156385a68229bafa6269fed80ed2ce4a44881a93baff0c9bf0627760967b8321',70,'2025-06-09 11:02:28'),(102,'48f46bc0b4e4c74261cd1c4ecbe884932fa2c95143f44f57be34afe5d6cae1e0',70,'2025-06-09 11:24:50'),(103,'250f482d60a7962e126b2658e66ed4ff9a5baf98653b8541e0f918d67b6020bd',80,'2025-06-09 11:39:25'),(104,'c04ac63cf3ed3450e7c104b71b320b4fa7b1611c8e53e0b348da0a9bbbc2fca7',70,'2025-06-09 11:54:32'),(105,'c0925ad466724c03370c7a0c0c65d13b02544014cc40fd36b36e7037820ddd38',80,'2025-06-09 12:14:52'),(106,'328dc08b360e654beb610ba38dff67a66adcfc2046f1895bac9abcfd36806936',70,'2025-06-09 12:53:43'),(107,'e57cd30a9878ed97d59a15f30882f71567cad5a5d006898a07b6666ed8f72c25',70,'2025-06-09 12:54:58'),(108,'92e030dd5097c0c0c22d626d9456c1c37318d476766445dfaca323df2d168fd9',70,'2025-06-09 13:06:20'),(109,'04c85d737eff107dee5787f4f61efbd746286f18a383c20472fbbf92c526235c',80,'2025-06-13 09:16:27'),(110,'b3f79fc614883696447ddc57a8b9a78df7040ea4ef19264dfa3274a6bead6891',80,'2025-06-13 09:23:28'),(111,'d4313e6b6f00eb1dc2f3f0490502a30da9f0bd1f4112b842d8fc89be9e0b8264',80,'2025-06-13 10:29:05'),(112,'503611e42b2115c327535b614b4bb699168e09087e9d210ca1c21adfb7fe22b0',80,'2025-06-13 10:37:00'),(113,'ef656afa907e4cd594098d5785b25c4e9a0039a6330e3ad2a76b3a6dc988637b',80,'2025-06-13 11:19:41'),(114,'235fe4c6048d3cc164f432f8c16dd074f60422e607a15869a442db00d7b4dea8',80,'2025-06-13 12:04:49'),(115,'6c16ab922b24fc3ec3c92120a9c732249b6340696d4387c9dda3ae0cfd75467e',70,'2025-06-13 12:34:35'),(116,'e70b8df5fc57d0fb71702508b1a4e8a3b9029e80d5648e53a9faa4f4c115ff1c',70,'2025-06-13 13:14:46'),(117,'81e794dc8eb45e400c13a9f64a72059cd9f5a3f68e7d053fc4bf2f62bf1fb8be',80,'2025-06-13 13:28:05'),(118,'36208ad8fb6d8c026e25167566454938236eec1e9d0aa3b3b2a2f228fd6bde63',80,'2025-06-13 13:45:06'),(119,'a6ca1efea7bcc08ac806d8cf9b11f993a68390dafa1a7f546768f62bd109da38',70,'2025-06-13 14:14:35'),(120,'8e1fc64d49e12bad394da2e8be461ab77afdd084f40406994d6f25f590ebf63e',80,'2025-06-13 14:58:15'),(121,'476e1a97d910694e02fff1f838e119f610e3bb7c2e61c7e586125461aea6067b',80,'2025-06-13 15:01:07'),(122,'80be4460dedd02530a06c9c1ac0cad985c82e5418eeea9ac3fb0594ee092e513',80,'2025-06-13 15:20:45'),(123,'c4cee8ec8b338dbaff0b3aec4d6dd5debeaf2162e1ddac438b3e02e43d339093',80,'2025-06-13 15:39:38'),(124,'2258493d6f87452a622fb0fb2023e1923796aa0a1e502877e42357ec56b9a6fc',70,'2025-06-13 15:51:31'),(125,'de19047c46eb362ca081465af48692b145446248474e06dc1d5b7e1b1d011604',80,'2025-06-13 15:58:28'),(126,'e51810c0fd038f3a0e63099feb520bc20bcd7e8e4937ff23e5ee25973716fe03',80,'2025-06-13 16:17:56'),(127,'34c141ac73f23339b40ab5d80f39653b17115503c4316a7a9ede35235e3c72e4',80,'2025-06-13 16:31:04'),(128,'2c2a2296104f1ce350e107a52b9f21d38f4b284989b001b80e5a6d3a32814ae1',70,'2025-06-15 16:05:46');
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
INSERT INTO `Curcuma` VALUES (1,3,2,4,'Si usas medicamento consulta con tu médico antes de consumir.\n\nPlaneas embarazo o estás en lactancia: Evita su uso o consulta a tu medico.\n\nTienes problemas hepáticos, biliares o renales: Discute la pertinencia del uso con un especialista','2025-01-25',10);
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
INSERT INTO `Dueno` VALUES ('dafnetech',1,'Dafne Elizabeth','Vazquez Ortega','$2a$12$zrWqGDz4/0cu8taGrEePe.31yE1UFBPmfEJB4fUrN07Zyf1T6WOlS'),('danatech',1,'Dana Sofia','Mora Villalobos','$2a$12$NZw0ngjVA/BRGhsr2c9fwuoy7gefdt98zLH/XHjqHZfv98mTZAZBe');
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Fallo`
--

LOCK TABLES `Fallo` WRITE;
/*!40000 ALTER TABLE `Fallo` DISABLE KEYS */;
INSERT INTO `Fallo` VALUES (1,1,1,'2025-01-25 00:11:41','Prueba de fallo 1'),(2,1,1,'2025-01-25 11:41:00','prueba de fallo 2'),(3,1,1,'2025-05-07 13:09:09','No jodas la maquina se pudrio'),(4,1,1,'2025-05-07 13:16:40','Ya se volvio a safar el dese de la desa'),(5,1,3,'2025-05-18 19:16:36','falla bien feo la tablet'),(6,1,1,'2025-05-18 19:18:38','tengo hambre'),(7,1,1,'2025-05-19 04:32:35','La máquina otra vez de despedorro'),(8,1,1,'2025-05-19 04:32:35','La máquina esta fallanding'),(9,1,1,'2025-05-20 08:42:01','fallaaa'),(10,1,2,'2025-05-20 08:42:30','Prueba de fallo 3'),(11,1,1,'2025-06-09 11:02:36','max estuvo aquí'),(12,1,1,'2025-06-09 11:02:41','max estuvo aquí'),(13,1,3,'2025-06-09 12:22:51','no jala'),(14,2,1,'2025-06-11 00:52:13','Emails work again!'),(15,1,3,'2025-06-13 12:48:18','fallo la máquina');
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
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Historial_Humedad`
--

LOCK TABLES `Historial_Humedad` WRITE;
/*!40000 ALTER TABLE `Historial_Humedad` DISABLE KEYS */;
INSERT INTO `Historial_Humedad` VALUES (1,1,80,'2025-02-02 23:58:20'),(2,1,20,'2025-05-09 06:22:18'),(3,1,90,'2025-05-09 06:43:05'),(4,1,90,'2025-05-09 06:45:09'),(5,1,69,'2025-05-18 22:11:13'),(6,1,69,'2025-05-18 22:11:46'),(7,1,69,'2025-05-18 22:12:32'),(8,1,69,'2025-05-18 22:12:52'),(9,1,69,'2025-05-18 22:13:08'),(10,1,69,'2025-05-18 22:13:48'),(11,1,69,'2025-05-18 22:14:09'),(12,1,10,'2025-05-19 01:42:53'),(13,1,10,'2025-05-19 01:44:02'),(14,1,10,'2025-05-19 01:47:36'),(15,1,10,'2025-05-19 01:49:39'),(16,1,10,'2025-05-19 01:50:21'),(17,1,10,'2025-05-19 01:52:12'),(18,1,10,'2025-05-19 01:52:55'),(19,1,10,'2025-05-19 01:54:27'),(20,1,10,'2025-05-19 01:57:15'),(21,1,10,'2025-05-19 01:57:40'),(22,1,10,'2025-05-19 01:58:11'),(23,1,50,'2025-05-19 02:08:06'),(24,1,50,'2025-05-19 02:10:28'),(25,1,50,'2025-05-19 02:11:54'),(26,1,50,'2025-05-19 02:16:53'),(27,1,50,'2025-05-19 02:20:45'),(28,1,50,'2025-05-19 02:24:37'),(29,1,50,'2025-05-19 02:30:09'),(30,1,50,'2025-05-19 02:33:42'),(31,1,10,'2025-05-19 03:16:27'),(32,1,10,'2025-05-19 03:16:43'),(33,1,10,'2025-05-19 03:17:33'),(34,1,10,'2025-05-19 03:17:49'),(35,1,10,'2025-05-19 03:18:48'),(36,1,10,'2025-05-19 03:20:57'),(37,1,10,'2025-05-19 03:25:16'),(38,1,10,'2025-05-19 03:25:37'),(39,1,10,'2025-05-19 03:34:59'),(40,1,10,'2025-05-19 03:40:32'),(41,1,10,'2025-05-19 03:46:42'),(42,1,10,'2025-05-19 04:21:57'),(43,1,10,'2025-05-19 04:25:21'),(44,1,10,'2025-05-19 04:27:20'),(45,1,10,'2025-05-19 04:31:00'),(46,1,10,'2025-05-19 04:31:08'),(47,1,10,'2025-05-19 04:46:03'),(48,1,50,'2025-05-19 21:53:03'),(49,1,50,'2025-05-20 00:07:42'),(50,1,50,'2025-05-20 08:30:38'),(51,1,50,'2025-05-20 08:47:40'),(52,1,50,'2025-05-25 21:09:58'),(53,1,50,'2025-05-26 00:47:44'),(54,1,50,'2025-05-26 00:47:53'),(55,1,50,'2025-05-26 00:48:04'),(56,1,99,'2025-05-27 00:50:53'),(57,1,90,'2025-05-27 00:51:46'),(58,1,90,'2025-05-27 00:52:53'),(59,1,53,'2025-05-27 05:47:37'),(60,1,54,'2025-05-27 06:00:26'),(61,1,94,'2025-05-27 06:52:19'),(62,1,94,'2025-05-27 06:52:19'),(63,1,94,'2025-05-27 06:52:19'),(64,1,95,'2025-05-27 06:52:58'),(65,1,95,'2025-05-27 06:52:58'),(66,1,95,'2025-05-27 06:52:58'),(67,1,96,'2025-05-27 06:53:10'),(68,1,96,'2025-05-27 06:53:10'),(69,1,96,'2025-05-27 06:53:10'),(70,1,96,'2025-05-27 06:53:25'),(71,1,96,'2025-05-27 06:54:53'),(72,1,79,'2025-05-27 06:55:52'),(73,1,94,'2025-05-27 07:02:44'),(74,1,94,'2025-05-27 07:02:44'),(75,1,94,'2025-05-27 07:02:44'),(76,1,94,'2025-05-27 07:03:45'),(77,1,89,'2025-05-27 07:04:13'),(78,1,90,'2025-05-27 07:08:13'),(79,1,90,'2025-05-27 07:09:45'),(80,1,61,'2025-06-04 00:39:03'),(81,1,63,'2025-06-06 07:54:23'),(82,1,64,'2025-06-07 00:28:33'),(83,1,64,'2025-06-07 00:28:47'),(84,1,65,'2025-06-07 01:44:16'),(85,1,0,'2025-06-08 20:57:06'),(86,1,50,'2025-06-08 21:02:21'),(87,1,90,'2025-06-08 22:08:19'),(88,1,90,'2025-06-08 22:13:04'),(89,1,90,'2025-06-08 22:13:04'),(90,1,55,'2025-06-09 09:37:59'),(91,1,53,'2025-06-09 09:43:16'),(92,1,53,'2025-06-09 10:01:33'),(93,1,0,'2025-06-09 10:33:05'),(94,1,49,'2025-06-09 10:45:07'),(95,1,0,'2025-06-09 11:03:28'),(96,1,48,'2025-06-09 11:25:57'),(97,1,47,'2025-06-09 11:40:12'),(98,1,0,'2025-06-09 12:00:31'),(99,1,43,'2025-06-09 12:29:02'),(100,1,46,'2025-06-09 13:00:14'),(101,1,45,'2025-06-09 13:07:33'),(102,1,74,'2025-06-13 09:16:50'),(103,1,73,'2025-06-13 09:23:53'),(104,1,70,'2025-06-13 10:29:19'),(105,1,62,'2025-06-13 11:21:13'),(106,1,59,'2025-06-13 12:05:35'),(107,1,58,'2025-06-13 12:41:41'),(108,1,53,'2025-06-13 13:15:35'),(109,1,54,'2025-06-13 13:47:15'),(110,1,52,'2025-06-13 14:16:31'),(111,1,52,'2025-06-13 14:58:44'),(112,1,52,'2025-06-13 15:04:00'),(113,1,50,'2025-06-13 15:21:51'),(114,1,49,'2025-06-13 15:52:56'),(115,1,48,'2025-06-13 15:59:38'),(116,1,49,'2025-06-13 16:18:26'),(117,1,48,'2025-06-13 16:31:32');
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
  `cantidad_gr` float NOT NULL,
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
INSERT INTO `Inv_Curcuma` VALUES (1,1,1,5519.51,'2025-06-30','2025-06-09 01:34:15','2025-06-21','2025-06-30');
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
INSERT INTO `Inv_Proteina` VALUES (1,1,1,22,'2025-06-30','2025-06-13 15:52:40','2025-06-03','2025-06-13'),(2,2,1,45,'2025-06-30','2025-06-13 15:21:35','2025-06-03','2025-06-13');
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Inv_Saborizante`
--

LOCK TABLES `Inv_Saborizante` WRITE;
/*!40000 ALTER TABLE `Inv_Saborizante` DISABLE KEYS */;
INSERT INTO `Inv_Saborizante` VALUES (1,2,1,40,'2025-06-30','2025-06-09 01:29:39','2025-06-06','2025-06-16'),(2,1,1,78,'2025-06-30','2025-06-09 01:30:10','2025-06-12','2025-06-22'),(3,3,1,102,'2025-06-30','2025-06-09 01:32:59','2025-06-21','2025-06-30');
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
INSERT INTO `Maquina` VALUES (1,'C. Nueva Escocia 1885, Providencia 5a Secc., 44638 Guadalajara, Jal.'),(2,'Av Naciones Unidas 6700, Loma Real, 45129 Zapopan, Jal.');
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
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Medidas`
--

LOCK TABLES `Medidas` WRITE;
/*!40000 ALTER TABLE `Medidas` DISABLE KEYS */;
INSERT INTO `Medidas` VALUES (1,12.5,32,160,81,90,20,'2025-05-06'),(2,25.6173,83,180,120,107,31,'2025-05-01'),(3,22.22,72,180,85,85,25,'2025-01-29'),(4,26.8274,85,178,110,90,34,'2025-03-12'),(5,22.4914,65,170,70,85,20,'2025-03-23'),(6,25.8546,81,177,96,92,30,'2025-03-23'),(18,24.2188,62,160,85,95,30,'2025-05-05'),(22,26.1962,83,178,69,69,27,'2025-05-08'),(23,26.8274,85,178,50,51,26,'2025-06-07'),(24,27.9155,76,165,82,86,37,'2025-06-13'),(25,23.4375,60,160,80,90,25,'2025-06-08'),(26,30.2469,98,180,119,117,37,'2025-06-13'),(27,30.2469,98,180,119,117,37,'2025-06-13'),(28,30.2469,98,180,119,117,37,'2025-06-13');
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
  `curcuma_gr` float DEFAULT NULL,
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
INSERT INTO `Pedido` VALUES ('002de412c34d0df25fe36a663507915a5734a3ea292fa5693cc5b0e5c0fbe74c','panchiloholly@gmail.com',2,1,2,1,'canjeado','2025-06-08 20:57:06',22,85.575),('0046bf00b1d561c76a39a8273e59cbdc13d85109f1c28452ca397015e0333be1','danamora700@gmail.com',2,1,1,NULL,'no_canjeado',NULL,28,5),('01e5b13cdaea791ff23d5be9664f1db91afc5a02cf60ff3da575a449f76bcfb0','mzl.salva@gmail.com',2,1,2,NULL,'no_canjeado',NULL,25,2),('021b79ab62b0e15239910010dfa37be36dfe1de36610a4721d5db347da9823ab','mzl.salva@gmail.com',1,1,1,1,'canjeado','2025-05-08 16:42:00',25,2),('03589863301e468860376dbd17d755f4661484249e2b350ac582d91e4552b3c0','dafely306@gmail.com',1,NULL,3,1,'canjeado','2025-05-19 02:08:06',12,NULL),('04a8e1a0fa8522db0d68c55f35828ec510ba79c6cd71a5892650810534a74131','mzl.salva@gmail.com',1,1,1,1,'canjeado','2024-06-23 07:25:28',25,2),('04c85d737eff107dee5787f4f61efbd746286f18a383c20472fbbf92c526235c','a21300624@ceti.mx',1,1,3,1,'canjeado','2025-06-13 09:16:50',14,34.23),('04e14f01b357c7c2b6ad2865fc398f2617ede658036b7dc69f2ff6941a7dd124','mzl.salva@gmail.com',1,1,1,1,'canjeado','2024-06-23 07:25:28',25,2),('050d472f16f555bcae09a54430fddeec49db25837b97e81bd7fa2853cca1de0d','dafely306@gmail.com',2,NULL,1,1,'canjeado','2024-06-23 07:25:28',13,NULL),('054d74c50511a787058380651a62d6bc4a509795ffab75d82ee82ae5d740ea0e',NULL,2,1,2,1,'canjeado','2025-05-20 08:47:40',23,2),('05a75ee9fcb61b149d8de8ec209db31e6daca86306505bc3f49f0b1d75bb800d','danamora700@gmail.com',2,1,3,NULL,'no_canjeado',NULL,31,85.575),('063a4ec7f6c506bcfb0409c3e38683937aa2334e9f9ba61b39ba4172667f9c7a','panchiloholly@gmail.com',2,1,3,NULL,'no_canjeado',NULL,22,2),('06ea50ccb4003726b70053fb4bad7c27b1f4a419ef1dbb2ac9fe05d1bb67bf1b','dafely306@gmail.com',2,1,1,1,'canjeado','2024-07-24 07:27:08',12,2),('086a4dfff6b1ae81b2c5035be02d7ba687fca6d6c4f7d1b24f3d2a129f7a1d80','danamora700@gmail.com',2,1,1,1,'canjeado','2024-07-24 07:27:08',28,5),('08dea686e97fc672f2822bd3842414f1328d888019fd80a28bb58ad60131f065','panchiloholly@gmail.com',1,1,2,NULL,'no_canjeado',NULL,22,2),('0a4e726ba49c89b907e7a26789aeb9bca3901677e29dcb51b9b2967947ff4c95','mzl.salva@gmail.com',1,1,2,1,'canjeado','2024-08-20 07:27:33',25,2),('0a73060f045dac88f79ef1c1f54887dd7e2d68ed5db47144cd1741cd2c94ecc3',NULL,2,NULL,2,1,'canjeado','2024-09-20 07:27:54',21,NULL),('0b5c1218de77e3c6889e45b9d96c3233891d1794365fa192a4a51aa51f7299df','a21300624@ceti.mx',1,NULL,1,1,'canjeado','2025-06-09 10:01:33',19,NULL),('0bce1738f044bad798aa47b19c5526aec5c7e9269e343a27f07cdbf78c577213','mzl.salva@gmail.com',1,NULL,2,1,'canjeado','2024-09-20 07:27:54',40,NULL),('0c755a9b3e31d9d7baa557569fa10b8b5e8c5e555f66f370b5bf4ef93274e9bb','mzl.salva@gmail.com',2,1,1,1,'canjeado','2024-10-20 07:28:31',22,2),('0dbedbba615898453b0c34a7d7d0891175360b66ba8088a4b9a23e0aca714b5f','mzl.salva@gmail.com',1,NULL,1,1,'canjeado','2024-11-20 07:29:07',25,NULL),('0e304c78cbc0f5f656c89637bfdc6365e84bbe2857d35f46ad03e56432b9d257','mzl.salva@gmail.com',2,NULL,1,1,'canjeado','2024-11-20 07:29:07',28,NULL),('10f8907982ac356d6e9667a150cdb9f61d90913b24c2a6b9ea7976ab4f6d300d','mzl.salva@gmail.com',2,1,2,1,'canjeado','2024-12-20 07:29:32',25,2),('11a6609bc18ff94d1891acbc50138b1c1e6a2936a28563ad85303f3625c7f01c','mzl.salva@gmail.com',2,NULL,3,1,'canjeado','2025-01-20 07:29:50',25,NULL),('11cee14e3327ccc051791716aeb4d7ac80eca5fbae3c06e82bca87c1c4e31205','mzl.salva@gmail.com',1,1,1,1,'canjeado','2025-02-20 07:30:03',25,2),('1366f30184e3b52829fa601c4a91919f1a79b9fd80027d81ce407426be73d58f','dafely306@gmail.com',2,1,1,1,'canjeado','2025-03-20 07:30:18',13,2),('14164d1983ce7a5df66b52ec8028f24eac61259576d0cd3f6e1281e63c709310','mzl.salva@gmail.com',1,1,2,1,'canjeado','2025-03-20 07:30:18',25,2),('14fe7bdf9ee888c69c2b0190517a35ed0134b94643562b4438b9994e27b68092','mzl.salva@gmail.com',1,1,1,1,'canjeado','2025-03-20 07:30:18',40,7),('1529920d250b854f3ccf8d6e7515339487c71ea7e89acf45fdc4cffc6c0047ec','dafely306@gmail.com',1,NULL,3,1,'canjeado','2025-03-20 07:30:18',12,NULL),('156385a68229bafa6269fed80ed2ce4a44881a93baff0c9bf0627760967b8321','a21300624@ceti.mx',1,NULL,1,1,'canjeado','2025-06-09 11:03:28',14,NULL),('1bbd3f15b14c1e0545d42c73e0e95076a2da12ec9feee012d944e37f4216aba2','dafely306@gmail.com',1,1,1,NULL,'no_canjeado',NULL,13,2),('1c7782a06323befe99775a940b172566e668b65e3eaf433f5f1cbcf65ef57d35','mzl.salva@gmail.com',1,NULL,2,NULL,'no_canjeado',NULL,25,NULL),('2258493d6f87452a622fb0fb2023e1923796aa0a1e502877e42357ec56b9a6fc','a21300624@ceti.mx',1,NULL,3,1,'canjeado','2025-06-13 15:52:56',28,NULL),('22bf7791333d56b5ea121c9d1b74314b58b5183acb1603133460c617c470fdd7','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('235fe4c6048d3cc164f432f8c16dd074f60422e607a15869a442db00d7b4dea8','a21300624@ceti.mx',2,1,3,1,'canjeado','2025-06-13 12:05:35',27,34.23),('23764e6a17f7498cfb3163c97794edc50bcd10cc3ce900a9e6b4036c464c99e8','panchiloholly@gmail.com',2,NULL,1,1,'canjeado','2025-06-08 21:02:21',22,NULL),('2433af9ae2c457d44a834a7aaf66a58624e1f9a6abbe33b14062496083c92505','dafely306@gmail.com',1,1,1,NULL,'no_canjeado',NULL,13,2),('250f482d60a7962e126b2658e66ed4ff9a5baf98653b8541e0f918d67b6020bd','a21300624@ceti.mx',1,1,1,1,'canjeado','2025-06-09 11:40:12',14,85.575),('273f299232888d9625938d2bf543fc7227a826f9d9eb392e34fb6f0df3f39e72','dafely306@gmail.com',2,NULL,3,1,'canjeado','2025-05-19 21:53:03',14,NULL),('2762e49f6928090055068934c5f06006fd209ad79ef3b8a396cc66973c22446a','dafely306@gmail.com',2,1,1,1,'canjeado','2025-05-19 02:10:28',13,2),('2764270ccceb5afdb02820cc8150bffd8506ed0c5be3d10f881745b9a18bdb5e','a21300624@ceti.mx',2,NULL,2,NULL,'no_canjeado',NULL,22,NULL),('28d4c3e757890fb88006d4b124722a46f3cd07083b9989a7eb1bb779a51b754c','danamora700@gmail.com',1,NULL,2,NULL,'no_canjeado',NULL,31,NULL),('2931d80d4f81b1970feed3301ac06146d7b8c4c0b49058aa8d396a32b6797c27','mzl.salva@gmail.com',2,NULL,1,NULL,'no_canjeado',NULL,28,NULL),('2c2a2296104f1ce350e107a52b9f21d38f4b284989b001b80e5a6d3a32814ae1','a21300624@ceti.mx',2,NULL,2,NULL,'no_canjeado',NULL,22,NULL),('328dc08b360e654beb610ba38dff67a66adcfc2046f1895bac9abcfd36806936','a21300624@ceti.mx',1,NULL,1,NULL,'no_canjeado',NULL,21,NULL),('338958692290ea0efebb3992edf30401c57ede7f666a3d1d894f2394e4f1b290','dafely306@gmail.com',2,1,2,NULL,'no_canjeado',NULL,12,2),('340f7ab92d67225f4af50fe1e3cdb894ea4e9c8d2f23a536b8d659868b1a5d0d','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('34c141ac73f23339b40ab5d80f39653b17115503c4316a7a9ede35235e3c72e4','a21300624@ceti.mx',1,1,2,1,'canjeado','2025-06-13 16:31:32',22,34.23),('35b2a5d048fb1a1a41d87b464d2fedcd43db784bd960abfb70d9a12f3f2d8a88','mzl.salva@gmail.com',1,NULL,2,NULL,'no_canjeado',NULL,40,NULL),('36208ad8fb6d8c026e25167566454938236eec1e9d0aa3b3b2a2f228fd6bde63','a21300624@ceti.mx',1,1,2,1,'canjeado','2025-06-13 13:47:15',20,34.23),('36a0233395fedd88bcbddcf2cdf81f1ebab4e092186f11e69721c19e30cf70fc','danamora700@gmail.com',1,1,1,NULL,'no_canjeado',NULL,28,5),('3712644aedcff77540d7a856514d9786121b0dffa4d0ce4bf9226d829f269b42','a21300624@ceti.mx',2,NULL,1,1,'canjeado','2025-06-09 10:33:05',17,NULL),('38693af2fd8fef6060b28a1b5324db713546b12e5ee68273935306844c17677d','mzl.salva@gmail.com',1,NULL,1,NULL,'no_canjeado',NULL,25,NULL),('387e57a8b3c58bdf4c5dcf51683a64988408284736ed31c4c1fab3b256897124','mzl.salva@gmail.com',1,1,1,1,'canjeado','2025-05-07 05:33:24',40,7),('389dd7eb8dee55b7046ea0d70490acbe5df63f7dedb70b48b598e10905e029b1','mzl.salva@gmail.com',2,NULL,1,1,'canjeado','2025-05-19 01:58:11',28,NULL),('394b89b169d453ae72d5b8c72d7fb50c0ad205a2bf311311aca11b622c3bdcbb','danamora700@gmail.com',1,1,1,NULL,'no_canjeado',NULL,28,5),('3a10234941b12a1322f3ee65c27ae053995a81aa02b85ddbdab1c9288e9b0c9d','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('3afb0c26bb89bf68ad98b8fc3462ed343a3a784bca01fbca0e7e48e2b5732f89','a21300624@ceti.mx',2,NULL,1,1,'canjeado','2025-06-09 09:43:16',19,NULL),('41e59b797fcce9469e711349c576061047c1aac40920528115b57be154a0124e','dafely306@gmail.com',1,1,2,NULL,'no_canjeado',NULL,13,2),('445307c84fe6c22f540d7e0755b90b55e0f45117ed019aa99c5a6cbd63bbf4af','a21300624@ceti.mx',1,1,3,1,'canjeado','2025-06-09 09:37:59',19,85.575),('462c654ca126d6fc294284bfc74dd13fc5747cc4b63f02655d067463b0164874','dafely306@gmail.com',2,1,3,NULL,'no_canjeado',NULL,13,2),('476e1a97d910694e02fff1f838e119f610e3bb7c2e61c7e586125461aea6067b','a21300624@ceti.mx',2,1,1,1,'canjeado','2025-06-13 15:04:00',29,34.23),('4821bc9b5f0d961447cc59537101e12474cba3499ff2e67b8c6cdbd767326af0','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('48f46bc0b4e4c74261cd1c4ecbe884932fa2c95143f44f57be34afe5d6cae1e0','a21300624@ceti.mx',2,NULL,2,1,'canjeado','2025-06-09 11:25:57',14,NULL),('4a17d603bd429a156d29867df91bfc4d740c59f8de9b6f3a6fd761a5ea52fd6c','mzl.salva@gmail.com',2,NULL,1,NULL,'no_canjeado',NULL,28,NULL),('4a26888cde353b4a4a7cc53778e9e4d0b63b33409f45bfa24473ebcb76f4bac7','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('4a7f9292ae26c87c8849a7bd133dfb00332b2659df67f730ba245052c337f29f','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('4fd681c40850194294eaf2118a2b2ac9cdb8c8128b5f29b80e3455def8f50963','panchiloholly@gmail.com',1,1,2,1,'canjeado','2025-05-20 00:07:43',20,2),('503611e42b2115c327535b614b4bb699168e09087e9d210ca1c21adfb7fe22b0','a21300624@ceti.mx',1,1,3,NULL,'no_canjeado',NULL,14,34.23),('5186a644e552c7853072ca8ff6b9099d1cd5e0ec06db22cb81f25342b2b1b9ab','mzl.salva@gmail.com',1,1,2,NULL,'no_canjeado',NULL,25,2),('5223f66b5b20f081ef0b84798d4a26d821529016618012d3bc960bdff627d6f7','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('52f200db878be1c3bad8955aa4fe210c3d32f0f655f472f2ed113b86d9b5c067','mzl.salva@gmail.com',2,1,2,NULL,'no_canjeado',NULL,25,2),('52ff536d5eaeee93baf66d6832ff676abc70267edc84aa3277f9723593372d5e','panchiloholly@gmail.com',2,1,3,NULL,'no_canjeado',NULL,20,2),('5326aaeda3bc450718c9fc5759fa8e1cda36bf543faebcb24ce67787524a7826','dafely306@gmail.com',2,1,2,1,'canjeado','2025-05-19 02:20:45',13,2),('5407c5ac35f930512279a2cc71a23a0df673abd5e47ca37cb7ce3c99f2e8224f','panchiloholly@gmail.com',2,1,3,1,'canjeado','2025-05-27 05:47:37',22,2),('558aa7d1b35289d665875efd6e80e12758a0791cc9b73ff9a04788d038aeaf3b','mzl.salva@gmail.com',2,1,2,NULL,'no_canjeado',NULL,40,7),('58103e2df61bfeb5fda9cb1fed0a889834a969874652cc6ad7b15bef44b2819d','mzl.salva@gmail.com',2,NULL,1,1,'canjeado','2025-05-19 01:54:27',28,NULL),('5a186cefb76dd3d9698a92fdbba5cab00ce0f585c2fa259d43cc6337792d7a98','mzl.salva@gmail.com',2,1,1,NULL,'no_canjeado',NULL,28,2),('5a36fbb8767983b395ec72955a80d4c3c79bd22a7dda84c7b71db1326d9c94b0','mzl.salva@gmail.com',1,NULL,1,1,'canjeado','2025-05-07 05:33:24',25,NULL),('600c58812ee5824a074dc967e4c9f3daf7fae54897491c43387e9c001f36869d','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('629a0c5f2a61d892d8d0873ccf977d190c4d4d315d7a4af5eb66b14af27dea12','danamora700@gmail.com',1,1,3,NULL,'no_canjeado',NULL,28,5),('63a0608fba99c840bf688d860406811ea71f1dbf63a20a6a65ebd07a72cb79ed','mzl.salva@gmail.com',1,1,2,NULL,'no_canjeado',NULL,25,2),('64963141a102782eb56df85f04921144944b7286129eab64c6252bd45c64a272','mzl.salva@gmail.com',2,NULL,1,NULL,'no_canjeado',NULL,28,NULL),('668030378a93717829d8065397bec853c180040e76475b2b8bdc20110518de23','dafely306@gmail.com',1,1,2,NULL,'no_canjeado',NULL,13,2),('69251b5f764fa60b6a796ec5072cd2ef51d4e5fa3e25c3ab43e01913d1f8fe4d','mzl.salva@gmail.com',2,NULL,1,1,'canjeado','2025-05-19 01:44:02',28,NULL),('69ed173d0686aa770e84134f6cb42525f7a9e0e9ca513ab2769ed173d0686aa7','mzl.salva@gmail.com',1,1,2,1,'canjeado','2025-05-11 21:09:58',28,2),('6a1fdb990403fcdecab95f65d3fe293184dce1572694fdc0365d1a5e1e1b47e6','dafely306@gmail.com',2,NULL,1,1,'canjeado','2025-05-19 02:16:53',13,NULL),('6aa34f95bfa9b4493fd9e6f3a8668d0a0e2a3bb9bc9e4a481ed2b6cd801c5123','panchiloholly@gmail.com',2,1,2,NULL,'no_canjeado',NULL,22,2),('6c16ab922b24fc3ec3c92120a9c732249b6340696d4387c9dda3ae0cfd75467e','a21300624@ceti.mx',1,NULL,2,1,'canjeado','2025-06-13 12:41:41',27,NULL),('70136b14408d4ef1fc81f06c023e3f6ed56356891efacd570abc8682198f1ed3','dafely306@gmail.com',2,1,2,NULL,'no_canjeado',NULL,13,2),('72312b4d0b8471cfe32087987ea9c36a794c57e073f8de28dd658031be4d7b3c','dafely306@gmail.com',1,NULL,3,1,'canjeado','2025-05-19 02:24:37',13,NULL),('7343f5ebf20809fd2773e32552a04f922b3457c9dbb39e0f2c5e5867d09e0e6d',NULL,1,1,3,NULL,'no_canjeado',NULL,21,2),('74b71bfd3e34e87f85afd3a3398f52fba8cd5d4c517a3384b3e69f208926c87d','mzl.salva@gmail.com',1,1,2,1,'canjeado','2025-05-16 22:13:48',25,2),('78f2110345ce0da0d18483ed38a5e651001decebc85d26e918838348c595c402','mzl.salva@gmail.com',1,1,1,1,'canjeado','2025-04-07 05:33:24',40,7),('7cb0e72324b99c3e9852069f77f7b8b882b018e2b226683cfb86a293315b114a','panchiloholly@gmail.com',2,1,2,NULL,'no_canjeado',NULL,20,2),('7fa370cfff84d176136a707a3158731703fcea1ddb0abe8c8b64aa6af204eedd','dafely306@gmail.com',2,1,1,1,'canjeado','2025-05-19 02:33:42',13,2),('80be4460dedd02530a06c9c1ac0cad985c82e5418eeea9ac3fb0594ee092e513','a21300624@ceti.mx',2,1,1,1,'canjeado','2025-06-13 15:21:51',29,34.23),('818fb8ac7439bbe71c89c9c89b0116e13dda38530735c2d504f919e05acd3bb2',NULL,2,1,2,NULL,'no_canjeado',NULL,24,2),('81e794dc8eb45e400c13a9f64a72059cd9f5a3f68e7d053fc4bf2f62bf1fb8be','a21300624@ceti.mx',2,1,1,NULL,'no_canjeado',NULL,20,34.23),('82305c8259ede8958da09c0fa8c354486c3532d4f21bc7f7ec601cfd024a5c9e','dafely306@gmail.com',1,1,1,NULL,'no_canjeado',NULL,13,2),('82cfd3c291004c5c9b53788252b27d0cedc1ac2061e4fa34132e5de4447d4741','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('83a718568404004669452e531459ff3369476e957999b070d321f966ae4688ed','a21300624@ceti.mx',1,1,2,NULL,'no_canjeado',NULL,30,85.575),('83d5c69b7f5f9e74372923a0ddb92632778be83d1b2ab14ad685e1c4c15a82a2','a21300624@ceti.mx',2,NULL,1,NULL,'no_canjeado',NULL,14,NULL),('83fde1500bb6fc526761eba37ceace1a810610e509669c90a825498cbea6c1a7','a21300624@ceti.mx',2,NULL,1,NULL,'no_canjeado',NULL,19,NULL),('84e8049a1487657f78f0787917f27df805c70fa8e847586063d6bff89e723772','panchiloholly@gmail.com',1,NULL,1,NULL,'no_canjeado',NULL,20,NULL),('8564e5a6b4c7f01273de2d696a05e52def81de8132d4999c55d2929168226db1','panchiloholly@gmail.com',2,1,2,NULL,'no_canjeado',NULL,20,2),('8cc533da27d111c283181e0a380ee20303b6b2943699ab679ed0a61e3f29aeb6','mzl.salva@gmail.com',2,1,1,NULL,'no_canjeado',NULL,25,2),('8e1fc64d49e12bad394da2e8be461ab77afdd084f40406994d6f25f590ebf63e','a21300624@ceti.mx',2,1,1,1,'canjeado','2025-06-13 14:58:44',29,34.23),('8ea1af38b422d483fe47c756c0cdfd0c781ae7b52aed234a9a73d79b11a327fc','mzl.salva@gmail.com',2,1,2,NULL,'no_canjeado',NULL,25,2),('92e030dd5097c0c0c22d626d9456c1c37318d476766445dfaca323df2d168fd9','a21300624@ceti.mx',1,NULL,1,1,'canjeado','2025-06-09 13:07:33',14,NULL),('96c6efb2a602814506e28bd018522076c6f5b15edcaaf27d6b5cc809550d9b44','mzl.salva@gmail.com',2,1,2,NULL,'no_canjeado',NULL,25,2),('970bc33b4d63e31b3703ac799457f500b89ebd0414d92f404b5601e9c9db5e22','dafely306@gmail.com',1,NULL,3,NULL,'no_canjeado',NULL,12,NULL),('975cf948441ad9586778bcd0995aba73074fa24c743125bf2f9dbd0a360c2563','dafely306@gmail.com',2,1,3,1,'canjeado','2025-05-19 02:11:54',12,2),('97e27ad9e1dbc739a487046c31999fd7378cca5f59ef6619b7c424432824c719','panchiloholly@gmail.com',1,1,3,NULL,'no_canjeado',NULL,22,2),('9827df5e456ab37c2524c8340e6bc6e2dd3f0cf14a9af8082a1707ec8599bf37','panchiloholly@gmail.com',2,1,2,NULL,'no_canjeado',NULL,22,2),('98aab15e79ca2923a7df12b7bad190215b9c39a9134113b6e6b29170be8fe14c','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('9a6b3c06e968e5667f689f8900dd1f2e0264253bc39e1ce75dcc3e96c9fb384f','dafely306@gmail.com',1,NULL,3,NULL,'no_canjeado',NULL,12,NULL),('9c0c29cac8b0806204256c2bcfc393f04e6ea7451a6b1d3dac0519acc228c2ef','mzl.salva@gmail.com',2,1,3,1,'canjeado','2025-04-07 05:33:24',40,7),('9cca8a4d7909b6a571fa421448c38d4448b49daa7c0a2bfe226da30f13ebd43f','mzl.salva@gmail.com',2,NULL,2,NULL,'no_canjeado',NULL,25,NULL),('9dc91f9b1b8d934ee7870dc37463a3b50bf938b8255a8dbfe5d9bc6c4cdd6132','panchiloholly@gmail.com',2,1,2,NULL,'no_canjeado',NULL,22,2),('a1e1d02bde490103789766ca3a45b7af09d42cd7364a87cd9991ebf822cb4837','panchiloholly@gmail.com',1,1,2,NULL,'no_canjeado',NULL,20,2),('a1ffac07095bdb0fb2d7eb81787295b68469845c38ca99a744d8e1b1f9d3db6a','danamora700@gmail.com',1,1,1,NULL,'no_canjeado',NULL,28,5),('a28db83d21b3a329274d2721c0d1d9542c3f4584b2acc9754e645310bb58a3bf','mzl.salva@gmail.com',1,NULL,1,NULL,'no_canjeado',NULL,25,NULL),('a28eddc9cd9fa8c3dc050d138ad6bdece07fe8f972cda2bcd5bd403b66da87f9','dafely306@gmail.com',2,NULL,1,NULL,'no_canjeado',NULL,13,NULL),('a41f825202722e0bf4da5c546eb9423865355c7a9d2505e4fc4fd41f522fe2f2','dafely306@gmail.com',2,NULL,1,NULL,'no_canjeado',NULL,12,NULL),('a6ca1efea7bcc08ac806d8cf9b11f993a68390dafa1a7f546768f62bd109da38','a21300624@ceti.mx',2,NULL,1,1,'canjeado','2025-06-13 14:16:31',34,NULL),('a83774c08c5bc4d9f4b2969ce3e354934fb5e743f9bbe1dcae0453753f077f44','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('ac97bda8f80ee7edfb423d91189da4ff8ca3ab2e3276c4a6d419515faf9ce4ef','a21300624@ceti.mx',2,NULL,1,1,'canjeado','2025-06-09 10:45:07',14,NULL),('ae82ae0013d6dcb2d4a376f6cc1a7e082eafefa59ab47e8662b48ea19be0c7bb','danamora700@gmail.com',1,1,1,NULL,'no_canjeado',NULL,28,5),('afcbf616751388c608fdc0380e07527007f19338823f88a326d3b9a058f91673','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,40,7),('afe9cddc631fe64d770ed5e4662ebd801ee368041d4bc2d13facd6ccf267b261','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,40,7),('b10a2a84a43c4fdd56582aa2c20cedc2d5b56f30fbf7cb0de7c22a518ea29347','mzl.salva@gmail.com',2,1,1,NULL,'no_canjeado',NULL,25,2),('b14d33f7bab51488d33842c5ba1c63c3b22690c46fe9734a135e3c678ff17a03','mzl.salva@gmail.com',2,1,1,NULL,'no_canjeado',NULL,25,2),('b2836196882dfff33ecbfaf4fe3fa54df37e2d4f4119efe99ed4c12677bd3705','mzl.salva@gmail.com',2,NULL,1,NULL,'no_canjeado',NULL,28,NULL),('b2a78bbbeef775d0bd56703f9a793d59262d4e15139f8c7bae8f172fbe9cb66f','dafely306@gmail.com',1,NULL,2,NULL,'no_canjeado',NULL,13,NULL),('b3f79fc614883696447ddc57a8b9a78df7040ea4ef19264dfa3274a6bead6891','a21300624@ceti.mx',1,1,3,1,'canjeado','2025-06-13 09:23:53',14,34.23),('b68d71d32d317a6c6bad2181dec87abd383245ce37f8f84d242ae8ff361fb86f','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('b747bedc90da69afb2e3eaab38dcb30c977448b799310ddf1536a7eb32406617','mzl.salva@gmail.com',1,1,2,NULL,'no_canjeado',NULL,25,2),('bcb93f790639e6a40802438a3933fb0c5297cbdaaa4be87a17ffed18f3b20bdd','mzl.salva@gmail.com',1,NULL,3,NULL,'no_canjeado',NULL,40,NULL),('bed67a44031b662d51ff83a9722c23f679ebe7f0b2586b5f114b754760f6e527','dafely306@gmail.com',1,NULL,2,NULL,'no_canjeado',NULL,13,NULL),('c0234809ee5c86cb233ce959e4d3aae2aea1e447b7444566d2be9b5173a9461d','mzl.salva@gmail.com',2,1,2,NULL,'no_canjeado',NULL,25,2),('c04ac63cf3ed3450e7c104b71b320b4fa7b1611c8e53e0b348da0a9bbbc2fca7','a21300624@ceti.mx',1,NULL,1,1,'canjeado','2025-06-09 12:00:31',14,NULL),('c0925ad466724c03370c7a0c0c65d13b02544014cc40fd36b36e7037820ddd38','a21300624@ceti.mx',1,1,2,1,'canjeado','2025-06-09 12:29:02',14,85.575),('c281b648313602af1aa3210792d4f4b79a258edfebbe5070af486268bac20291','dafely306@gmail.com',1,NULL,2,NULL,'no_canjeado',NULL,13,NULL),('c4cee8ec8b338dbaff0b3aec4d6dd5debeaf2162e1ddac438b3e02e43d339093','a21300624@ceti.mx',2,1,2,NULL,'no_canjeado',NULL,29,34.23),('c4efc0ec1ab9c6734cb3eb62cea50004dc488a09c08ad330c90361fc6409aa9d','dafely306@gmail.com',2,1,2,NULL,'no_canjeado',NULL,13,2),('c80f41224e136fe0bc0dd7785b0e60bbc08d5e2306772bb6be460b3e9d553097','danamora700@gmail.com',1,1,3,NULL,'no_canjeado',NULL,28,5),('c910a58334c3b775a02fdd248d01b866e804a3d2152a4332b131a8f787392872','dafely306@gmail.com',1,1,2,1,'canjeado','2025-05-19 02:30:09',13,2),('cb5bc1a3fc01aab67eb64b3be978acb1a755ba309abe4a3e59d71e1138ca0007','dafely306@gmail.com',1,1,1,NULL,'no_canjeado',NULL,12,2),('cce74d4e72e2e3a5ee812a04417b52c67b2d9ec51721853657854f1fa75a726f','mzl.salva@gmail.com',2,NULL,1,1,'canjeado','2025-05-19 01:50:21',28,NULL),('cdf9ccb9c68137b575e6e0d60e23fd23b1d946b659b9220200f87f2674b5e4db','dafely306@gmail.com',1,NULL,3,NULL,'no_canjeado',NULL,12,NULL),('d4006cb37bed2bb998fdc6180fe0fc4045ebc9eb9834015e2ff06c250198ed8d','dafely306@gmail.com',1,NULL,3,NULL,'no_canjeado',NULL,12,NULL),('d4313e6b6f00eb1dc2f3f0490502a30da9f0bd1f4112b842d8fc89be9e0b8264','a21300624@ceti.mx',1,1,3,1,'canjeado','2025-06-13 10:29:19',14,34.23),('d4b983e3efe84e08319e3b7415911ce21a8207f1c4cdfcdc9b532143b516a99a','panchiloholly@gmail.com',2,NULL,2,NULL,'no_canjeado',NULL,20,NULL),('d4fb9bcb9f3218f0d02eacf6daaabd090e0ab13c1e7a85b026c0443e8d206749','mzl.salva@gmail.com',2,NULL,1,NULL,'no_canjeado',NULL,28,NULL),('d5fd1c69e3042a7413d31e166e9d1cdab08c5d66c7b9eaeb445eaf80b71ce49b','mzl.salva@gmail.com',1,1,2,1,'canjeado','2025-04-07 05:33:24',40,7),('d720940e1b7d52e5c674e13b73367befb535cab172fa562a6c8e3a272785f4ac','mzl.salva@gmail.com',2,1,1,NULL,'no_canjeado',NULL,25,2),('d814b81b2023d93fef8c9541988785559547bf5c924e0a7f65c4a5b7e64f7316','dafely306@gmail.com',2,NULL,3,NULL,'no_canjeado',NULL,13,NULL),('d885b329be2f7b7475c5c9612133d2b7d6e38609bd5b2c970c70ffba99337a07','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('da9cb915498bf960177ae2876e5adf89a38ff6d6f4af4f3b4c1ccfef23f67286','danamora700@gmail.com',2,NULL,1,1,'canjeado','2025-05-20 08:30:38',28,NULL),('dbef681e3f15ea3b90319dd94d313df8f4c416ba56a0179a7b57f755a73721b2','a21300624@ceti.mx',1,NULL,2,NULL,'no_canjeado',NULL,29,NULL),('dd0bbb5c0fe48716429e0798b78bf09e471275ba5283a850671541e15be5621e','a21300624@ceti.mx',2,NULL,2,NULL,'no_canjeado',NULL,29,NULL),('de19047c46eb362ca081465af48692b145446248474e06dc1d5b7e1b1d011604','a21300624@ceti.mx',1,1,1,1,'canjeado','2025-06-13 15:59:38',28,34.23),('DONT_REDEEM_ME_b356536bef06acd15f525a7f5a9a4ef3f46b04e8b9f04c9e7','mzl.salva@gmail.com',2,NULL,1,NULL,'no_canjeado',NULL,28,NULL),('e13bda611c9e7f365e60b551b1069efbc9ab61bda23b63c1853538b6d9d9bd0c','panchiloholly@gmail.com',1,NULL,3,NULL,'no_canjeado',NULL,22,NULL),('e1fc86eb9fca2ff2b5da6299fc88f484e2785cae7cfabcf73e58738d3b52ddf7','danamora700@gmail.com',1,1,1,1,'canjeado','2025-05-04 19:29:37',40,7),('e2e03501b6328ae28c558438e5ca2f03f64c52ee7cf03212e1bd873b8890d425','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('e51810c0fd038f3a0e63099feb520bc20bcd7e8e4937ff23e5ee25973716fe03','a21300624@ceti.mx',2,1,2,1,'canjeado','2025-06-13 16:18:26',26,34.23),('e538efad5ba178aa913c56b82245a83cfbee2ce1016024ba7d3a759260deb73e','danamora700@gmail.com',1,1,2,1,'canjeado','2025-05-05 19:28:58',40,7),('e57cd30a9878ed97d59a15f30882f71567cad5a5d006898a07b6666ed8f72c25','a21300624@ceti.mx',1,NULL,1,1,'canjeado','2025-06-09 13:00:14',14,NULL),('e69dbaa7ada43bbd18c01c5b4f4d4d8fc17a8e4eac4501c2bf5cc2aea0ffa9b2','dafely306@gmail.com',1,NULL,3,NULL,'no_canjeado',NULL,12,NULL),('e6e06b23c3b1e0662da6f7ca9d50bb58b25e59620a4475502c7426ee77d7c19c','mzl.salva@gmail.com',1,NULL,2,NULL,'no_canjeado',NULL,25,NULL),('e70b8df5fc57d0fb71702508b1a4e8a3b9029e80d5648e53a9faa4f4c115ff1c','a21300624@ceti.mx',1,NULL,2,1,'canjeado','2025-06-13 13:15:35',27,NULL),('e96c2eb7b955c6e24f47770625853f3020ea35d847ed40464c71681c6c772cdf','danamora700@gmail.com',2,1,1,1,'canjeado','2025-05-07 19:28:07',28,5),('ea17388118aa4bcce782d6bce6624cc2e21ee71ea081e0f47cc98dc07e5d9be0',NULL,2,1,2,NULL,'no_canjeado',NULL,24,2),('ea912abd1db798c47ed2cf111442e2ed5a3247c417da02a8965c698ecc20000b','dafely306@gmail.com',2,1,2,NULL,'no_canjeado',NULL,13,2),('ec1b71b8dde44baff39b06478acb945c0de1a911699a3603062bd5083a3565f5','mazl0nf3k@gmail.com',2,1,2,NULL,'no_canjeado',NULL,19,2),('ecf24a43952e1e584f9a223e727b2c11ad11021247446e512fe6b6772f0b3637','mazl0nf3k@gmail.com',1,1,1,NULL,'no_canjeado',NULL,19,2),('ed22db2458f13e60d949f2068272a6cb811eb5bf3d4ce27e909bfca8db1a53f5','panchiloholly@gmail.com',1,1,1,NULL,'no_canjeado',NULL,20,2),('edf45706ca1b4e0e51f903f7df57368cd04e51a0569c3d6be386200e5847a7e0','dafely306@gmail.com',1,NULL,2,NULL,'no_canjeado',NULL,40,NULL),('ee2bf9ae81e68bb48305dbff7c12fda190b87faca213082def4cdb1e7da8c67a','mzl.salva@gmail.com',1,1,1,1,'canjeado','2025-05-07 06:22:18',25,2),('ef656afa907e4cd594098d5785b25c4e9a0039a6330e3ad2a76b3a6dc988637b','a21300624@ceti.mx',1,1,2,1,'canjeado','2025-06-13 11:21:13',14,34.23),('f104bebbc01b2609edf9130c249f74364e07564cd2a44dd2ee7e472a7722126c','dafely306@gmail.com',1,NULL,3,NULL,'no_canjeado',NULL,12,NULL),('f19c5ab6d5070f67fb6034b45667ecb3e8fba944c34641c9912e49a1ceeb2acc','danamora700@gmail.com',1,1,1,NULL,'no_canjeado',NULL,28,5),('f1cc21b6484f6f4d3bd6449ec5d0ddf6e254b8bbf702e2dbf71745401872e2a3','mzl.salva@gmail.com',2,1,2,NULL,'no_canjeado',NULL,25,2),('f1ea253faac333a8f8d086876fa0987bf7b5148d024e3348f2536f8ed3314541','dafely306@gmail.com',1,1,3,NULL,'no_canjeado',NULL,12,2),('f1ee94f9b51c2a6466e1e7c4c740f61cb4d3358355e7e1e9e3befd4a57fbb595','dafely306@gmail.com',2,1,2,NULL,'no_canjeado',NULL,13,2),('f36580290b1afa86275992eba2b032ce86e3cfe5e6e3f14fd540a6efe3bed258','dafely306@gmail.com',2,1,3,NULL,'no_canjeado',NULL,14,2),('f396ab781ff43641701a95082d3a2361e643810c2d572b5464d414a9cbc5bd0e','dafely306@gmail.com',2,1,1,NULL,'no_canjeado',NULL,13,2),('f5879fa215bb12f31bb08ecd01e7b7085b3adc4bd72591026f4c8aca87ac6ea1','panchiloholly@gmail.com',2,1,2,1,'canjeado','2025-05-27 06:00:26',22,0.5),('f6e705ce12bb6488bddabc6d93f25610db7a4a99f85aa4b4370670136177029e','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('f7536056005c2c0d14d3bbc0c11cf33d39a0618aed89d54176fced591ea6da2d','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('f830bfe505ea3212afa1db9261e8be7f309e2036dff794d6667a3c536a09c799','danamora700@gmail.com',2,NULL,3,NULL,'no_canjeado',NULL,31,NULL),('f92b0a3565d4a6b9925d28cd489c64ec72ad137376b00adbc9246b772c70ff32','mzl.salva@gmail.com',1,1,1,NULL,'no_canjeado',NULL,25,2),('fa61655e7f090baebd662dae70d4cc8679c07764c64f178c5a5e06000278909d','mzl.salva@gmail.com',1,1,2,NULL,'no_canjeado',NULL,25,2),('fb2053ed5695b5c0696b3aab80b3a0e322fec3736ab29e63d541dc0ae598db5d','mzl.salva@gmail.com',2,1,1,NULL,'no_canjeado',NULL,25,2),('fccbf15ec8cfd3e95172bf3f07b127da6d45f341561a1e9c8df5cf345d6594b1','dafely306@gmail.com',2,NULL,1,NULL,'no_canjeado',NULL,13,NULL),('fcdd205ba7bf3a434c91b20885d7bfa1f4ae428e2e0fe5b293d8fc1f4f355f02','dafely306@gmail.com',1,1,1,NULL,'no_canjeado',NULL,40,7),('fd4954b5b52aeeaca9642b49ee1ba6f091c69e3ee96332df6611a851c6610444','panchiloholly@gmail.com',2,NULL,2,NULL,'no_canjeado',NULL,20,NULL),('HUMEDAD_ALTA_acd8183936f846dec0556fe6e830b6236e01a2760b6915dce4f','a21300624@ceti.mx',2,NULL,2,NULL,'no_canjeado',NULL,19,NULL),('NO_INGREDIENTES_faaba12fea6cd9de54d3a7112b830d05572816c7a5db4fef','a21300624@ceti.mx',1,1,3,NULL,'no_canjeado',NULL,19,85.575);
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
INSERT INTO `Proteina` VALUES (1,1,'Vegetal','Falcon Protein','Falcon Protein es una proteína 100% vegetal con cadena de aminoácidos completa gracias a su sinergia de 7 fuentes de proteína. Además, contiene una mezcla de enzimas y probióticos.\n\nCada porción de 30 g aporta hasta 24 g de proteína vegetal, es libre de azúcares, gluten, soya y posee certificados USDA Organic y Kosher.\n\nFalcon Protein está diseñada para apoyar tu ingesta de nutrientes diarios y está disponible en sabores orgánicos de chocolate, vainilla, chai, natural y fresa.\n\nEste producto no está destinado a diagnosticar, tratar, curar o prevenir ninguna enfermedad. Consulta a tu médico o nutricionista para asesoría personalizada.\nCanela orgánica\nSal rosa del himalaya',1.1111,'2025-01-25',70),(2,4,'Animal','Pure And Natural','Proteína 100% Natural, 100% Pura.  \n\nProteina 0 Azúcar, 0 Grasa, 0 Carbs, Gluten Free, Chemical Free, Gums Free, 0 Flavor, 0 Maltodextrin.\n\nAminoácidos por porción:\n\nAcido aspártico 3.0g \nAlanina 1.4g\nArginina 0.6g\nCisteina 0.7g',1.1111,'2025-01-28',70);
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
INSERT INTO `Saborizante` VALUES (1,2,1,1,100,'2025-01-25',3),(2,2,2,1,50,'2025-01-31',10),(3,2,3,1,20,'2025-01-31',3);
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
INSERT INTO `Tecnico` VALUES ('chavatech',2,'Salvador','Arana','$2a$12$3haqXb1xQjb0N3vd3kZ86eCDHiaMINZY2pQbDYMcm8.VDeJmqIzPy','mazl0nf3k@gmail.com'),('dafnetech',1,'Dafne ','Vazquez','$2a$12$XWjkQBz1kSVEWPGexx1HXOwUd762eRY2uvNY5/4CpbJFxPcm6/l/G','dafely306@gmail.com'),('danatech',1,'Dana Sofia','Mora Villalobos','$2a$12$NZw0ngjVA/BRGhsr2c9fwuoy7gefdt98zLH/XHjqHZfv98mTZAZBe','danamora700@gmail.com');
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tipo_Alergeno`
--

LOCK TABLES `Tipo_Alergeno` WRITE;
/*!40000 ALTER TABLE `Tipo_Alergeno` DISABLE KEYS */;
INSERT INTO `Tipo_Alergeno` VALUES (1,'Productos Lácteos'),(2,'Chicharo'),(3,'Arandano'),(4,'Quinoa'),(5,'Amaranto');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tipo_Fallo`
--

LOCK TABLES `Tipo_Fallo` WRITE;
/*!40000 ALTER TABLE `Tipo_Fallo` DISABLE KEYS */;
INSERT INTO `Tipo_Fallo` VALUES (1,'Otro','Especificalo'),(2,'Fallo de conexion','No se conecta a la base de datos'),(3,'Fallo de la tablet','La tablet falla'),(4,'Fallo de la maquina','La maquina no dispensa el pedido');
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
INSERT INTO `Tipo_Saborizante` VALUES (1,'Artificial');
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
  `stripe_customer_id` varchar(64) DEFAULT NULL,
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
INSERT INTO `Usuario` VALUES ('a21300624@ceti.mx',24,25,'$2b$12$Yj/VoVWI2xvWyAJGlvUuzO1d5DqKoDEdbKoKaOafp0CF5/uXqHIee','Femenino','2025-06-08','BoostUp','BoostUp','Pruebas',19,'2006-06-03','cus_SSr76yVg1B1kTE'),('dafely306@gmail.com',1,1,'$2b$12$7IWDoXF/Ao2phpE4LIEGg.Kld1pj1ndhiLuXIF2mun3d.z/3V4uz2','Femenino','2025-03-09','Daf','Dafne','Vazquez ',18,'2006-06-03','cus_SHYMtRNNcaFhkD'),('danamora700@gmail.com',3,3,'$2b$12$PHMTdb7hZcWNKCs002nfr.dFrVUUAn852QnrIffatQKtmNN8R8t5C','Femenino','2025-01-29','Dana','Dana Sofia','Mora Villalobos',18,'2006-06-10','cus_SI0sIRkSfrVIWh'),('emmanuel369@gmail.com',6,6,'$2a$12$Fsxq1YSfyZaUoBREZaaMjOvpKoKnnQkiHjmEFF0BPLSstOqQDURIK','Masculino','2025-03-23','Emmonuel','Emmanuel','Cruz',19,'2006-03-06',NULL),('mazl0nf3k@gmail.com',22,23,'$2b$12$zPSPppGWmYr3Gt7c/Rhpb.Ab3plxBiAjmQf6xvGIonrtMmMJvXx1y','Masculino','2025-05-08','Stroip','Salvador','Arana',22,'2002-09-18','cus_SH38aQjxu6oZed'),('mzl.salva@gmail.com',2,2,'$2b$12$P7AFj/SYkns9HaYv5ypiT.liLg7s9rIF.1xmiiGXmQGq9Y1JcrPXC','Masculino','2025-01-29','Zynths','Salvador','Arana',22,'2002-09-18','cus_SGsWopK5GiVHZx'),('panchiloholly@gmail.com',18,19,'$2b$12$1qr8BAhJH2a6GyITGKCgLeUuoIZJZkB/EBlANybsmHvyDeUxBfi6m','Femenino','2025-05-05','Nanely','Dafne Elizabeth ','Vazquez Ortega ',18,'2006-06-03','cus_SKhUW99sjEIQcA'),('prueba@gmail.com',26,27,'$2b$12$LC/gCCqsm297DPrhlrbVeuW2n/3wNQ73N3Q90iYzBI3Yu7HlEHW.S','Masculino','2025-06-13','JuanPa','Juan Pablo','Guzman',56,'1969-03-15','cus_SUb5tcxSwrE0S2'),('twinsdafxitla@gmail.com',5,5,'$2a$12$Cg4/Kaine4H1hgwebhgW.eEWCqPt8N44JvZxscYoREL/4dwzdDONW','Femenino','2025-03-23','Xitla','Xitlalli','Cruz',18,'2006-06-03',NULL),('user@example.com',23,24,'$2b$12$i4z9ITKp.rjD00ZmlhtbV.bEi39indMUJu9r20D9aGclLHvInaIYu','Masculino','2025-06-07','string','string','string',0,'2025-06-08','cus_SSUNxwJ05DEP5J');
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

-- Dump completed on 2025-06-25  0:41:58
