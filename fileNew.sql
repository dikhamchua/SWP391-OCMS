-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: ocms2
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(13) DEFAULT NULL,
  `full_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `gender` tinyint(1) DEFAULT NULL,
  `avatar` longtext,
  `is_active` bit(1) NOT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  KEY `role_reference_account_idx` (`role_id`),
  CONSTRAINT `role_reference_account` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account`
--

LOCK TABLES `account` WRITE;
/*!40000 ALTER TABLE `account` DISABLE KEYS */;
INSERT INTO `account` VALUES (1,'4user01','25f9e794323b453885f5181f1b624d0b','vinhpham2761@gmail.com','0123456189','vxcvxcvxc',0,'/uploads/1736991087340_472912401_4083576705208425_1896537290520245468_n.jpg',_binary '\0',3),(7,'4user02','25d55ad283aa400af464c76d713c07ad','mmxfn4ab@mailpwr.com',NULL,NULL,0,NULL,_binary '\0',3),(8,'admin','c4ca4238a0b923820dcc509a6f75849b','admin@gmail.com',NULL,NULL,1,NULL,_binary '',1),(9,'4user03','c4ca4238a0b923820dcc509a6f75849b','teacher@gmail.com',NULL,NULL,1,NULL,_binary '',2),(10,'4user04','c4ca4238a0b923820dcc509a6f75849b','user01@gmail.com',NULL,NULL,1,NULL,_binary '',4),(11,'user02','c4ca4238a0b923820dcc509a6f75849b','user02@gmail.com',NULL,NULL,0,NULL,_binary '',1),(12,'user03','c4ca4238a0b923820dcc509a6f75849b','user03@gmail.com',NULL,NULL,1,NULL,_binary '\0',2),(13,'user04','c4ca4238a0b923820dcc509a6f75849b','user04@gmail.com',NULL,NULL,0,NULL,_binary '',1),(14,'user05','c4ca4238a0b923820dcc509a6f75849b','user05@gmail.com',NULL,NULL,1,NULL,_binary '',2),(15,'user06','c4ca4238a0b923820dcc509a6f75849b','user06@gmail.com',NULL,NULL,0,NULL,_binary '\0',1),(16,'user07','c4ca4238a0b923820dcc509a6f75849b','user07@gmail.com',NULL,NULL,1,NULL,_binary '',2),(17,'user08','c4ca4238a0b923820dcc509a6f75849b','user08@gmail.com',NULL,NULL,0,NULL,_binary '',1),(18,'user09','c4ca4238a0b923820dcc509a6f75849b','user09@gmail.com',NULL,NULL,1,NULL,_binary '\0',2),(19,'user10','c4ca4238a0b923820dcc509a6f75849b','user10@gmail.com',NULL,NULL,0,NULL,_binary '',1),(20,'user11','c4ca4238a0b923820dcc509a6f75849b','user11@gmail.com',NULL,NULL,1,NULL,_binary '',2),(21,'user12','c4ca4238a0b923820dcc509a6f75849b','user12@gmail.com',NULL,NULL,0,NULL,_binary '\0',1),(22,'user13','c4ca4238a0b923820dcc509a6f75849b','user13@gmail.com',NULL,NULL,1,NULL,_binary '',2),(23,'user14','c4ca4238a0b923820dcc509a6f75849b','user14@gmail.com',NULL,NULL,0,NULL,_binary '',1),(24,'user15','c4ca4238a0b923820dcc509a6f75849b','user15@gmail.com',NULL,NULL,1,NULL,_binary '\0',2),(25,'user16','c4ca4238a0b923820dcc509a6f75849b','user16@gmail.com',NULL,NULL,0,NULL,_binary '',1),(26,'user17','c4ca4238a0b923820dcc509a6f75849b','user17@gmail.com',NULL,NULL,1,NULL,_binary '',2),(27,'user18','c4ca4238a0b923820dcc509a6f75849b','user18@gmail.com',NULL,NULL,0,NULL,_binary '\0',1),(28,'user19','c4ca4238a0b923820dcc509a6f75849b','user19@gmail.com',NULL,NULL,1,NULL,_binary '',2),(29,'user20','c4ca4238a0b923820dcc509a6f75849b','user20@gmail.com',NULL,NULL,0,NULL,_binary '',1),(30,'user21','c4ca4238a0b923820dcc509a6f75849b','user21@gmail.com',NULL,NULL,1,NULL,_binary '\0',2),(31,'user22','c4ca4238a0b923820dcc509a6f75849b','user22@gmail.com',NULL,NULL,0,NULL,_binary '',1),(32,'user23','c4ca4238a0b923820dcc509a6f75849b','user23@gmail.com',NULL,NULL,1,NULL,_binary '',2),(33,'user24','c4ca4238a0b923820dcc509a6f75849b','user24@gmail.com',NULL,NULL,0,NULL,_binary '\0',1),(34,'user25','c4ca4238a0b923820dcc509a6f75849b','user25@gmail.com',NULL,NULL,1,NULL,_binary '',2),(35,'user26','c4ca4238a0b923820dcc509a6f75849b','user26@gmail.com',NULL,NULL,0,NULL,_binary '',1),(36,'user27','c4ca4238a0b923820dcc509a6f75849b','user27@gmail.com',NULL,NULL,1,NULL,_binary '\0',2),(37,'user28','c4ca4238a0b923820dcc509a6f75849b','user28@gmail.com',NULL,NULL,0,NULL,_binary '',1),(38,'user29','c4ca4238a0b923820dcc509a6f75849b','user29@gmail.com',NULL,NULL,1,NULL,_binary '',2),(39,'user30','c4ca4238a0b923820dcc509a6f75849b','user30@gmail.com',NULL,NULL,0,NULL,_binary '\0',1),(40,'user31','c4ca4238a0b923820dcc509a6f75849b','user31@gmail.com',NULL,NULL,1,NULL,_binary '',2),(41,'user32','c4ca4238a0b923820dcc509a6f75849b','user32@gmail.com',NULL,NULL,0,NULL,_binary '',1),(42,'user33','c4ca4238a0b923820dcc509a6f75849b','user33@gmail.com',NULL,NULL,1,NULL,_binary '\0',2),(43,'user34','c4ca4238a0b923820dcc509a6f75849b','user34@gmail.com',NULL,NULL,0,NULL,_binary '',1),(44,'user35','c4ca4238a0b923820dcc509a6f75849b','user35@gmail.com',NULL,NULL,1,NULL,_binary '',2),(45,'user36','c4ca4238a0b923820dcc509a6f75849b','user36@gmail.com',NULL,NULL,0,NULL,_binary '\0',1),(46,'user37','c4ca4238a0b923820dcc509a6f75849b','user37@gmail.com',NULL,NULL,1,NULL,_binary '',2),(47,'user38','c4ca4238a0b923820dcc509a6f75849b','user38@gmail.com',NULL,NULL,0,NULL,_binary '',1),(48,'user39','c4ca4238a0b923820dcc509a6f75849b','user39@gmail.com',NULL,NULL,1,NULL,_binary '\0',2),(49,'user40','c4ca4238a0b923820dcc509a6f75849b','user40@gmail.com',NULL,NULL,0,NULL,_binary '',1),(50,'user41','c4ca4238a0b923820dcc509a6f75849b','user41@gmail.com',NULL,NULL,1,NULL,_binary '',2),(51,'user42','c4ca4238a0b923820dcc509a6f75849b','user42@gmail.com',NULL,NULL,0,NULL,_binary '\0',1),(52,'user43','c4ca4238a0b923820dcc509a6f75849b','user43@gmail.com',NULL,NULL,1,NULL,_binary '',2),(53,'user44','c4ca4238a0b923820dcc509a6f75849b','user44@gmail.com',NULL,NULL,0,NULL,_binary '',1),(54,'user45','c4ca4238a0b923820dcc509a6f75849b','user45@gmail.com',NULL,NULL,1,NULL,_binary '\0',2),(55,'user46','c4ca4238a0b923820dcc509a6f75849b','user46@gmail.com',NULL,NULL,0,NULL,_binary '',1),(56,'user47','c4ca4238a0b923820dcc509a6f75849b','user47@gmail.com',NULL,NULL,1,NULL,_binary '',2),(57,'user48','c4ca4238a0b923820dcc509a6f75849b','user48@gmail.com',NULL,NULL,0,NULL,_binary '\0',1),(58,'user49','c4ca4238a0b923820dcc509a6f75849b','user49@gmail.com',NULL,NULL,1,NULL,_binary '',2),(59,'user50','c4ca4238a0b923820dcc509a6f75849b','user50@gmail.com',NULL,NULL,0,NULL,_binary '',1);
/*!40000 ALTER TABLE `account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blog`
--

DROP TABLE IF EXISTS `blog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `thumbnail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `brief_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `category_id` int DEFAULT NULL,
  `author` int NOT NULL,
  `updated_date` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('Active','Inactive') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Active',
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  KEY `blog_author_reference_account_id_idx` (`author`),
  CONSTRAINT `blog_author_reference_account_id` FOREIGN KEY (`author`) REFERENCES `account` (`id`),
  CONSTRAINT `blog_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `blog_category` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog`
--

LOCK TABLES `blog` WRITE;
/*!40000 ALTER TABLE `blog` DISABLE KEYS */;
INSERT INTO `blog` VALUES (1,'Cách làm bánh kem đơn giản','https://example.com/thumbnail1.jpg','Hướng dẫn làm bánh kem tại nhà','Nội dung chi tiết về cách làm bánh kem...',1,10,'2025-01-28 11:33:13','2025-01-27 09:52:00','Active'),(2,'10 địa điểm du lịch đẹp nhất Việt Nam','https://example.com/thumbnail2.jpg','Khám phá những địa điểm du lịch nổi tiếng','Nội dung chi tiết về các địa điểm du lịch...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(3,'Cách chăm sóc cây cảnh trong nhà','https://example.com/thumbnail3.jpg','Mẹo chăm sóc cây cảnh hiệu quả','Nội dung chi tiết về cách chăm sóc cây cảnh...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(4,'Công nghệ AI và tương lai của nhân loại','https://example.com/thumbnail4.jpg','AI sẽ thay đổi thế giới như thế nào?','Nội dung chi tiết về công nghệ AI...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(5,'Cách học lập trình hiệu quả','https://example.com/thumbnail5.jpg','Bí quyết học lập trình nhanh chóng','Nội dung chi tiết về cách học lập trình...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(6,'10 cuốn sách hay nhất mọi thời đại','https://example.com/thumbnail6.jpg','Những cuốn sách không thể bỏ qua','Nội dung chi tiết về các cuốn sách hay...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(7,'Cách giảm cân an toàn và hiệu quả','https://example.com/thumbnail7.jpg','Phương pháp giảm cân khoa học','Nội dung chi tiết về cách giảm cân...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(8,'Cách chọn laptop phù hợp với nhu cầu','https://example.com/thumbnail8.jpg','Hướng dẫn chọn laptop tốt nhất','Nội dung chi tiết về cách chọn laptop...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(9,'Cách nấu phở ngon tại nhà','https://example.com/thumbnail9.jpg','Bí quyết nấu phở chuẩn vị Việt','Nội dung chi tiết về cách nấu phở...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(10,'Cách tiết kiệm tiền hiệu quả','https://example.com/thumbnail10.jpg','Mẹo tiết kiệm tiền thông minh','Nội dung chi tiết về cách tiết kiệm tiền...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(11,'Cách chạy bộ đúng cách','https://example.com/thumbnail11.jpg','Hướng dẫn chạy bộ hiệu quả','Nội dung chi tiết về cách chạy bộ...',1,10,'2025-01-28 11:33:13','2025-01-27 09:52:00','Active'),(12,'Cách viết CV ấn tượng','https://example.com/thumbnail12.jpg','Bí quyết viết CV thu hút nhà tuyển dụng','Nội dung chi tiết về cách viết CV...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(13,'Cách chọn giày chạy bộ phù hợp','https://example.com/thumbnail13.jpg','Hướng dẫn chọn giày chạy bộ tốt nhất','Nội dung chi tiết về cách chọn giày...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(14,'Cách học tiếng Anh hiệu quả','https://example.com/thumbnail14.jpg','Phương pháp học tiếng Anh nhanh chóng','Nội dung chi tiết về cách học tiếng Anh...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(15,'Cách chọn smartphone tốt nhất','https://example.com/thumbnail15.jpg','Hướng dẫn chọn smartphone phù hợp','Nội dung chi tiết về cách chọn smartphone...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(16,'Cách làm salad trộn ngon','https://example.com/thumbnail16.jpg','Công thức làm salad trộn đơn giản','Nội dung chi tiết về cách làm salad...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(17,'Cách chọn đồng hồ phù hợp','https://example.com/thumbnail17.jpg','Hướng dẫn chọn đồng hồ đẹp và chất lượng','Nội dung chi tiết về cách chọn đồng hồ...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(18,'Cách chăm sóc da mặt hiệu quả','https://example.com/thumbnail18.jpg','Bí quyết chăm sóc da mặt đẹp','Nội dung chi tiết về cách chăm sóc da...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(19,'Cách chọn máy ảnh phù hợp','https://example.com/thumbnail19.jpg','Hướng dẫn chọn máy ảnh tốt nhất','Nội dung chi tiết về cách chọn máy ảnh...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(20,'Cách làm bánh mì tại nhà','https://example.com/thumbnail20.jpg','Công thức làm bánh mì đơn giản','Nội dung chi tiết về cách làm bánh mì...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(21,'Cách chọn quần áo phù hợp','https://example.com/thumbnail21.jpg','Hướng dẫn chọn quần áo đẹp và hợp thời trang','Nội dung chi tiết về cách chọn quần áo...',1,10,'2025-01-28 11:33:13','2025-01-27 09:52:00','Active'),(22,'Cách học guitar hiệu quả','https://example.com/thumbnail22.jpg','Phương pháp học guitar nhanh chóng','Nội dung chi tiết về cách học guitar...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(23,'Cách chọn tai nghe tốt nhất','https://example.com/thumbnail23.jpg','Hướng dẫn chọn tai nghe chất lượng','Nội dung chi tiết về cách chọn tai nghe...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(24,'Cách làm bánh pizza tại nhà','https://example.com/thumbnail24.jpg','Công thức làm bánh pizza đơn giản','Nội dung chi tiết về cách làm bánh pizza...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(25,'Cách chọn máy tính bảng phù hợp','https://example.com/thumbnail25.jpg','Hướng dẫn chọn máy tính bảng tốt nhất','Nội dung chi tiết về cách chọn máy tính bảng...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(26,'Cách làm bánh crepe ngon','https://example.com/thumbnail26.jpg','Công thức làm bánh crepe đơn giản','Nội dung chi tiết về cách làm bánh crepe...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(27,'Cách chọn balo phù hợp','https://example.com/thumbnail27.jpg','Hướng dẫn chọn balo chất lượng','Nội dung chi tiết về cách chọn balo...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(28,'Cách chăm sóc tóc hiệu quả','https://example.com/thumbnail28.jpg','Bí quyết chăm sóc tóc đẹp','Nội dung chi tiết về cách chăm sóc tóc...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(29,'Cách chọn máy in phù hợp','https://example.com/thumbnail29.jpg','Hướng dẫn chọn máy in tốt nhất','Nội dung chi tiết về cách chọn máy in...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(30,'Cách làm bánh quy tại nhà','https://example.com/thumbnail30.jpg','Công thức làm bánh quy đơn giản','Nội dung chi tiết về cách làm bánh quy...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(31,'Cách chọn đồ chơi cho trẻ em','https://example.com/thumbnail31.jpg','Hướng dẫn chọn đồ chơi an toàn và phù hợp','Nội dung chi tiết về cách chọn đồ chơi...',1,10,'2025-01-28 11:33:13','2025-01-27 09:52:00','Active'),(32,'Cách học piano hiệu quả','https://example.com/thumbnail32.jpg','Phương pháp học piano nhanh chóng','Nội dung chi tiết về cách học piano...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(33,'Cách chọn loa tốt nhất','https://example.com/thumbnail33.jpg','Hướng dẫn chọn loa chất lượng','Nội dung chi tiết về cách chọn loa...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(34,'Cách làm bánh mì sandwich ngon','https://example.com/thumbnail34.jpg','Công thức làm bánh mì sandwich đơn giản','Nội dung chi tiết về cách làm bánh mì sandwich...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(35,'Cách chọn máy lọc không khí phù hợp','https://example.com/thumbnail35.jpg','Hướng dẫn chọn máy lọc không khí tốt nhất','Nội dung chi tiết về cách chọn máy lọc không khí...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(36,'Cách làm bánh bông lan tại nhà','https://example.com/thumbnail36.jpg','Công thức làm bánh bông lan đơn giản','Nội dung chi tiết về cách làm bánh bông lan...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(37,'Cách chọn vali du lịch phù hợp','https://example.com/thumbnail37.jpg','Hướng dẫn chọn vali du lịch chất lượng','Nội dung chi tiết về cách chọn vali...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(38,'Cách chăm sóc răng miệng hiệu quả','https://example.com/thumbnail38.jpg','Bí quyết chăm sóc răng miệng đẹp','Nội dung chi tiết về cách chăm sóc răng miệng...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(39,'Cách chọn máy chiếu phù hợp','https://example.com/thumbnail39.jpg','Hướng dẫn chọn máy chiếu tốt nhất','Nội dung chi tiết về cách chọn máy chiếu...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(40,'Cách làm bánh tart trứng tại nhà','https://example.com/thumbnail40.jpg','Công thức làm bánh tart trứng đơn giản','Nội dung chi tiết về cách làm bánh tart trứng...',1,10,'2025-01-29 06:54:10','2025-01-27 09:52:00','Active'),(41,'vxcvxcvxc','1738062133193_Screenshot_2024-01-25-14-16-09-153_com.facebook.orca.jpg','Tiểu thương bán cây cảnh tại Công viên Gia Định, TPHCM do phải trả mặt bằng đành vứt bỏ những chậu hoa, cành đào chiều 29 Tết.','<p>czxczxczx</p>',1,10,'2025-01-29 06:54:10','2025-01-28 18:02:13','Active'),(42,'Martial tỏa sáng ở Hy Lạp, tiếp bước McTominay - Greenwood khiến MU tiếc rẻ','1738062216426_Screenshot_2024-01-25-14-16-09-153_com.facebook.orca.jpg','Tương tự những cựu sao MU khác, Anthony Martial tỏa sáng rực rỡ trong màu áo đội bóng Hy Lạp, AEK Athens','<p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\"><strong style=\"margin: 15px 0px; padding: 0px; line-height: 24px; font-family: Roboto-Bold !important;\">Martial tiếp bước&nbsp;McTominay, Greenwood tỏa sáng sau khi rời MU</strong></p><p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\">Mùa giải 2024/25, không ít ngôi sao tỏa sáng rực rỡ sau khi chia tay&nbsp;<a class=\"TextlinkBaiviet\" href=\"https://www.24h.com.vn/manchester-united-c48e1521.html\" title=\"MU\" style=\"margin: 15px 0px; padding: 0px; transition-timing-function: ease; transition-property: all; line-height: 24px; color: rgb(0, 0, 238);\">MU</a>. Có thể kể đến Scott McTominay, người đã đóng góp 5 bàn, 4 kiến tạo để giúp Napoli dẫn đầu Serie A. Trong khi đó, Mason Greenwood cùng CLB Marseille đứng thứ nhì Ligue 1, còn cá nhân tiền đạo này&nbsp;độc chiếm ngôi đầu danh sách Vua phá lưới (12 bàn).</p><p align=\"center\" style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\"></p><div id=\"container-24h-banner-in-image\" style=\"margin: 0px; padding: 0px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-size: 15px; text-align: center; width: 740.017px; clear: both; position: relative;\"><div style=\"margin: 0px auto; padding: 0px; position: relative; max-width: 740px;\"><span style=\"margin: 0px; padding: 0px; aspect-ratio: 740 / 730; display: block;\"><img class=\"news-image loaded\" alt=\"Martial tìm lại phong độ sau khi rời MU\" src=\"https://icdn.24h.com.vn/upload/1-2025/images/2025-01-28/Martial-toa-sang-o-Hy-Lap-Tiep-buoc-McTominay---Greenwood-khien-MU-tiec-re-ebf2c2596fe41c301a961e0937dd6a6c8c93356d0d3f0de9dc-1738048455-215-width740height730.jpg\" data-original=\"https://icdn.24h.com.vn/upload/1-2025/images/2025-01-28/Martial-toa-sang-o-Hy-Lap-Tiep-buoc-McTominay---Greenwood-khien-MU-tiec-re-ebf2c2596fe41c301a961e0937dd6a6c8c93356d0d3f0de9dc-1738048455-215-width740height730.jpg\" data-was-processed=\"true\" style=\"margin: 0px auto; padding: 0px; transition-duration: 2s; transition-timing-function: ease-in; transition-property: all; display: block; height: auto; cursor: pointer;\"></span><div id=\"24h-banner-in-image\" style=\"margin: 0px; padding: 0px; left: 369.994px; transform: translateX(-50%); position: absolute; height: 90px; color: white; bottom: 0px;\"><div id=\"ADS_139_15s\" class=\"txtCent  \" style=\"margin: 0px; padding: 0px;\"><div class=\"text_adver_right\" style=\"margin: 0px; padding: 0px;\"></div><span name=\"ADS_139_15s_0\" id=\"ADS_139_15s_0\" class=\"m_banner_show\" bgcolor=\"#FFFCDA\" align=\"center\" valign=\"top\" style=\"margin: 0px auto; padding: 0px; display: block; width: 660px;\"></span></div></div></div></div><p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\"></p><p class=\"img_chu_thich_0407\" style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-style: italic; text-align: center; font-family: Roboto-Regular, sans-serif; font-weight: 400;\">Martial tìm lại phong độ sau khi rời MU</p><p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\">Một cái tên đáng chú ý khác là Anthony Martial. Hè&nbsp;2024, Martial&nbsp;chia tay&nbsp;<a href=\"https://www.24h.com.vn/manchester-united-c48e1521.html\" style=\"margin: 15px 0px; padding: 0px; transition-timing-function: ease; transition-property: all; line-height: 24px; color: rgb(0, 0, 238);\">MU</a>&nbsp;và gia nhập&nbsp;AEK Athens dưới dạng chuyển nhượng tự do. Theo giới truyền thông, AEK Athens đưa ra lời đề nghị cực hấp dẫn dành&nbsp;cho tiền đạo 29 tuổi, thậm chí đây là bản hợp đồng lớn nhất mà đội bóng Hy Lạp&nbsp;từng trao cho một cầu thủ&nbsp;trong lịch sử 100 năm hoạt động.</p><p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\">Không phụ sự kỳ vọng từ&nbsp;AEK Athens, Martial đang thể hiện phong độ cao khi&nbsp;đóng góp 5 pha lập công trong 13 lần ra sân ở giải VĐQG Hy Lạp. Hôm 26/1, anh ghi bàn duy nhất giúp đội bóng chủ quản&nbsp;thắng Panetolikos 1-0, đồng thời&nbsp;vươn lên vị trí nhì bảng.</p><p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\"><strong style=\"margin: 15px 0px; padding: 0px; line-height: 24px; font-family: Roboto-Bold !important;\">Martial \"lột xác\"</strong></p><p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\">Từ khi gia nhập AEK Athens, Martial chơi 17 trận trên mọi đấu trường với tổng số phút là 1.195 (7 bàn, 2 kiến tạo),&nbsp;bao gồm&nbsp;10 trận đá trọn vẹn. Trước đó,&nbsp;anh dính 23 chấn thương khác nhau&nbsp;trong 9 năm khoác áo MU,&nbsp;nghỉ thi đấu 451 ngày và&nbsp;bỏ lỡ 108 trận. Mùa giải cuối cùng khoác áo \"Quỷ đỏ\" (2023/24), cầu thủ sinh năm 1995 chỉ ra sân&nbsp;19 lần (629&nbsp;phút).</p><p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\">Năm 2015, Martial gia nhập MU từ Monaco ở&nbsp;tuổi 19 với mức phí chuyển nhượng 44,5 triệu bảng, trở thành cầu thủ tuổi \"teen\" đắt giá nhất thế giới thời điểm đó. Thành công lập tức đến với tiền đạo người Pháp khi anh&nbsp;giành danh hiệu \"Golden Boy\", giải thưởng danh giá dành cho cầu thủ U21 xuất sắc nhất thế giới.</p><p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\">Thậm chí trong hợp đồng chiêu mộ Martial,&nbsp;MU đã đồng ý cài điều khoản trả thêm&nbsp;7,2 triệu bảng cho Monaco nếu anh đoạt Quả bóng vàng trước tháng 6/2019.</p><p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\">Tuy nhiên suốt quãng thời gian khoác áo đội chủ sân&nbsp;<a href=\"https://www.24h.com.vn/manchester-united-c48e1521.html\" style=\"margin: 15px 0px; padding: 0px; transition-timing-function: ease; transition-property: all; line-height: 24px; color: rgb(0, 0, 238);\">Old Trafford</a>, Martial chỉ đóng góp&nbsp;90 bàn trong 317 lần ra sân trên mọi đấu trường, bất chấp&nbsp;nhận&nbsp;mức lương \"khủng\" 250.000 bảng/tuần.</p>',1,10,'2025-01-29 06:54:10','2025-01-28 18:03:36','Active'),(43,'Ông Trump chỉ đạo khẩn cấp cứu hộ vụ tai nạn khủng khiếp máy bay rơi xuống sông','1738235085578_Screenshot_2024-01-25-14-16-09-153_com.facebook.orca.jpg','Mỹ đang ráo riết cứu hộ một máy bay rơi do va chạm với trực thăng Sikorsky H-60 Blackhawk (Diều hâu đen) của quân đội Mỹ và rơi xuống sông. ','<p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\">Ngày 29-1, Cục Hàng không Liên bang Mỹ cho biết một máy bay chở khách Bombardier CRJ700 của hãng hàng không American Airlines đã va chạm trên không với trực thăng quân sự Sikorsky H-60 khi đang hạ cánh xuống sân bay quốc gia Ronald Reagan Washington vào khoảng 9 giờ tối (giờ địa phương) và rơi xuống sông Potomac, theo tờ The Wall Street Journal.</p><p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\">Hãng hàng không American Airlines nói với đài CNN rằng có 60 hành khách và 4 thành viên phi hành đoàn trên chuyến bay mang số hiệu 5342, khởi hành từ TP Wichita, bang Kansas (Mỹ).</p><p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\">CNN dẫn lời hai quan chức quốc phòng Mỹ rằng một chiếc trực thăng Sikorsky H-60 Blackhawk (Diều hâu đen) của quân đội Mỹ đã va chạm với chiếc máy bay chở khách nói trên.</p><p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\">Tờ The New York Times dẫn lời các nguồn tin chức quân đội Mỹ cho biết có 3 phi hành đoàn trên trực thăng và không có quan chức cấp cao nào của lực lượng này ở trên trực thăng.</p><p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\">Theo đài CNN, các quan chức cấp cao quân đội Mỹ thường sử dụng trực thăng Black Hawk để di chuyển trong khu vực Washington D.C.</p><p align=\"center\" style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\"><img class=\"news-image initial loaded\" alt=\"Một đội cứu hộ của cảnh sát lái xe đến sông Potomac gần sân bay quốc gia Ronald Reagan Washington. Ảnh: CNN\" src=\"https://cdn.24h.com.vn/upload/1-2025/images/2025-01-30/1738217914-may-bay-roi-do-va-truc-thang-dieu-hau-den-cua-quan-doi-my-4107-3549-widthheight.webp\" data-original=\"https://cdn.24h.com.vn/upload/1-2025/images/2025-01-30/1738217914-may-bay-roi-do-va-truc-thang-dieu-hau-den-cua-quan-doi-my-4107-3549-widthheight.webp\" width=\"740\" data-was-processed=\"true\" style=\"margin: 0px auto; padding: 0px; transition-duration: 2s; transition-timing-function: ease-in; transition-property: all; line-height: 24px; display: block; height: auto; cursor: pointer;\"></p><p class=\"img_chu_thich_0407\" style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-style: italic; text-align: center; font-family: Roboto-Regular, sans-serif; font-weight: 400;\">Một đội cứu hộ của cảnh sát lái xe đến sông Potomac gần sân bay quốc gia Ronald Reagan Washington. Ảnh: CNN</p><p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\">Gần như mọi cơ quan thực thi pháp luật trong khu vực đều đang nỗ lực tìm kiếm và cứu nạn sau vụ va chạm máy bay và các đội cứu hộ đang cật lực tìm kiếm những nạn nhân trong vụ tai nạn, một nguồn tin thực thi pháp luật nói với CNN.</p><p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\">Phóng viên The New York Times cho biết có thể thấy chính quyền đang nỗ lực rất lớn trong việc cứu hộ cứu nạn ở bờ đông sông khi trực thăng quần thảo bầu trời đêm và tiếng còi báo động vang lên liên tục.</p><p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\">Theo CNN, hàng chục lính cứu hỏa đang làm nhiệm vụ lặn để cứu hộ cứu nạn trên sông Potomac.</p><p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\">Tổng thống Mỹ <a class=\"TextlinkBaiviet\" href=\"https://www.24h.com.vn/donald-trump-c415e4024.html\" title=\"Donald Trump\" style=\"margin: 15px 0px; padding: 0px; transition-timing-function: ease; transition-property: all; line-height: 24px; color: rgb(0, 0, 238);\">Donald Trump</a> nói rằng ông “đã được thông báo đầy đủ về vụ tai nạn khủng khiếp vừa xảy ra tại sân bay quốc gia Reagan”.</p><p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\">Ông Trump cũng cảm ơn lực lượng ứng cứu khẩn cấp đã nhanh chóng đến làm việc tại hiện trường.</p><p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\">“Tôi đang theo dõi tình hình và sẽ cung cấp thêm chi tiết khi có thông tin mới” - ông Trump cho hay.</p><p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\">Chủ tịch Hạ viện Mỹ Mike Johnson rằng ông \"vô cùng đau buồn\" khi máy bay chở khách va chạm giữa không trung với một chiếc trực thăng Black Hawk của quân đội Mỹ.</p><p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\">Tân Bộ trưởng Giao thông vận tải Mỹ Sean Duffy cho biết ông đang theo dõi những diễn biến liên quan đến vụ máy bay rơi trên sông Potomac.</p><p align=\"center\" style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\"><img class=\"news-image loaded\" alt=\"Một chiếc xe cảnh sát chạy qua Sân bay quốc gia Reagan Washington. Ảnh: CNN\" src=\"https://cdn.24h.com.vn/upload/1-2025/images/2025-01-30/1738217914-2025-01-30tz-711-rc2-2896-9851-widthheight.webp\" data-original=\"https://cdn.24h.com.vn/upload/1-2025/images/2025-01-30/1738217914-2025-01-30tz-711-rc2-2896-9851-widthheight.webp\" width=\"740\" data-was-processed=\"true\" style=\"margin: 0px auto; padding: 0px; transition-duration: 2s; transition-timing-function: ease-in; transition-property: all; line-height: 24px; display: block; height: auto; cursor: pointer;\"></p><p class=\"img_chu_thich_0407\" style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-style: italic; text-align: center; font-family: Roboto-Regular, sans-serif; font-weight: 400;\">Một chiếc xe cảnh sát chạy qua Sân bay quốc gia Reagan Washington. Ảnh: CNN</p><p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\">Theo tờ The New York Times, bất kỳ người nào sống sót trên chuyến bay nhưng bị ngâm trong nước đều có thể gặp nguy hiểm trong bối cảnh Cơ quan thời tiết quốc gia cho biết nhiệt độ dự kiến ​​sẽ giảm xuống dưới mức đóng băng ở khu vực Washington vào đêm 29-1. Theo đó, tình trạng hạ thân nhiệt có thể xảy ra trong vòng 20-30 phút trong nước lạnh.</p><p style=\"margin-top: 15px; margin-right: 0px; margin-left: 0px; padding: 0px; font-size: 15px; line-height: 24px; color: rgb(37, 37, 37); font-family: Roboto-Regular, sans-serif; font-weight: 400;\">Thượng nghị sĩ bang Texas - ông Ted Cruz viết trên mạng xã hội X rằng mọi người biết rằng đã có người thiệt mạng và xin mọi người cầu nguyện cho những người liên quan trong khi công tác tìm kiếm và cứu nạn đang được tiến hành.</p>',1,8,'2025-01-30 18:04:46','2025-01-28 18:04:55','Active');
/*!40000 ALTER TABLE `blog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blog_category`
--

DROP TABLE IF EXISTS `blog_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blog_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_category_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog_category`
--

LOCK TABLES `blog_category` WRITE;
/*!40000 ALTER TABLE `blog_category` DISABLE KEYS */;
INSERT INTO `blog_category` VALUES (1,'Technology','Articles about the latest technology trends and innovations.','2025-01-27 09:43:49','2025-01-27 09:43:49'),(2,'Health','Tips and information about health, wellness, and fitness.','2025-01-27 09:43:49','2025-01-27 09:43:49'),(3,'Travel','Guides and experiences for travel enthusiasts.','2025-01-27 09:43:49','2025-01-27 09:43:49'),(4,'Education','Resources and articles to support lifelong learning.','2025-01-27 09:43:49','2025-01-27 09:43:49'),(5,'Lifestyle','Topics about everyday lifestyle, hobbies, and interests.','2025-01-27 09:43:49','2025-01-27 09:43:49'),(6,'Finance','Insights and advice on personal finance and investments.','2025-01-27 09:43:49','2025-01-27 09:43:49'),(7,'Food','Delicious recipes, reviews, and food-related content.','2025-01-27 09:43:49','2025-01-27 09:43:49'),(8,'Sports','Coverage and analysis of various sports events.','2025-01-27 09:43:49','2025-01-27 09:43:49'),(9,'Entertainment','Updates on movies, music, and pop culture.','2025-01-27 09:43:49','2025-01-27 09:43:49'),(10,'Business','Articles about entrepreneurship, startups, and business strategies.','2025-01-27 09:43:49','2025-01-27 09:43:49'),(11,'Fashion','Trends, tips, and advice about fashion and styling.','2025-01-27 09:43:49','2025-01-27 09:43:49'),(12,'Gaming','Latest news and reviews in the gaming industry.','2025-01-27 09:43:49','2025-01-27 09:43:49'),(13,'Science','Exploring the latest scientific discoveries and innovations.','2025-01-27 09:43:49','2025-01-27 09:43:49'),(14,'Environment','Content about sustainability and environmental awareness.','2025-01-27 09:43:49','2025-01-27 09:43:49'),(15,'Parenting','Advice and resources for parents and caregivers.','2025-01-27 09:43:49','2025-01-27 09:43:49');
/*!40000 ALTER TABLE `blog_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (6,'Art'),(10,'Business'),(9,'Health'),(5,'History'),(4,'Literature'),(3,'Mathematics'),(7,'Music'),(2,'Science'),(8,'Sports'),(1,'Technology');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course`
--

DROP TABLE IF EXISTS `course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'Tên khóa học',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Mô tả khóa học',
  `thumbnail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Đường dẫn ảnh thumbnail',
  `rating` int NOT NULL DEFAULT '0' COMMENT 'Đánh giá từ 0 đến 5 sao',
  `price` float NOT NULL COMMENT 'Giá tiền (không âm)',
  `status` enum('active','inactive','draft') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft' COMMENT 'Trạng thái khóa học',
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Ngày tạo',
  `modified_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Ngày sửa đổi',
  `created_by` int NOT NULL COMMENT 'Người tạo (tham chiếu đến bảng account)',
  `category_id` int NOT NULL COMMENT 'Danh mục (tham chiếu đến bảng category)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  KEY `course_created_by_reference_account_id_idx` (`created_by`),
  KEY `course_category_id_reference_category_id_idx` (`category_id`),
  CONSTRAINT `course_category_id_reference_category_id` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`),
  CONSTRAINT `course_created_by_reference_account_id` FOREIGN KEY (`created_by`) REFERENCES `account` (`id`),
  CONSTRAINT `course_chk_1` CHECK ((`rating` between 0 and 5)),
  CONSTRAINT `course_chk_2` CHECK ((`price` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course`
--

LOCK TABLES `course` WRITE;
/*!40000 ALTER TABLE `course` DISABLE KEYS */;
INSERT INTO `course` VALUES (1,'Introduction to Programming','Learn the basics of programming.','thumbnail1.jpg',4,49.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,8),(2,'Advanced Mathematics','Deep dive into advanced math topics.','thumbnail2.jpg',5,59.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,4),(3,'History of Art','Explore the history of art through the ages.','thumbnail3.jpg',3,39.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,7),(4,'Music Theory','Understand the fundamentals of music.','thumbnail4.jpg',4,44.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,9),(5,'Sports Science','Study the science behind sports.','thumbnail5.jpg',5,54.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,7),(6,'Business Fundamentals','Learn the basics of business.','thumbnail6.jpg',4,49.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,6),(7,'Health and Wellness','Improve your health and wellness.','thumbnail7.jpg',3,34.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,10),(8,'Literature Appreciation','Appreciate classic and modern literature.','thumbnail8.jpg',4,44.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,9),(9,'Environmental Science','Study the environment and sustainability.','thumbnail9.jpg',5,59.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,4),(10,'Digital Marketing','Learn the essentials of digital marketing.','thumbnail10.jpg',4,49.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,4),(11,'Artificial Intelligence','Introduction to AI and machine learning.','thumbnail11.jpg',5,69.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,8),(12,'Web Development','Build websites from scratch.','thumbnail12.jpg',4,54.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,9),(13,'Data Science','Learn data analysis and visualization.','thumbnail13.jpg',5,64.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,9),(14,'Graphic Design','Master the art of graphic design.','thumbnail14.jpg',4,49.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,8),(15,'Photography Basics','Learn the basics of photography.','thumbnail15.jpg',3,39.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,4),(16,'Public Speaking','Improve your public speaking skills.','thumbnail16.jpg',4,44.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,5),(17,'Financial Planning','Plan your finances effectively.','thumbnail17.jpg',5,59.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,10),(18,'Creative Writing','Unleash your creativity through writing.','thumbnail18.jpg',4,49.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,6),(19,'Mobile App Development','Build mobile apps for iOS and Android.','thumbnail19.jpg',5,69.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,10),(20,'Cybersecurity Basics','Learn the fundamentals of cybersecurity.','thumbnail20.jpg',4,54.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,1),(21,'Yoga and Meditation','Improve your mental and physical health.','thumbnail21.jpg',3,34.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,5),(22,'Blockchain Technology','Understand blockchain and cryptocurrencies.','thumbnail22.jpg',5,64.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,10),(23,'Game Development','Create your own video games.','thumbnail23.jpg',4,59.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,6),(24,'Nutrition and Diet','Learn about healthy eating habits.','thumbnail24.jpg',4,44.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,10),(25,'Machine Learning','Introduction to machine learning concepts.','thumbnail25.jpg',5,69.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,1),(26,'UI/UX Design','Design user-friendly interfaces.','thumbnail26.jpg',4,54.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,3),(27,'Cloud Computing','Learn about cloud services and infrastructure.','thumbnail27.jpg',5,64.99,'active','2025-01-25 10:53:04','2025-01-25 10:53:04',9,1),(28,'Python Programming','Learn Python from scratch.','thumbnail28.jpg',4,49.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,5),(29,'JavaScript Essentials','Master the basics of JavaScript.','thumbnail29.jpg',5,59.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,4),(30,'React.js for Beginners','Build web apps with React.js.','thumbnail30.jpg',4,54.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,4),(31,'Node.js Fundamentals','Learn backend development with Node.js.','thumbnail31.jpg',5,64.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,5),(32,'Database Design','Design and optimize databases.','thumbnail32.jpg',4,49.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,4),(33,'DevOps Basics','Introduction to DevOps practices.','thumbnail33.jpg',5,69.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,5),(34,'Kubernetes for Beginners','Learn container orchestration with Kubernetes.','thumbnail34.jpg',4,59.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,3),(35,'Docker Essentials','Master Docker for containerization.','thumbnail35.jpg',5,64.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,7),(36,'AWS Cloud Practitioner','Learn AWS cloud fundamentals.','thumbnail36.jpg',4,54.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,7),(37,'Azure Fundamentals','Get started with Microsoft Azure.','thumbnail37.jpg',5,69.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,3),(38,'Google Cloud Basics','Learn Google Cloud Platform essentials.','thumbnail38.jpg',4,59.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,4),(39,'Ethical Hacking','Learn the basics of ethical hacking.','thumbnail39.jpg',5,74.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,10),(40,'Penetration Testing','Master penetration testing techniques.','thumbnail40.jpg',4,64.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,7),(41,'Network Security','Secure your networks effectively.','thumbnail41.jpg',5,69.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,6),(42,'Linux Administration','Learn Linux system administration.','thumbnail42.jpg',4,54.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,9),(43,'Shell Scripting','Automate tasks with shell scripts.','thumbnail43.jpg',5,59.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,7),(44,'Agile Methodology','Master Agile project management.','thumbnail44.jpg',4,49.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,6),(45,'Scrum Framework','Learn Scrum for agile development.','thumbnail45.jpg',5,59.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,9),(46,'Product Management','Become a successful product manager.','thumbnail46.jpg',4,54.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,8),(47,'Leadership Skills','Develop leadership and management skills.','thumbnail47.jpg',5,64.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,10),(48,'Time Management','Learn to manage your time effectively.','thumbnail48.jpg',4,44.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,7),(49,'Emotional Intelligence','Improve your emotional intelligence.','thumbnail49.jpg',5,54.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,6),(50,'Critical Thinking','Develop critical thinking skills.','thumbnail50.jpg',4,49.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,7),(51,'Creative Problem Solving','Solve problems creatively.','thumbnail51.jpg',5,59.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,7),(52,'Entrepreneurship','Start and grow your own business.','thumbnail52.jpg',4,54.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,1),(53,'Digital Transformation','Understand digital transformation strategies.','thumbnail53.jpg',5,64.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,6),(54,'Blockchain Development','Build blockchain applications.','thumbnail54.jpg',4,69.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,7),(55,'Smart Contracts','Learn to create smart contracts.','thumbnail55.jpg',5,74.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,4),(56,'Cryptocurrency Basics','Understand cryptocurrencies and their use.','thumbnail56.jpg',4,59.99,'active','2025-01-25 10:53:12','2025-01-25 10:53:12',9,10),(57,'AI Ethics','Explore ethical considerations in AI.','thumbnail57.jpg',5,64.99,'active','2025-01-25 10:53:13','2025-01-25 10:53:13',9,7);
/*!40000 ALTER TABLE `course` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feature`
--

DROP TABLE IF EXISTS `feature`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feature` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_UNIQUE` (`code`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feature`
--

LOCK TABLES `feature` WRITE;
/*!40000 ALTER TABLE `feature` DISABLE KEYS */;
/*!40000 ALTER TABLE `feature` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feature_role`
--

DROP TABLE IF EXISTS `feature_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feature_role` (
  `feature_id` int NOT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`feature_id`,`role_id`),
  KEY `Feature_Role_Reference_Role_idx` (`role_id`),
  CONSTRAINT `Feature_Role_Reference_Feature` FOREIGN KEY (`feature_id`) REFERENCES `feature` (`id`),
  CONSTRAINT `Feature_Role_Reference_Role` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feature_role`
--

LOCK TABLES `feature_role` WRITE;
/*!40000 ALTER TABLE `feature_role` DISABLE KEYS */;
/*!40000 ALTER TABLE `feature_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `registration`
--

DROP TABLE IF EXISTS `registration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `registration` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `account_id` int DEFAULT NULL COMMENT 'Link to account table if registered user',
  `registration_time` date NOT NULL,
  `category_id` int NOT NULL COMMENT 'Reference to course category',
  `package` enum('Basic','Standard','Premium') NOT NULL DEFAULT 'Standard',
  `total_cost` decimal(20,2) NOT NULL,
  `status` enum('Active','Inactive') NOT NULL DEFAULT 'Active',
  `valid_from` timestamp NOT NULL,
  `valid_to` timestamp NOT NULL,
  `last_updated_by` int NOT NULL COMMENT 'Reference to account who last updated',
  PRIMARY KEY (`id`),
  KEY `registration_account_id_fk` (`account_id`),
  KEY `registration_category_id_fk` (`category_id`),
  KEY `registration_updated_by_fk` (`last_updated_by`),
  CONSTRAINT `registration_account_id_fk` FOREIGN KEY (`account_id`) REFERENCES `account` (`id`) ON DELETE SET NULL,
  CONSTRAINT `registration_category_id_fk` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`),
  CONSTRAINT `registration_updated_by_fk` FOREIGN KEY (`last_updated_by`) REFERENCES `account` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registration`
--

LOCK TABLES `registration` WRITE;
/*!40000 ALTER TABLE `registration` DISABLE KEYS */;
/*!40000 ALTER TABLE `registration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'admin'),(2,'teacher'),(3,'student'),(4,'marketing');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `setting`
--

DROP TABLE IF EXISTS `setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `setting` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `order` int NOT NULL DEFAULT '0',
  `status` enum('Active','Inactive') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_type_value` (`type`,`value`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `setting`
--

LOCK TABLES `setting` WRITE;
/*!40000 ALTER TABLE `setting` DISABLE KEYS */;
INSERT INTO `setting` VALUES (1,'System','Enable Debug Mode',1,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(2,'System','Maintenance Mode',2,'Inactive','2025-01-26 09:06:53','2025-01-26 09:06:53'),(3,'User','Maximum Login Attempts = 5',3,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(4,'User','Session Timeout = 30 mins',4,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(5,'Payment','Currency = USD',5,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(6,'Payment','Allow Refunds = True',6,'Inactive','2025-01-26 09:06:53','2025-01-26 09:06:53'),(7,'System','Logging Level = DEBUG',7,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(8,'System','API Rate Limit = 100 requests/min',8,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(9,'User','Password Length = 8 characters',9,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(10,'User','Allow Multiple Sessions = False',10,'Inactive','2025-01-26 09:06:53','2025-01-26 09:06:53'),(11,'Payment','Tax Rate = 10%',11,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(12,'System','Enable Audit Logs',12,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(13,'System','Server Region = US-East',13,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(14,'User','Enable Two-Factor Authentication',14,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(15,'Payment','Payment Gateway = Stripe',15,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(16,'Payment','Enable Auto Renewals',16,'Inactive','2025-01-26 09:06:53','2025-01-26 09:06:53'),(17,'System','Cache Expiry = 60 mins',17,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(18,'System','Enable Data Backup',18,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(19,'User','Max Devices Per Account = 3',19,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(20,'User','Account Lock Duration = 15 mins',20,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(21,'Payment','Discount Limit = 20%',21,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(22,'System','Auto Update Enabled',22,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(23,'System','Default Language = English',23,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(24,'User','Email Verification Required',24,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(25,'Payment','Default Payment Method = Credit Card',25,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(26,'Payment','Late Fee = $5',26,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(27,'System','Session Logs Retention = 90 days',27,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(28,'User','Timezone = UTC',28,'Active','2025-01-26 09:06:53','2025-01-26 09:50:09'),(29,'User','Enable Notifications',29,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(30,'User','Login Tracking Enabled',30,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(31,'Payment','Maximum Transaction = $10,000',31,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(32,'System','Allow Cross-Origin Requests',32,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(33,'System','Data Encryption = AES-256',33,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(34,'User','Account Recovery Enabled',34,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(35,'User','Maximum File Upload = 50MB',35,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(36,'Payment','Invoice Reminder = 5 days',36,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(37,'Payment','Enable Subscription Cancellation',37,'Inactive','2025-01-26 09:06:53','2025-01-26 09:06:53'),(38,'System','Error Reporting Level = High',38,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(39,'System','Enable Email Alerts',39,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(40,'User','Allow Username Change = Once',40,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(41,'User','Enable Dark Mode',41,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(42,'Payment','Invoice Format = PDF',42,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(43,'System','Force Password Reset = Yearly',43,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(44,'System','Enable API Access Logs',44,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(45,'User','Enable Profile Picture Upload',45,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(46,'User','Enable Account Deletion',46,'Inactive','2025-01-26 09:06:53','2025-01-26 09:06:53'),(47,'Payment','Transaction Currency = USD',47,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(48,'Payment','Default Billing Cycle = Monthly',48,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(49,'System','Enable Firewall',49,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53'),(50,'System','Server Backup Frequency = Weekly',50,'Active','2025-01-26 09:06:53','2025-01-26 09:06:53');
/*!40000 ALTER TABLE `setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `slider`
--

DROP TABLE IF EXISTS `slider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `slider` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `image_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `backlink` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `status` enum('active','inactive') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `slider_created_by_reference_account_id_idx` (`created_by`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `slider`
--

LOCK TABLES `slider` WRITE;
/*!40000 ALTER TABLE `slider` DISABLE KEYS */;
INSERT INTO `slider` VALUES (1,'Christmas Deals 1','https://example.com/images/slider_1.jpg','https://example.com/promo/1','inactive','Notes for slider 1',8,'2024-08-04 09:43:59','2025-02-02 19:51:08'),(2,'Halloween Offers 2','https://example.com/images/slider_2.jpg','https://example.com/promo/2','inactive',NULL,4,'2024-08-26 09:43:59','2024-08-30 09:43:59'),(3,'Halloween Offers 3','assets/img/slider/1738501990289_462858233_1262397805206362_4262707114173487608_n.jpg','http://localhost:9998/SWP391_OCMS/manage-slider?action=edit&id=3','active','Notes for slider 3',3,'2024-11-12 09:43:59','2025-02-02 20:13:10'),(4,'Christmas Deals 4','https://example.com/images/slider_4.jpg','https://example.com/promo/4','inactive',NULL,2,'2024-07-20 09:43:59','2024-08-03 09:43:59'),(5,'Halloween Offers 5','https://example.com/images/slider_5.jpg','https://example.com/promo/5','inactive','Notes for slider 5',5,'2024-08-25 09:43:59','2024-08-25 09:43:59'),(6,'Black Friday 6','https://example.com/images/slider_6.jpg','https://example.com/promo/6','inactive','Notes for slider 6',7,'2024-06-15 09:43:59','2025-02-02 19:59:05'),(7,'Cyber Monday 7','https://example.com/images/slider_7.jpg','https://example.com/promo/7','active',NULL,1,'2024-05-10 09:43:59','2024-06-20 09:43:59'),(8,'Easter Special 8','https://example.com/images/slider_8.jpg','https://example.com/promo/8','active','Notes for slider 8',9,'2024-03-18 09:43:59','2024-03-30 09:43:59'),(9,'New Year Promotion 9','https://example.com/images/slider_9.jpg','https://example.com/promo/9','inactive',NULL,6,'2024-02-11 09:43:59','2024-02-25 09:43:59'),(10,'Valentine\'s Day Sale 10','https://example.com/images/slider_10.jpg','https://example.com/promo/10','active','Notes for slider 10',5,'2024-01-05 09:43:59','2024-01-20 09:43:59'),(11,'Summer Sale 11','https://example.com/images/slider_11.jpg','https://example.com/promo/11','inactive',NULL,8,'2024-07-25 09:43:59','2025-02-02 19:51:16'),(12,'Winter Discounts 12','https://example.com/images/slider_12.jpg','https://example.com/promo/12','inactive','Notes for slider 12',3,'2024-09-05 09:43:59','2024-09-25 09:43:59'),(13,'Back to School 13','https://example.com/images/slider_13.jpg','https://example.com/promo/13','active',NULL,7,'2024-06-08 09:43:59','2024-06-20 09:43:59'),(14,'Cyber Monday 14','https://example.com/images/slider_14.jpg','https://example.com/promo/14','inactive','Notes for slider 14',2,'2024-03-20 09:43:59','2024-04-01 09:43:59'),(15,'Easter Special 15','https://example.com/images/slider_15.jpg','https://example.com/promo/15','active',NULL,1,'2024-02-25 09:43:59','2024-03-05 09:43:59'),(16,'New Year Promotion 16','https://example.com/images/slider_16.jpg','https://example.com/promo/16','inactive','Notes for slider 16',9,'2024-01-15 09:43:59','2024-01-30 09:43:59'),(17,'Valentine\'s Day Sale 17','https://example.com/images/slider_17.jpg','https://example.com/promo/17','inactive',NULL,10,'2024-07-10 09:43:59','2025-02-02 19:58:17'),(18,'Summer Sale 18','https://example.com/images/slider_18.jpg','https://example.com/promo/18','inactive','Notes for slider 18',6,'2024-05-12 09:43:59','2024-05-25 09:43:59'),(19,'Winter Discounts 19','https://example.com/images/slider_19.jpg','https://example.com/promo/19','active',NULL,5,'2024-04-08 09:43:59','2024-04-22 09:43:59'),(20,'Back to School 20','https://example.com/images/slider_20.jpg','https://example.com/promo/20','inactive','Notes for slider 20',8,'2024-02-17 09:43:59','2024-02-28 09:43:59'),(21,'vcxvxc','assets/img/slider/1738502491492_462858233_1262397805206362_4262707114173487608_n.jpg','http://localhost:9998/SWP391_OCMS/manage-slider?action=add','active','vxcvxcvxc',8,'2025-02-02 20:21:32','2025-02-02 20:21:32');
/*!40000 ALTER TABLE `slider` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-05 16:50:10
