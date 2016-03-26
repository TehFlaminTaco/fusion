-- phpMyAdmin SQL Dump
-- version 4.4.12
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 22, 2016 at 05:35 PM
-- Server version: 5.6.25
-- PHP Version: 5.6.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fusion`
--

-- --------------------------------------------------------

--
-- Table structure for table `fusion_bans`
--

CREATE TABLE IF NOT EXISTS `fusion_bans` (
  `ID` varchar(20) NOT NULL PRIMARY KEY,
  `Name` text,
  `Banner` text,
  `Description` text,
  `Unban` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `ID` varchar(64) NOT NULL PRIMARY KEY,
  `name` varchar(64) DEFAULT NULL,
  `rank` varchar(64) DEFAULT NULL,
  `sudo` varchar(64) DEFAULT NULL,
  `title` varchar(128) DEFAULT NULL,
  `time` varchar(128) DEFAULT '0',
  `ratings` varchar(128) DEFAULT NULL,
  `points` int(11) NOT NULL DEFAULT '0',
  `hook` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
