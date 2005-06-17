-- MySQL dump 9.11
--
-- Host: localhost    Database: wavedbrails_development
-- ------------------------------------------------------
-- Server version	4.0.22_Debian-6-log

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `supplies`;
CREATE TABLE `supplies` (
  `id` int(11) NOT NULL auto_increment,
  `loc` varchar(32) NOT NULL default '',
  `supcat` int(11),
  `flags` int(11) default '0',
  `name` varchar(32) NOT NULL default '',
  `quantity` varchar(32) NOT NULL default '',
  `origcode` char(2) NOT NULL default '',
  `status` int(11) default '0',  /* 0 = Requested, ... Scheduled, Shipped, Received, Used up */
  `fromcon` varchar(255),
  `tocon` varchar(255),
  `fromloc` varchar(32) NOT NULL default '',
  `toloc` varchar(32) NOT NULL default '',
  `notes` varchar(255),
  `fromwho` varchar(255),
  `cuid` int(11),
  `muid` int(11),
  `lastchange` TIMESTAMP,
  `emails` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`),
  KEY `name` (`name`),
  KEY `supcat` (`supcat`),
  KEY `flags` (`flags`),
  KEY `fromloc` (`fromloc`),
  KEY `toloc` (`toloc`),
  KEY `notes` (`notes`),
  KEY `fromwho` (`fromwho`)
) TYPE=MyISAM;

