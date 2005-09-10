/* 
 Mysql dump of the user table 
 this adds a user with login test and password test 
*/

--
-- Table structure for table `users`
--
 
CREATE TABLE users (
  id int(11) NOT NULL auto_increment,
  login varchar(80) default NULL,
  password varchar(40) default NULL,
  PRIMARY KEY  (id)
) TYPE=MyISAM;
 
--
-- Dumping data for table `users`
--
 
INSERT INTO users VALUES (1,'test','9a91e1d8d95b6315991a88121bb0aa9f03ba0dfc');