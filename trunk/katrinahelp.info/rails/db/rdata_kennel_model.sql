-- MySQL dump 9.11
--
-- Host: localhost    Database: peopledb
-- ------------------------------------------------------
-- Server version	4.0.24_Debian-10-log

--
-- Table structure for table `people`
--

CREATE TABLE `kennels` (
  `id` int(11) NOT NULL auto_increment,
  `last_name` varchar(255) default NULL,
  `first_name` varchar(255) default NULL,
  `address1` varchar(255) default NULL,
  `address2` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `state` varchar(64) default NULL,
  `zip` varchar(32) default NULL,
  `phone` varchar(32) default NULL,
  `email` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `mqurl` varchar(255) default NULL,
  `misctext` text,
  `other` text,
  `searchstuff` text,
  `searchhelper` int(11) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `id` (`id`),
  FULLTEXT KEY `searchstuff` (`searchstuff`)
) TYPE=MyISAM;

