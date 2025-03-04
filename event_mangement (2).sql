-- phpMyAdmin SQL Dump
-- version 5.1.1deb5ubuntu1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Mar 04, 2025 at 10:25 AM
-- Server version: 8.0.39-0ubuntu0.22.04.1
-- PHP Version: 8.1.2-1ubuntu2.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `event_mangement`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` varchar(16) NOT NULL,
  `pass` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `pass`) VALUES
('admin', '$2a$12$GItZp0K210risZyDfRuYVO1DOxYRIhpRN6QM7RY29RA8qsd2xNyXu');

-- --------------------------------------------------------

--
-- Table structure for table `child_event`
--

CREATE TABLE `child_event` (
  `child_event_id` int NOT NULL,
  `child_event_name` varchar(255) NOT NULL,
  `child_event_type` varchar(50) NOT NULL,
  `max_partispant` int NOT NULL,
  `event_id` int NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `child_event`
--

INSERT INTO `child_event` (`child_event_id`, `child_event_name`, `child_event_type`, `max_partispant`, `event_id`, `description`) VALUES
(1, 'Python for Web', 'same', 40, 1, 'talk about how python is using on web development'),
(2, 'Python for data analytics', 'same', 40, 1, 'how python is used for data analytics');

-- --------------------------------------------------------

--
-- Table structure for table `child_event_enrolments`
--

CREATE TABLE `child_event_enrolments` (
  `event_id` int NOT NULL,
  `child_event_id` int NOT NULL,
  `partispant_id` varchar(16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `event_enrolments`
--

CREATE TABLE `event_enrolments` (
  `enroll_id` int NOT NULL,
  `partispant_id` varchar(16) NOT NULL,
  `event_id` int NOT NULL,
  `enrolled_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `event_enrolments`
--

INSERT INTO `event_enrolments` (`enroll_id`, `partispant_id`, `event_id`, `enrolled_time`) VALUES
(7, 'std01', 1, '2025-02-28 06:21:40'),
(8, 'std01', 2, '2025-02-28 06:21:42');

-- --------------------------------------------------------

--
-- Table structure for table `organiser`
--

CREATE TABLE `organiser` (
  `organiser_id` varchar(16) NOT NULL,
  `organiser_name` varchar(255) NOT NULL,
  `pass` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `organiser`
--

INSERT INTO `organiser` (`organiser_id`, `organiser_name`, `pass`) VALUES
('01OOC123', 'Tamil', '$2b$10$v7BmpfdW0oJeUcF5jcXAKumgs2Qx/BwfKiw0T4sgIjfWBr.Bkcweq');

-- --------------------------------------------------------

--
-- Table structure for table `parent_event`
--

CREATE TABLE `parent_event` (
  `event_id` int NOT NULL,
  `event_name` varchar(255) NOT NULL,
  `event_type` varchar(50) NOT NULL,
  `event_date` date NOT NULL,
  `organiser_id` varchar(16) NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `parent_event`
--

INSERT INTO `parent_event` (`event_id`, `event_name`, `event_type`, `event_date`, `organiser_id`, `description`) VALUES
(1, 'Python workShop', 'Workshop', '2025-02-22', '01ooc123', 'this workshop help to build a strong career in python development'),
(2, 'new event ', 'Seminar', '2025-02-20', '01ooc123', 'a good seminar');

-- --------------------------------------------------------

--
-- Table structure for table `partispants`
--

CREATE TABLE `partispants` (
  `partispant_id` varchar(16) NOT NULL,
  `partispant_name` varchar(255) NOT NULL,
  `pass` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `partispants`
--

INSERT INTO `partispants` (`partispant_id`, `partispant_name`, `pass`) VALUES
('std01', 'Vijay', '$2b$10$v7BmpfdW0oJeUcF5jcXAKumgs2Qx/BwfKiw0T4sgIjfWBr.Bkcweq');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `child_event`
--
ALTER TABLE `child_event`
  ADD PRIMARY KEY (`child_event_id`),
  ADD KEY `child_event_ibfk_1` (`event_id`);

--
-- Indexes for table `child_event_enrolments`
--
ALTER TABLE `child_event_enrolments`
  ADD PRIMARY KEY (`event_id`,`child_event_id`),
  ADD KEY `child_event_enrolments_ibfk_1` (`partispant_id`),
  ADD KEY `child_event_enrolments_ibfk_2` (`child_event_id`);

--
-- Indexes for table `event_enrolments`
--
ALTER TABLE `event_enrolments`
  ADD PRIMARY KEY (`enroll_id`),
  ADD UNIQUE KEY `partispant_id` (`partispant_id`,`event_id`),
  ADD KEY `event_enrolments_ibfk_2` (`event_id`);

--
-- Indexes for table `organiser`
--
ALTER TABLE `organiser`
  ADD PRIMARY KEY (`organiser_id`);

--
-- Indexes for table `parent_event`
--
ALTER TABLE `parent_event`
  ADD PRIMARY KEY (`event_id`),
  ADD KEY `parent_event_ibfk_1` (`organiser_id`);

--
-- Indexes for table `partispants`
--
ALTER TABLE `partispants`
  ADD PRIMARY KEY (`partispant_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `child_event`
--
ALTER TABLE `child_event`
  MODIFY `child_event_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `event_enrolments`
--
ALTER TABLE `event_enrolments`
  MODIFY `enroll_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `parent_event`
--
ALTER TABLE `parent_event`
  MODIFY `event_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `child_event`
--
ALTER TABLE `child_event`
  ADD CONSTRAINT `child_event_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `parent_event` (`event_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `child_event_enrolments`
--
ALTER TABLE `child_event_enrolments`
  ADD CONSTRAINT `child_event_enrolments_ibfk_1` FOREIGN KEY (`partispant_id`) REFERENCES `partispants` (`partispant_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  ADD CONSTRAINT `child_event_enrolments_ibfk_2` FOREIGN KEY (`child_event_id`) REFERENCES `child_event` (`child_event_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  ADD CONSTRAINT `child_event_enrolments_ibfk_3` FOREIGN KEY (`event_id`) REFERENCES `parent_event` (`event_id`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Constraints for table `event_enrolments`
--
ALTER TABLE `event_enrolments`
  ADD CONSTRAINT `event_enrolments_ibfk_1` FOREIGN KEY (`partispant_id`) REFERENCES `partispants` (`partispant_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  ADD CONSTRAINT `event_enrolments_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `parent_event` (`event_id`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Constraints for table `parent_event`
--
ALTER TABLE `parent_event`
  ADD CONSTRAINT `parent_event_ibfk_1` FOREIGN KEY (`organiser_id`) REFERENCES `organiser` (`organiser_id`) ON DELETE CASCADE ON UPDATE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
