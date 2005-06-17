-- MySQL dump 9.11
--
-- Host: localhost    Database: wavedbrails_development
-- ------------------------------------------------------
-- Server version	4.0.22_Debian-6-log

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `diseases`;
CREATE TABLE `diseases` (
  `id` int(11) NOT NULL auto_increment,
  `loc` varchar(32) NOT NULL default 'G-U',
  `discat` int(11), /* Disease category */
  `flags` int(11) default '0',
  `name` varchar(32) NOT NULL default '',
  `numcases` int(11) NOT NULL default '1',
  `reliefcon` varchar(32) NOT NULL default '', /* Relief contact */
  `when` TIMESTAMP,
  `notes` text,
  `cuid` int(11),
  `muid` int(11),
  `lastchange` TIMESTAMP,
  `emails` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`),
  KEY `loc` (`loc`),
  KEY `discat` (`discat`),
  KEY `flags` (`flags`),
  KEY `name` (`name`),
  KEY `numcases` (`numcases`),
  KEY `reliefcon` (`reliefcon`),
  KEY `when` (`when`),
  KEY `notes` (`notes`),
  KEY `cuid` (`cuid`),
  KEY `muid` (`muid`),
  KEY `lastchange` (`lastchange`),
  KEY `emails` (`emails`)
) TYPE=MyISAM;

