-- MySQL dump 9.11
--
-- Host: localhost    Database: peopledb
-- ------------------------------------------------------
-- Server version	4.0.24_Debian-10-log

--
-- Table structure for table `people`
--

CREATE TABLE `people` (
  `id` int(11) NOT NULL auto_increment,
  `person_record_id` varchar(255) default NULL,
  `entry_date` varchar(255) default NULL,
  `author_name` varchar(255) default NULL,
  `author_email` varchar(255) default NULL,
  `author_phone` varchar(128) default NULL,
  `source_name` varchar(255) default NULL,
  `source_date` varchar(255) default NULL,
  `source_url` varchar(255) default NULL,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `home_street` varchar(255) default NULL,
  `home_city` varchar(255) default NULL,
  `home_state` varchar(64) default NULL,
  `home_zip` varchar(32) default NULL,
  `photo_url` varchar(255) default NULL,
  `privacy_misc` varchar(255) default NULL,
  `home_neighborhood` varchar(64) default NULL,
  `note_record_id` varchar(255) default NULL,
  `misctext` text,
  `other` text,
  `searchstuff` text,
  `searchhelper` int(11) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `id` (`id`),
  FULLTEXT KEY `searchstuff` (`searchstuff`)
) TYPE=MyISAM;

