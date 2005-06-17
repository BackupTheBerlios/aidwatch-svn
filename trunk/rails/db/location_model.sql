-- MySQL dump 9.11
--
-- Host: localhost    Database: wavedbrails_development
-- ------------------------------------------------------
-- Server version	4.0.22_Debian-6-log

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `locations`;
CREATE TABLE `locations` (
  `id` int(11) NOT NULL auto_increment,
  `loccode` varchar(32) NOT NULL default '',
  `name` varchar(32) NOT NULL default '',
  `prompt` varchar(32) default NULL,
  `flags` int(11) default '0',
  `fullcode` varchar(255) NOT NULL default '',
  `parent` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `name` (`name`),
  UNIQUE KEY `fullcode` (`fullcode`),
  KEY `loccode` (`loccode`),
  KEY `flags` (`flags`),
  KEY `parent` (`parent`)
) TYPE=MyISAM;

