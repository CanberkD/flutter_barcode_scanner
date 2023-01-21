-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 21, 2023 at 04:37 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `flutter_test`
--

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `orderBarcode` varchar(12) NOT NULL,
  `productBarcode` varchar(12) NOT NULL,
  `piece` int(11) NOT NULL,
  `sum` double NOT NULL,
  `imgUrl` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `orderBarcode`, `productBarcode`, `piece`, `sum`, `imgUrl`) VALUES
(5, '494839561052', '020357122682', 1, 65.95, 'https://productimages.hepsiburada.net/s/33/375/10392107974706.jpg'),
(6, '770271560780', '020357122682', 10, 659, 'https://productimages.hepsiburada.net/s/33/375/10392107974706.jpg'),
(8, '770271560780', '116200450399', 1, 790, 'https://sarar.com/sarar-premium-roberto-gri-ceket-6872-slim-fit-ceket-sarar-premium-9844-68-B.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `barcode` varchar(16) NOT NULL,
  `name` varchar(24) NOT NULL,
  `manufacturer` varchar(24) NOT NULL,
  `stock` int(11) NOT NULL,
  `price` double NOT NULL,
  `imgUrl` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`barcode`, `name`, `manufacturer`, `stock`, `price`, `imgUrl`) VALUES
('020357122682', 'Ugreen Type-c Şarj Kablo', 'Ugreen', 230, 65.95, 'https://productimages.hepsiburada.net/s/33/375/10392107974706.jpg'),
('076950450479', 'Saka Su 5lt', 'Saka ', 40, 12, 'https://productimages.hepsiburada.net/s/260/375/110000243972320.jpg'),
('116200450399', 'Ceket', 'Defacto', 40, 790, 'https://sarar.com/sarar-premium-roberto-gri-ceket-6872-slim-fit-ceket-sarar-premium-9844-68-B.jpg'),
('9771234567003', 'Erikli Su 5 lt', 'Eirkli', 1000, 18.5, '//url');

-- --------------------------------------------------------

--
-- Table structure for table `t_order`
--

CREATE TABLE `t_order` (
  `id` int(11) NOT NULL,
  `order_barcode` varchar(13) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `t_order`
--

INSERT INTO `t_order` (`id`, `order_barcode`) VALUES
(16, '494839561052'),
(17, '7702715607805'),
(18, '2022101426445');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`barcode`);

--
-- Indexes for table `t_order`
--
ALTER TABLE `t_order`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `t_order`
--
ALTER TABLE `t_order`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
