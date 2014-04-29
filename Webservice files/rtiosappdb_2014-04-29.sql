# ************************************************************
# Sequel Pro SQL dump
# Version 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: rtiosappdb.db.11208285.hostedresource.com (MySQL 5.5.33-log)
# Database: rtiosappdb
# Generation Time: 2014-04-29 21:46:21 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table programmes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `programmes`;

CREATE TABLE `programmes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `venue` varchar(250) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT '12:00:00',
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

LOCK TABLES `programmes` WRITE;
/*!40000 ALTER TABLE `programmes` DISABLE KEYS */;

INSERT INTO `programmes` (`id`, `name`, `venue`, `date`, `time`, `description`)
VALUES
	(1,'Keynote','Moscone Center 747 Howard St, San Francisco, CA 94103','2014-04-29','06:00:00','Very long description Very long description Very long description Very long description Very long description Very long description Very long description Very long description Very long description Very long description Very long description Very long description'),
	(2,'iOS Session','Moscone Center 747 Howard St, San Francisco, CA 94103','2014-04-30','08:00:00','No Description'),
	(3,'Android Session','Moscone Center 747 Howard St, San Francisco, CA 94103','2014-05-02','19:00:00','No Description'),
	(4,'Windows Session','Moscone Center 747 Howard St, San Francisco, CA 94103','2014-04-30','09:30:00','No Description'),
	(5,'Blackberry Session','Moscone Center 747 Howard St, San Francisco, CA 94103','2014-04-30','10:00:00','No Description'),
	(6,'iOS Workshop','Moscone Center 747 Howard St, San Francisco, CA 94103','2014-05-01','15:00:00','No Description'),
	(8,'Lunch','Moscone Center 747 Howard St, San Francisco, CA 94103','2014-04-30','11:00:00','No Description'),
	(10,'Google Glass','Moscone Center 747 Howard St, San Francisco, CA 94103','2014-05-03','12:00:00',''),
	(11,'Lunch','Moscone Center 747 Howard St, San Francisco, CA 94103','2014-05-03','11:00:00','');

/*!40000 ALTER TABLE `programmes` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table user_programmes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user_programmes`;

CREATE TABLE `user_programmes` (
  `userid` int(11) unsigned NOT NULL,
  `programmeid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `user_programmes` WRITE;
/*!40000 ALTER TABLE `user_programmes` DISABLE KEYS */;

INSERT INTO `user_programmes` (`userid`, `programmeid`)
VALUES
	(17,4),
	(21,5),
	(20,2),
	(19,3),
	(17,5),
	(25,3),
	(25,5),
	(32,2),
	(32,5),
	(20,3),
	(31,1),
	(18,3);

/*!40000 ALTER TABLE `user_programmes` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `firstname` varchar(50) NOT NULL DEFAULT '',
  `lastname` varchar(50) DEFAULT '',
  `email` varchar(50) NOT NULL DEFAULT '',
  `password` varchar(50) DEFAULT '',
  `photo` varchar(2083) DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=latin1;

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;

INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `password`, `photo`)
VALUES
	(15,'Jennifer','Lawrence','r@r.rrr','pass','http://www.naportals.com/wp-content/uploads/2014/02/Jennifer-lawrence-Wallpaper-3.jpg'),
	(16,'Leonardo','diCaprio','ju','hyk','http://images6.fanpop.com/image/photos/36600000/the-wolf-of-wall-street-image-the-wolf-of-wall-street-36654976-713-478.png'),
	(17,'Matt','Damon','hj','jj','http://img2.timeinc.net/people/i/2008/database/mattdamon/mattdamon300.jpg'),
	(18,'Steve','Jobs','r@r.rr','pass','http://s3.amazonaws.com/crunchbase_prod_assets/assets/images/resized/0001/0974/10974v7-max-250x250.jpg'),
	(19,'Chuck','Norris','ggde@grg.gnu','ggt','http://www.empireonline.com/images/uploaded/chuck-norris-uzis.jpg'),
	(20,'George','Carlin','gg@gff.fg','ert','http://img2.wikia.nocookie.net/__cb20110925235641/disney/images/4/40/George_Carlin_2.jpg'),
	(21,'Barack','Obama','a@a.aa','123','http://rack.1.mshcdn.com/media/ZgkyMDEyLzEyLzA0L2IzL2JhcmFja29iYW1hLmMzWi5qcGcKcAl0aHVtYgk5NTB4NTM0IwplCWpwZw/5b0bff81/e0a/barack-obama-look-alike-wants-privacy-and-bar-mitzvah-gigs-223a5782e9.jpg'),
	(24,'Issac','Newton','i@a.as','123','http://upload.wikimedia.org/wikipedia/commons/thumb/3/39/GodfreyKneller-IsaacNewton-1689.jpg/220px-GodfreyKneller-IsaacNewton-1689.jpg'),
	(25,'Steve','Carell','a@df.ss','123','http://www.contactmusic.com/pics/lf/hope_springs_5_070812/steve-carell-premiere-of-hope-springs-at_4023744.jpg'),
	(26,'Mark','Zuckerberg','las@alsd.asfd','123','http://a4.files.saymedia-content.com/image/upload/c_fill,g_face,h_300,q_70,w_300/MTIwNjA4NjMzNjg3ODAzNDA0.jpg'),
	(27,'Tony','Hawk','a@aa.aaa','pass','http://images.nationalgeographic.com/wpf/media-live/photos/000/269/cache/one-on-one-tony-hawk_26983_600x450.jpg'),
	(31,'Bill','Gates','bb@bb.aa','123','http://s1.ibtimes.com/sites/www.ibtimes.com/files/styles/v2_article_large/public/2013/03/01/bill-gates.jpg'),
	(32,'Robert','Downey Jr.','q@q.qq','123','http://images5.fanpop.com/image/photos/31800000/Robert-Downey-jr-robert-downey-jr-31831924-480-720.jpg');

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
