-- MySQL dump 9.11
--
-- Host: localhost    Database: peopledb
-- ------------------------------------------------------
-- Server version	4.0.24_Debian-10-log

--
-- Table structure for table `people`
--

CREATE TABLE `pets` (
  `id` int(11) NOT NULL auto_increment,
  kennel_id int(11),
  sourceref varchar(255) default NULL,
  sourceurl varchar(255) default NULL,
  listing varchar(64) default NULL,
  animaltype varchar(64) default NULL,
  gender varchar(64) default NULL,
  breed varchar(255) default NULL,
  age varchar(64) default NULL,
  bodysize varchar(64) default NULL,
  color varchar(64) default NULL,
  coat varchar(64) default NULL,
  markings varchar(255) default NULL,
  petname varchar(64) default NULL,
  lastlocal varchar(255) default NULL,
  lastdetail varchar(255) default NULL,
  currentlocal varchar(255) default NULL,
  isneutered varchar(255) default NULL,
  ismixed varchar(255) default NULL,
  isresolved int(11),
  notes varchar(255),
  created_at datetime,
  `searchstuff` text,
  `searchhelper` int(11) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `id` (`id`),
  FULLTEXT KEY `searchstuff` (`searchstuff`)
) TYPE=MyISAM;
  
  
