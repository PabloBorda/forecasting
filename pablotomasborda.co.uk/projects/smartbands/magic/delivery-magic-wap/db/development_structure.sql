CREATE TABLE `cards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(255) DEFAULT NULL,
  `lastname` varchar(255) DEFAULT NULL,
  `expmonth` varchar(255) DEFAULT NULL,
  `expyear` varchar(255) DEFAULT NULL,
  `cardnumber` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=latin1;

CREATE TABLE `companies` (
  `id` int(11) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `street` varchar(45) DEFAULT NULL,
  `number` int(11) DEFAULT NULL,
  `logo` varchar(1024) DEFAULT NULL,
  `webpage` varchar(2048) DEFAULT NULL,
  `cards_id` int(11) DEFAULT NULL,
  `email` varchar(512) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `companies_cards` (`cards_id`),
  CONSTRAINT `companies_cards` FOREIGN KEY (`cards_id`) REFERENCES `cards` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `street` varchar(64) DEFAULT NULL,
  `number` int(11) DEFAULT NULL,
  `companies_id` int(11) NOT NULL,
  `phone` varchar(35) DEFAULT NULL,
  `timestamp` datetime NOT NULL,
  `depto` varchar(4) DEFAULT NULL,
  `streets_id` int(11) NOT NULL,
  `amount` float NOT NULL,
  `concuanto` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_orders_companies1` (`companies_id`),
  KEY `fk_orders_streets` (`streets_id`),
  CONSTRAINT `fk_orders_companies1` FOREIGN KEY (`companies_id`) REFERENCES `companies` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_streets` FOREIGN KEY (`streets_id`) REFERENCES `streets` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(256) DEFAULT NULL,
  `price` float DEFAULT NULL,
  `companies_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_products_companies1` (`companies_id`),
  CONSTRAINT `fk_products_companies1` FOREIGN KEY (`companies_id`) REFERENCES `companies` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `products_orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amount` int(11) NOT NULL,
  `products_id` int(11) NOT NULL,
  `orders_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_products_orders_products` (`products_id`),
  KEY `fk_products_orders_orders1` (`orders_id`),
  CONSTRAINT `fk_products_orders_orders1` FOREIGN KEY (`orders_id`) REFERENCES `orders` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_products_orders_products` FOREIGN KEY (`products_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `products_pictures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `products_id` int(11) NOT NULL,
  `url` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `stores` (
  `id` int(11) NOT NULL,
  `streets_id` int(11) DEFAULT NULL,
  `number` int(11) DEFAULT NULL,
  `companies_id` int(11) NOT NULL,
  `lat` float NOT NULL DEFAULT '0',
  `lng` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_stores_companies1` (`companies_id`),
  KEY `fk_stores_streets` (`streets_id`),
  CONSTRAINT `fk_stores_companies1` FOREIGN KEY (`companies_id`) REFERENCES `companies` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_stores_streets` FOREIGN KEY (`streets_id`) REFERENCES `streets` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `streets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(1024) CHARACTER SET latin1 NOT NULL,
  `desde` int(11) DEFAULT NULL,
  `hasta` int(11) DEFAULT NULL,
  `localidad` varchar(256) CHARACTER SET latin1 NOT NULL,
  `partido` varchar(256) CHARACTER SET latin1 NOT NULL,
  `zona` varchar(256) CHARACTER SET latin1 NOT NULL,
  `nombreampliado` varchar(1024) CHARACTER SET latin1 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=87127 DEFAULT CHARSET=utf8;

CREATE TABLE `transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `amount` float NOT NULL,
  `timestamp` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

