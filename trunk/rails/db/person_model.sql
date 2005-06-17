DROP TABLE if exists people;
CREATE TABLE people (
  id int(11) NOT NULL auto_increment,
  name varchar(64),  /* full name if available */
  age int(11), /* in years, at least 1.  0 means unknown */
  sex int(11), /* 1 = Male, 2 = Female, 0 = unspecified */
  height varchar(16),
  weight varchar(16),
  haircolor varchar(16),
  eyecolor varchar(16),
  homeaddr varchar(255),  /* Address of person before disaster */
  famconame varchar(64),  /* Family contact name */
  famcophone varchar(64), /* Family contact phone */
  famcorel varchar(64),   /* Family contact relationship */
  famemail varchar(64),   /* Family contact email */
  famnum int(11),         /* Number in family */
  relconame varchar(64),  /* Relief/aid worker contact name */
  relcophone varchar(64), /* Relief/aid worker phone */
  relcoorg varchar(64),   /* Relief/aid worker organization involved */
  speclostplace text,     /* Where the person specifically was before missing */
  lostloc varchar(64) default "G-U",    /* Where the person was before missing */
  foundloc varchar(64) default "G-U",   /* Where the person was found, if found */
  stayingloc varchar(64) default "G-U", /* Where the person is staying */
  status int,             /* 0 = unspecified, 1 = Alive, 2 = Dead, 3 = Injured, 4 = Missing */
  lastupdate timestamp,   /* last time status changed */
  notes text,             /* Misc. info */
  emails text,            /* A list of 0 or more email addresses seperated by commas that are interested in this person */
  mednotes text,          /* Medical notes */
  hospital varchar(128),  /* Hospital where person is */
  origcode char(2),       /* 2-letter country code for nationality */
  cuid int(11),           /* whoever entered this field */
  createtime timestamp,   /* when this record was created */
  muid int(11),           /* whoever modified */
  modtime timestamp,      /* when this record was modified */
  PRIMARY KEY (id),
  INDEX (name), INDEX (notes(255))
) TYPE=MyISAM;

