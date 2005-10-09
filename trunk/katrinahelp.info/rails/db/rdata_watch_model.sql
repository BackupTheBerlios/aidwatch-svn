-- MySQL dump 9.11
--
-- Host: localhost    Database: peopledb
-- ------------------------------------------------------
-- Server version	4.0.24_Debian-10-log

--
-- Table structure for table `people`
--

CREATE TABLE `watches` (
  `id` int(11) NOT NULL auto_increment,
  pet_id int(11),
  email varchar(255),
  notes varchar(255),
  created_at datetime,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `id` (`id`)
);
  
  
