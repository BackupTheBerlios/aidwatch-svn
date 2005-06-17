-- MySQL dump 9.11
--
-- Host: localhost    Database: wavedbrails_development
-- ------------------------------------------------------
-- Server version	4.0.22_Debian-6-log

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(80) default NULL,
  `password` varchar(40) default NULL,
  `flags` int(11) default '0',
  `email` varchar(64) default NULL,
  `writep` varchar(255) NOT NULL default '',
  `readp` varchar(255) NOT NULL default '',
  `managep` varchar(255) NOT NULL default '',
  `adminp` varchar(255) NOT NULL default '',
  `veremail` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

