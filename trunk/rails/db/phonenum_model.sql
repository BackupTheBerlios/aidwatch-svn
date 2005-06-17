-- MySQL dump 9.11
--
-- Host: localhost    Database: wavedbrails_production
-- ------------------------------------------------------
-- Server version	4.0.22_Debian-6-log

--
-- Table structure for table `phonenums`
--

DROP TABLE IF EXISTS `phonenums`;
CREATE TABLE `phonenums` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(64) default NULL,
  `dialcode` varchar(64) default NULL,
  `notes` text,
  `loc` varchar(64) default 'G-U',
  `flags` int(11) NOT NULL default '0',
  `cat` int(11) default NULL,
  `uid` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `name` (`name`),
  KEY `notes` (`notes`(255))
) TYPE=MyISAM;

