-- MySQL dump 10.13  Distrib 8.0.45, for Linux (x86_64)
--
-- Host: gateway01.ap-southeast-1.prod.aws.tidbcloud.com    Database: smart_pos_db
-- ------------------------------------------------------
-- Server version	8.0.11-TiDB-v8.5.3-serverless

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_id`) /*T![clustered_index] CLUSTERED */,
  UNIQUE KEY `category_name` (`category_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin AUTO_INCREMENT=90001;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Beverages','Cold and hot drinks','2026-05-29 11:19:32'),(2,'Groceries','Daily essential items','2026-05-29 11:19:32'),(3,'Electronics','Small electronic accessories','2026-05-29 11:19:32'),(60001,'Books','CR Book','2026-05-30 07:40:42');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `customer_name` varchar(100) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `loyalty_points` int DEFAULT '0',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`customer_id`) /*T![clustered_index] CLUSTERED */,
  UNIQUE KEY `phone_number` (`phone_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin AUTO_INCREMENT=30001;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'Kamal Perera','0771234567',0,'2026-05-29 11:19:34'),(2,'Nimal Silva','0719876543',0,'2026-05-29 11:19:34');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `category_id` int DEFAULT NULL,
  `barcode` varchar(100) NOT NULL,
  `product_name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `cost_price` decimal(10,2) NOT NULL,
  `selling_price` decimal(10,2) NOT NULL,
  `stock_quantity` int DEFAULT '0',
  `min_stock_level` int DEFAULT '5',
  `status` enum('AVAILABLE','OUT_OF_STOCK','DISCONTINUED') DEFAULT 'AVAILABLE',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`) /*T![clustered_index] CLUSTERED */,
  UNIQUE KEY `barcode` (`barcode`),
  KEY `fk_1` (`category_id`),
  CONSTRAINT `fk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin AUTO_INCREMENT=90001;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,1,'8901234567890','Coca Cola 1.5L',NULL,300.00,380.00,47,10,'AVAILABLE','2026-05-29 11:19:33','2026-05-29 16:08:26'),(2,2,'4792000123456','Samba Rice 5kg',NULL,1000.00,1150.00,96,20,'AVAILABLE','2026-05-29 11:19:33','2026-05-29 16:27:33'),(3,3,'6901234560001','USB Type-C Cable',NULL,450.00,800.00,13,5,'AVAILABLE','2026-05-29 11:19:33','2026-05-30 08:09:13'),(30001,3,'fffjfjdhd','aaaaaaaaaa','-',1000.00,1500.00,50,10,'AVAILABLE','2026-05-29 14:57:14','2026-05-30 03:50:23'),(60001,60001,'4792210136384','120 Single Rule','-',230.00,250.00,99,10,'AVAILABLE','2026-05-30 07:41:38','2026-05-30 07:57:45'),(60002,3,'695457013195','Chager Micro Type','-',800.00,950.00,50,5,'AVAILABLE','2026-05-30 07:42:48','2026-05-30 07:42:48');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sale_items`
--

DROP TABLE IF EXISTS `sale_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_items` (
  `sale_item_id` int NOT NULL AUTO_INCREMENT,
  `sale_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `item_subtotal` decimal(10,2) NOT NULL,
  PRIMARY KEY (`sale_item_id`) /*T![clustered_index] CLUSTERED */,
  KEY `fk_1` (`sale_id`),
  KEY `fk_2` (`product_id`),
  CONSTRAINT `fk_1` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`sale_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin AUTO_INCREMENT=150001;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sale_items`
--

LOCK TABLES `sale_items` WRITE;
/*!40000 ALTER TABLE `sale_items` DISABLE KEYS */;
INSERT INTO `sale_items` VALUES (1,1,2,1,1150.00,1150.00),(2,1,1,1,380.00,380.00),(3,2,2,1,1150.00,1150.00),(4,2,1,2,380.00,760.00),(30001,30001,2,2,1150.00,2300.00),(60001,60001,30001,1,1500.00,1500.00),(90001,90001,60001,1,250.00,250.00),(120001,120001,3,2,800.00,1600.00);
/*!40000 ALTER TABLE `sale_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales`
--

DROP TABLE IF EXISTS `sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales` (
  `sale_id` int NOT NULL AUTO_INCREMENT,
  `invoice_number` varchar(50) NOT NULL,
  `user_id` int NOT NULL,
  `customer_id` int DEFAULT NULL,
  `sub_total` decimal(10,2) NOT NULL,
  `discount_amount` decimal(10,2) DEFAULT '0.00',
  `tax_amount` decimal(10,2) DEFAULT '0.00',
  `net_total` decimal(10,2) NOT NULL,
  `payment_method` enum('CASH','CARD','MOBILE_PAY') DEFAULT 'CASH',
  `amount_tendered` decimal(10,2) NOT NULL,
  `change_due` decimal(10,2) NOT NULL,
  `sale_date` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`sale_id`) /*T![clustered_index] CLUSTERED */,
  UNIQUE KEY `invoice_number` (`invoice_number`),
  KEY `fk_1` (`user_id`),
  KEY `fk_2` (`customer_id`),
  CONSTRAINT `fk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin AUTO_INCREMENT=150001;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales`
--

LOCK TABLES `sales` WRITE;
/*!40000 ALTER TABLE `sales` DISABLE KEYS */;
INSERT INTO `sales` VALUES (1,'INV-1780070662343',2,NULL,1530.00,0.00,0.00,1530.00,'CASH',2000.00,470.00,'2026-05-29 16:04:24'),(2,'INV-1780070903757',2,NULL,1910.00,0.00,0.00,1910.00,'CASH',2000.00,90.00,'2026-05-29 16:08:25'),(30001,'INV-1780072050860',2,NULL,2300.00,0.00,0.00,2300.00,'CASH',2500.00,200.00,'2026-05-29 16:27:32'),(60001,'INV-1780112570764',2,NULL,1500.00,0.00,0.00,1500.00,'CASH',2000.00,500.00,'2026-05-30 03:42:53'),(90001,'INV-1780127861943',2,NULL,250.00,0.00,0.00,250.00,'CASH',500.00,250.00,'2026-05-30 07:57:44'),(120001,'INV-1780128550655',60001,NULL,1600.00,0.00,0.00,1600.00,'CASH',2000.00,400.00,'2026-05-30 08:09:12');
/*!40000 ALTER TABLE `sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_settings`
--

DROP TABLE IF EXISTS `system_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_settings` (
  `id` int NOT NULL DEFAULT '1',
  `shop_name` varchar(100) NOT NULL,
  `shop_address` varchar(255) DEFAULT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `currency_symbol` varchar(10) DEFAULT 'Rs.',
  `tax_percentage` decimal(5,2) DEFAULT '0.00',
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_settings`
--

LOCK TABLES `system_settings` WRITE;
/*!40000 ALTER TABLE `system_settings` DISABLE KEYS */;
INSERT INTO `system_settings` VALUES (1,'SuperMart POS','123 Main Street, Colombo','011-2345678','Rs.',0.00,'2026-05-29 11:19:28');
/*!40000 ALTER TABLE `system_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(7) DEFAULT NULL,
  `status` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`) /*T![clustered_index] CLUSTERED */,
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin AUTO_INCREMENT=90001;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Admin User','admin@pos.com','admin123','ADMIN','ACTIVE','2026-05-29 11:19:29'),(2,'P Cashier','cashier@pos.com','cashier123','CASHIER','ACTIVE','2026-05-29 11:19:29'),(30001,'Admin1','admin1@pos.com','12345678','ADMIN','ACTIVE','2026-05-29 17:24:45'),(60001,'P2 Cashier','cashier2@pos.com','12345678','CASHIER','ACTIVE','2026-05-30 08:07:57');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-30  8:49:04
