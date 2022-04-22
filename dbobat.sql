-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 22, 2022 at 06:59 PM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 8.0.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dbobat`
--
CREATE DATABASE IF NOT EXISTS `dbobat` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `dbobat`;

DELIMITER $$
--
-- Functions
--
DROP FUNCTION IF EXISTS `updateStock`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `updateStock` (`n1` INTEGER, `n2` INTEGER, `n3` INTEGER) RETURNS INT(11) BEGIN
    if n3 = 1 then
        return n1 + n2;
    else
        return n1 - n2;
    end if;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `obat`
--

DROP TABLE IF EXISTS `obat`;
CREATE TABLE IF NOT EXISTS `obat` (
  `id_obat` varchar(10) NOT NULL,
  `nama_obat` varchar(20) NOT NULL,
  `stock` int(11) NOT NULL,
  PRIMARY KEY (`id_obat`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `obat_keluar`
--

DROP TABLE IF EXISTS `obat_keluar`;
CREATE TABLE IF NOT EXISTS `obat_keluar` (
  `id_ok` varchar(10) NOT NULL,
  `id_obat` varchar(10) NOT NULL,
  `tanggal_keluar` date NOT NULL,
  `jumlah` int(11) NOT NULL,
  PRIMARY KEY (`id_ok`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `obat_keluar`
--
DROP TRIGGER IF EXISTS `KurangStok`;
DELIMITER $$
CREATE TRIGGER `KurangStok` AFTER INSERT ON `obat_keluar` FOR EACH ROW BEGIN
	
    UPDATE obat SET stock = stock - NEW.jumlah
    WHERE id_obat = NEW.id_obat;   
 
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `obat_masuk`
--

DROP TABLE IF EXISTS `obat_masuk`;
CREATE TABLE IF NOT EXISTS `obat_masuk` (
  `id_om` varchar(10) NOT NULL,
  `id_obat` varchar(10) NOT NULL,
  `tanggal_masuk` date NOT NULL,
  `jumlah` int(11) NOT NULL,
  PRIMARY KEY (`id_om`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `obat_masuk`
--
DROP TRIGGER IF EXISTS `TambahStok`;
DELIMITER $$
CREATE TRIGGER `TambahStok` BEFORE INSERT ON `obat_masuk` FOR EACH ROW BEGIN

	UPDATE obat SET stock = updateStock(stock, NEW.jumlah, 1)
    WHERE id_obat = NEW.id_obat;

END
$$
DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
