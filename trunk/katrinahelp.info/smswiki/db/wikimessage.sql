CREATE TABLE wiki_messages (
  `id` int(11) NOT NULL auto_increment,
  mar VARCHAR(16383),
  subj VARCHAR(255),
  body VARCHAR(1024),
  created_at datetime,
  modified_at datetime,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;
