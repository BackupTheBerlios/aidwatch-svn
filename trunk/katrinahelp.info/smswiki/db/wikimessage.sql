CREATE TABLE wiki_messages (
  `id` int(11) NOT NULL auto_increment,
  mar BLOB,
  subj VARCHAR(1024),
  body BLOB,
  created_at datetime,
  modified_at datetime,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;
