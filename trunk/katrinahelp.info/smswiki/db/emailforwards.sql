CREATE TABLE email_forwards (
  `id` int(11) NOT NULL auto_increment,
  email VARCHAR(1024),
  created_at datetime,
  modified_at datetime,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;
