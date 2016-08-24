-- MySQL dump 10.11
--
-- Host: localhost    Database: pager
-- ------------------------------------------------------
-- Server version	5.0.95

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `clients`
--

DROP TABLE IF EXISTS `clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clients` (
  `client_id` bigint(255) NOT NULL auto_increment,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `application_key` varchar(255) NOT NULL,
  PRIMARY KEY  (`client_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clients`
--

LOCK TABLES `clients` WRITE;
/*!40000 ALTER TABLE `clients` DISABLE KEYS */;
INSERT INTO `clients` VALUES (1,'alexandrubagu','117950','alexandrubagu_application_key');
/*!40000 ALTER TABLE `clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `devices` (
  `device_id` bigint(255) NOT NULL auto_increment,
  `client_id` bigint(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `platform` varchar(15) NOT NULL,
  PRIMARY KEY  (`device_id`),
  UNIQUE KEY `token` (`token`),
  KEY `client_id` (`client_id`),
  CONSTRAINT `devices_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`client_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devices`
--

LOCK TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
INSERT INTO `devices` VALUES (1,1,'APA91bH6qqUi02q2ymUY4tHE6FB4I4rbnYARST_8zRle3eZxCueITfn41O9GrtjUwigRPcVeyk4qmv_Y2pUsWJb_QUjoHYwt7tNkO2d7R5u_54iXQCBr-MY4zGQKAJagLA4ocILjrtIFLP4By6QSAzrV1d9HEZCZTQ','android'),(3,1,'test','windows'),(6,1,'47400b65b4bf7a522d3a8d970d610f18cc9c62a8ff7cefbf869bfc938845c6db','iphone'),(7,1,'d19dc5a7479f6c5ee609ab16073efbd4598c0c366097220e0e4abb9f117d6693','iphone'),(8,1,'7cd4af817871811c0e8551f7d0ef2293f221cf45a58573a35cfece99144c60b4','iphone'),(9,1,'a2a1a6420a57d704f259510a929b8539bbd8a471d8f74d97f86fc4c323eca790','iphone'),(10,1,'707065305349f2d43ee883fb0ff678866473a7cb89a97723c3af388a9bdc96a7','iphone');
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_lists`
--

DROP TABLE IF EXISTS `email_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_lists` (
  `email_list_id` bigint(255) NOT NULL auto_increment,
  `client_id` bigint(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `host` varchar(255) NOT NULL,
  `port` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `use_ssl` tinyint(1) default '0',
  PRIMARY KEY  (`email_list_id`),
  KEY `client_id` (`client_id`),
  CONSTRAINT `email_lists_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`client_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_lists`
--

LOCK TABLES `email_lists` WRITE;
/*!40000 ALTER TABLE `email_lists` DISABLE KEYS */;
INSERT INTO `email_lists` VALUES (1,1,'contact@alexandrubagu.info','red.gb.net','993','appkind@red.gb.net','*lR70w4v',0);
/*!40000 ALTER TABLE `email_lists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `messages` (
  `message_id` bigint(255) NOT NULL auto_increment,
  `client_id` bigint(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `receiver` varchar(255) NOT NULL,
  `message` tinytext NOT NULL,
  `validate_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `processed_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `processed` tinyint(4) default '0',
  `sent` tinyint(4) default '0',
  PRIMARY KEY  (`message_id`),
  KEY `client_id` (`client_id`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`client_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,1,'17AE4752-3C8E-11E3-9B3E-50248EDB15BC','hallo1111','alexandru.bagu@webfusion.com','body1111','2013-10-25 09:27:54','2013-10-25 08:27:54',1,0),(2,1,'C1359F46-3C8E-11E3-ABC9-4E298EDB15BC','abc1111','alexandru.bagu@webfusion.com','11111','2013-10-25 09:27:54','2013-10-25 08:27:54',1,0);
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages_log`
--

DROP TABLE IF EXISTS `messages_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `messages_log` (
  `client_id` bigint(255) NOT NULL,
  `device_id` bigint(255) NOT NULL,
  `message_id` bigint(255) NOT NULL,
  `processed` tinyint(1) NOT NULL,
  `send_on` date NOT NULL,
  KEY `client_id` (`client_id`),
  KEY `device_id` (`device_id`),
  KEY `message_id` (`message_id`),
  CONSTRAINT `messages_log_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`client_id`),
  CONSTRAINT `messages_log_ibfk_2` FOREIGN KEY (`device_id`) REFERENCES `devices` (`device_id`),
  CONSTRAINT `messages_log_ibfk_3` FOREIGN KEY (`message_id`) REFERENCES `messages` (`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages_log`
--

LOCK TABLES `messages_log` WRITE;
/*!40000 ALTER TABLE `messages_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `messages_log` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-10-25 10:30:27
