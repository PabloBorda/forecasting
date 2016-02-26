-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.0.84-log


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


--
-- Create schema mydb
--

CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;

--
-- Definition of table `mydb`.`companies`
--

DROP TABLE IF EXISTS `mydb`.`companies`;
CREATE TABLE  `mydb`.`companies` (
  `idcompany` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY  (`idcompany`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mydb`.`companies`
--

/*!40000 ALTER TABLE `companies` DISABLE KEYS */;
LOCK TABLES `companies` WRITE;
UNLOCK TABLES;
/*!40000 ALTER TABLE `companies` ENABLE KEYS */;


--
-- Definition of table `mydb`.`users`
--

DROP TABLE IF EXISTS `mydb`.`users`;
CREATE TABLE  `mydb`.`users` (
  `id` int(11) NOT NULL auto_increment,
  `firstname` varchar(100) NOT NULL,
  `lastname` varchar(100) NOT NULL,
  `birthdate` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  PRIMARY KEY  USING BTREE (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mydb`.`users`
--

/*!40000 ALTER TABLE `users` DISABLE KEYS */;
LOCK TABLES `users` WRITE;
INSERT INTO `mydb`.`users` VALUES  (10,'','','','VentureCapitals@hotmail.com'),
 (11,'','','','Papurro1983@hotmail.com'),
 (12,'','','','Pablote.20@gmail.com'),
 (13,'','','','popo@coco.com');
UNLOCK TABLES;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;


--
-- Definition of table `mydb`.`users_has_companies`
--

DROP TABLE IF EXISTS `mydb`.`users_has_companies`;
CREATE TABLE  `mydb`.`users_has_companies` (
  `users_iduser` int(11) NOT NULL,
  `companies_idcompany` int(11) NOT NULL,
  `position` varchar(160) default NULL,
  PRIMARY KEY  (`users_iduser`,`companies_idcompany`),
  KEY `fk_users_has_companies_users` (`users_iduser`),
  KEY `fk_users_has_companies_companies1` (`companies_idcompany`),
  CONSTRAINT `fk_users_has_companies_companies1` FOREIGN KEY (`companies_idcompany`) REFERENCES `companies` (`idcompany`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_companies_users` FOREIGN KEY (`users_iduser`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mydb`.`users_has_companies`
--

/*!40000 ALTER TABLE `users_has_companies` DISABLE KEYS */;
LOCK TABLES `users_has_companies` WRITE;
UNLOCK TABLES;
/*!40000 ALTER TABLE `users_has_companies` ENABLE KEYS */;


--
-- Definition of table `mydb`.`users_has_users`
--

DROP TABLE IF EXISTS `mydb`.`users_has_users`;
CREATE TABLE  `mydb`.`users_has_users` (
  `user_id` int(11) NOT NULL,
  `relatives_id` int(11) NOT NULL,
  `comparison_value` int(11) NOT NULL,
  PRIMARY KEY  (`user_id`,`relatives_id`),
  KEY `new_fk_constraint_relatives` (`relatives_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `mydb`.`users_has_users`
--

/*!40000 ALTER TABLE `users_has_users` DISABLE KEYS */;
LOCK TABLES `users_has_users` WRITE;
INSERT INTO `mydb`.`users_has_users` VALUES  (10,11,3173),
 (10,12,4055),
 (10,13,0),
 (11,12,60108),
 (11,13,7718),
 (12,13,5773);
UNLOCK TABLES;
/*!40000 ALTER TABLE `users_has_users` ENABLE KEYS */;




/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
