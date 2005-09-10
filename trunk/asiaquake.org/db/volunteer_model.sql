DROP TABLE if exists volunteers;
CREATE TABLE volunteers (
  id int(11) NOT NULL auto_increment,
  name varchar(64),  /* full name if available */
  age int(11),       /* in years, at least 1.  0 means unknown */
  sex int(11),       /* 1 = Male, 2 = Female, 0 = unspecified */
  email varchar(64),
  phone varchar(64),
  curloc varchar(64) default "G-U",    /* current location */
  targetloc varchar(64) default "G-U", /* destination location */
  targetstart timestamp,     /* ideal start time */
  targetend timestamp,       /* ideal end time */
  targetagency varchar(255), /* the ideal agency to join up with */
  flags int(11),    /* last bit = can pay own way */
  skillcat int(11), /* 0 = unspecified, 1 = Medical, 2 = Logistic, 3 = Construction, 4 = Other Please Specify */
  skilldesc varchar(255),
  origcode char(2),
  notes text,
  cuid int(11) not null default '0',   /* created uid */
  muid int(11) not null default '0',   /* modified uid */
  canpay int(11) not null default '0', /* 0 = unspec, 1 = yes, 2 = no */
  PRIMARY KEY (id),
  INDEX (name), INDEX (notes(255)), INDEX (phone),
  INDEX (curloc), INDEX (targetloc),
  INDEX (targetagency), INDEX (flags),
  INDEX (skillcat),
  INDEX (skilldesc)
) TYPE=MyISAM;

