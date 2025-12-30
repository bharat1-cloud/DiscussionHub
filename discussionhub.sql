-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 30, 2025 at 06:26 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `discussionhub`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `full_name` varchar(150) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `profile_pic` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `username`, `full_name`, `email`, `password`, `profile_pic`, `created_at`) VALUES
(1, 'kiran', 'kiran', 'kiran@gmail.com', 'kiran123', NULL, '2025-04-21 13:54:33');

-- --------------------------------------------------------

--
-- Table structure for table `answers`
--

CREATE TABLE `answers` (
  `id` int(11) NOT NULL,
  `question_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `answers`
--

INSERT INTO `answers` (`id`, `question_id`, `user_id`, `content`, `created_at`) VALUES
(13, 77, 14, 'numpy', '2025-04-26 04:13:36'),
(14, 56, 1, 'gd', '2025-04-26 04:26:57'),
(15, 82, 1, 'fd', '2025-04-26 04:39:07');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`id`, `name`) VALUES
(1, 'General Discussion'),
(2, 'Programming'),
(4, 'Busines'),
(5, 'Gaming'),
(12, 'Music'),
(18, 'Design');

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `question_id` int(11) DEFAULT NULL,
  `answer_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`id`, `question_id`, `answer_id`, `user_id`, `content`, `created_at`) VALUES
(31, 77, NULL, 14, 'numpy', '2025-04-26 04:13:16'),
(32, NULL, 13, 14, 'numpy', '2025-04-26 04:13:57'),
(33, NULL, 13, 14, 'numpy', '2025-04-26 04:14:18'),
(34, NULL, 13, 14, 'numpy', '2025-04-26 04:14:23'),
(35, NULL, 13, 14, 'numpy', '2025-04-26 04:14:40'),
(36, NULL, NULL, 14, 'numpy', '2025-04-26 04:19:33'),
(37, NULL, NULL, 14, 'numpy', '2025-04-26 04:19:41'),
(38, NULL, NULL, 14, 'hi', '2025-04-26 04:19:54'),
(39, NULL, NULL, 14, 'hi', '2025-04-26 04:19:59'),
(40, 77, NULL, 14, 'hi', '2025-04-26 04:20:15'),
(41, 56, NULL, 1, 'ht', '2025-04-26 04:26:50'),
(42, NULL, NULL, 1, 'dg', '2025-04-26 04:27:05'),
(43, 82, NULL, 1, 'df', '2025-04-26 04:39:12'),
(44, NULL, NULL, 1, 'fdf', '2025-04-26 04:39:22'),
(45, NULL, NULL, 1, 'fdf', '2025-04-26 04:39:28'),
(46, NULL, NULL, 1, 'fdf', '2025-04-26 04:39:35'),
(47, NULL, NULL, 1, 'df', '2025-04-26 04:40:48'),
(48, NULL, NULL, 1, 'd', '2025-04-26 04:41:01'),
(49, NULL, NULL, 1, 'd', '2025-04-26 04:41:06'),
(50, NULL, NULL, 1, 'd', '2025-04-26 04:41:12'),
(51, NULL, 15, 1, 'df', '2025-04-26 04:41:49');

-- --------------------------------------------------------

--
-- Table structure for table `contact`
--

CREATE TABLE `contact` (
  `id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `subject` varchar(200) DEFAULT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `contact`
--

INSERT INTO `contact` (`id`, `full_name`, `email`, `subject`, `message`, `created_at`) VALUES
(1, 'Bharat yangandul', 'bharat@gmail.com', 'New category add', 'New category add \"News\"', '2025-04-22 02:55:10');

-- --------------------------------------------------------

--
-- Table structure for table `notification`
--

CREATE TABLE `notification` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `link` varchar(255) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notification`
--

INSERT INTO `notification` (`id`, `user_id`, `message`, `link`, `is_read`, `created_at`) VALUES
(31, 9, 'Your question received a vote.', 'questionDetails.jsp?id=62', 0, '2025-04-22 07:03:14'),
(32, 12, 'Your question received a vote.', 'questionDetails.jsp?id=77', 0, '2025-04-26 04:12:54'),
(33, 12, 'Someone saved your question.', 'questionDetails.jsp?id=77', 0, '2025-04-26 04:13:00'),
(34, 12, 'Someone commented under your question.', 'questionDetails.jsp?id=77', 0, '2025-04-26 04:13:16'),
(35, 12, 'Someone answered your question.', 'questionDetails.jsp?id=77', 0, '2025-04-26 04:13:36'),
(44, 12, 'Someone commented under your question.', 'questionDetails.jsp?id=77', 0, '2025-04-26 04:20:15'),
(45, 7, 'Someone commented under your question.', 'questionDetails.jsp?id=56', 0, '2025-04-26 04:26:50'),
(46, 7, 'Someone answered your question.', 'questionDetails.jsp?id=56', 0, '2025-04-26 04:26:57'),
(48, 13, 'Someone saved your question.', 'questionDetails.jsp?id=82', 0, '2025-04-26 04:28:19'),
(49, 12, 'Your question received a vote.', 'questionDetails.jsp?id=78', 0, '2025-04-26 04:29:45'),
(50, 13, 'Someone answered your question.', 'questionDetails.jsp?id=82', 0, '2025-04-26 04:39:07'),
(51, 13, 'Someone commented under your question.', 'questionDetails.jsp?id=82', 0, '2025-04-26 04:39:12');

-- --------------------------------------------------------

--
-- Table structure for table `questions`
--

CREATE TABLE `questions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `views` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `questions`
--

INSERT INTO `questions` (`id`, `user_id`, `title`, `description`, `category_id`, `created_at`, `views`) VALUES
(16, 4, 'How to optimize React performance?', 'I have a React application that is running slow. What are some best practices to optimize its performance?', 2, '2025-04-22 06:39:45', 15),
(17, 4, 'Best resources to learn JavaScript in 2025?', 'Looking for up-to-date resources to master modern JavaScript. Any recommendations?', 2, '2025-04-22 06:39:45', 23),
(18, 4, 'CSS Grid vs Flexbox - when to use which?', 'I\'m confused about when to use CSS Grid and when to use Flexbox. Can someone explain the key differences?', 2, '2025-04-22 06:39:45', 42),
(19, 4, 'How to implement authentication in Node.js?', 'What is the most secure way to implement user authentication in a Node.js application?', 2, '2025-04-22 06:39:45', 18),
(20, 4, 'General discussion about web development trends', 'What do you think will be the biggest web development trends in the next 5 years?', 1, '2025-04-22 06:39:45', 37),
(21, 4, 'How to optimize React performance?', 'I have a React application that is running slow. What are some best practices to optimize its performance?', 2, '2025-04-22 06:40:23', 15),
(22, 4, 'Best resources to learn JavaScript in 2025?', 'Looking for up-to-date resources to master modern JavaScript. Any recommendations?', 2, '2025-04-22 06:40:23', 23),
(23, 4, 'CSS Grid vs Flexbox - when to use which?', 'I\'m confused about when to use CSS Grid and when to use Flexbox. Can someone explain the key differences?', 2, '2025-04-22 06:40:23', 42),
(24, 4, 'How to implement authentication in Node.js?', 'What is the most secure way to implement user authentication in a Node.js application?', 2, '2025-04-22 06:40:23', 18),
(25, 4, 'General discussion about web development trends', 'What do you think will be the biggest web development trends in the next 5 years?', 1, '2025-04-22 06:40:23', 37),
(26, 5, 'Best color schemes for e-commerce websites?', 'What color schemes work best for conversion in e-commerce sites?', 18, '2025-04-22 06:41:18', 29),
(27, 5, 'How to create responsive logos?', 'What techniques do you use to create logos that work well in all sizes?', 18, '2025-04-22 06:41:18', 14),
(28, 5, 'Adobe XD vs Figma - which is better?', 'For UI/UX design, which tool do you prefer and why?', 18, '2025-04-22 06:41:18', 31),
(29, 5, 'Tips for designing mobile-first', 'What are your top tips for designing with a mobile-first approach?', 18, '2025-04-22 06:41:18', 22),
(30, 5, 'General discussion about design trends', 'What design trends are you excited about in 2025?', 1, '2025-04-22 06:41:18', 19),
(47, 7, 'Best DAWs for electronic music?', 'What digital audio workstations do you recommend for producing electronic music?', 12, '2025-04-22 06:46:33', 27),
(48, 7, 'How to improve mixing skills?', 'What resources or exercises would you suggest to get better at mixing tracks?', 12, '2025-04-22 06:46:33', 18),
(49, 7, 'Hardware vs software synthesizers', 'For someone starting out, is it better to invest in hardware or stick with software synths?', 12, '2025-04-22 06:46:33', 22),
(50, 7, 'Music theory for producers', 'How much music theory is essential for electronic music producers?', 12, '2025-04-22 06:46:33', 15),
(51, 7, 'General music discussion', 'What artists or albums have inspired your work recently?', 1, '2025-04-22 06:46:33', 34),
(52, 7, 'Best DAWs for electronic music?', 'What digital audio workstations do you recommend for producing electronic music?', 12, '2025-04-22 06:46:45', 27),
(53, 7, 'How to improve mixing skills?', 'What resources or exercises would you suggest to get better at mixing tracks?', 12, '2025-04-22 06:46:45', 18),
(54, 7, 'Hardware vs software synthesizers', 'For someone starting out, is it better to invest in hardware or stick with software synths?', 12, '2025-04-22 06:46:45', 22),
(55, 7, 'Music theory for producers', 'How much music theory is essential for electronic music producers?', 12, '2025-04-22 06:46:45', 15),
(56, 7, 'General music discussion', 'What artists or albums have inspired your work recently?', 1, '2025-04-22 06:46:45', 34),
(57, 8, 'Best practices for startup funding?', 'What are the most effective strategies for securing funding for a new startup?', 4, '2025-04-22 06:49:04', 39),
(58, 8, 'How to validate a business idea?', 'What methods do you use to validate whether a business idea has potential?', 4, '2025-04-22 06:49:04', 27),
(59, 8, 'Remote team management tips', 'For those managing remote teams, what tools and techniques work best?', 4, '2025-04-22 06:49:04', 31),
(60, 8, 'Marketing strategies for small businesses', 'What low-cost marketing strategies are most effective for small businesses?', 4, '2025-04-22 06:49:04', 24),
(61, 8, 'General business discussion', 'What business trends are you watching in 2025?', 1, '2025-04-22 06:49:04', 42),
(62, 9, 'Best tools for UI prototyping?', 'What tools do you recommend for creating interactive UI prototypes?', 18, '2025-04-22 06:49:24', 29),
(63, 9, 'How to improve UX writing?', 'What resources or techniques help improve the quality of UX writing?', 18, '2025-04-22 06:49:24', 17),
(64, 9, 'Accessibility checklist for designers', 'What should be included in a comprehensive accessibility checklist?', 18, '2025-04-22 06:49:24', 23),
(65, 9, 'Dark mode design considerations', 'What special considerations are needed when designing for dark mode?', 18, '2025-04-22 06:49:24', 19),
(66, 9, 'General design discussion', 'How do you stay inspired as a designer?', 1, '2025-04-22 06:49:24', 28),
(67, 10, 'Best backend architecture for scaling?', 'What backend architecture patterns work best for applications that need to scale?', 2, '2025-04-22 06:49:36', 37),
(68, 10, 'How to implement GraphQL in Node.js?', 'What are the best practices for implementing GraphQL in a Node.js backend?', 2, '2025-04-22 06:49:36', 25),
(69, 10, 'Microservices vs monolith in 2025', 'With current technologies, is microservices still the preferred approach over monolith?', 2, '2025-04-22 06:49:36', 41),
(70, 10, 'Database optimization techniques', 'What techniques do you use to optimize database performance?', 2, '2025-04-22 06:49:36', 19),
(71, 10, 'General programming discussion', 'What programming languages are you learning in 2025?', 1, '2025-04-22 06:49:36', 33),
(72, 11, 'Best social media strategies for 2025?', 'What social media marketing strategies are working best this year?', 4, '2025-04-22 06:49:51', 42),
(73, 11, 'How to measure marketing ROI?', 'What metrics and tools do you use to measure marketing return on investment?', 4, '2025-04-22 06:49:51', 28),
(74, 11, 'Email marketing best practices', 'What are your top tips for effective email marketing campaigns?', 4, '2025-04-22 06:49:51', 31),
(75, 11, 'Content marketing trends', 'What content marketing trends are you seeing in 2025?', 4, '2025-04-22 06:49:51', 24),
(76, 11, 'General marketing discussion', 'What marketing channels are you focusing on this year?', 1, '2025-04-22 06:49:51', 37),
(77, 12, 'Best Python libraries for data science?', 'What Python libraries are essential for data science work in 2025?', 2, '2025-04-22 06:50:07', 39),
(78, 12, 'How to visualize large datasets?', 'What tools and techniques work best for visualizing datasets with millions of rows?', 2, '2025-04-22 06:50:07', 27),
(79, 12, 'Machine learning model deployment', 'What are the best practices for deploying machine learning models to production?', 2, '2025-04-22 06:50:07', 31),
(80, 12, 'Data cleaning techniques', 'What are your most effective data cleaning techniques for messy datasets?', 2, '2025-04-22 06:50:07', 24),
(81, 12, 'General data science discussion', 'What data science trends are you most excited about?', 1, '2025-04-22 06:50:07', 42),
(82, 13, 'Best color theory resources?', 'What are the best books or online resources for learning color theory?', 18, '2025-04-22 06:50:18', 29),
(83, 13, 'How to create effective brand identities?', 'What process do you follow when creating a new brand identity?', 18, '2025-04-22 06:50:18', 17),
(84, 13, 'Typography pairing tips', 'What are your favorite font pairings and why do they work?', 18, '2025-04-22 06:50:18', 23),
(85, 13, 'Design portfolio best practices', 'What makes a design portfolio stand out to potential clients?', 18, '2025-04-22 06:50:18', 19),
(86, 13, 'General graphic design discussion', 'Where do you find design inspiration?', 1, '2025-04-22 06:50:18', 28);

-- --------------------------------------------------------

--
-- Table structure for table `question_tags`
--

CREATE TABLE `question_tags` (
  `question_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `question_tags`
--

INSERT INTO `question_tags` (`question_id`, `tag_id`) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 2),
(3, 1),
(3, 2),
(4, 1),
(4, 2),
(5, 1),
(5, 2),
(6, 1),
(6, 2),
(7, 1),
(7, 2),
(9, 3),
(10, 4),
(11, 5),
(12, 6),
(31, 17),
(32, 17),
(33, 17),
(34, 17),
(35, 17),
(36, 18),
(37, 18),
(38, 18),
(39, 18),
(40, 18),
(41, 14),
(42, 14),
(43, 14),
(44, 14),
(45, 14),
(46, 15),
(46, 20),
(47, 15),
(47, 12),
(48, 15),
(49, 20),
(49, 21),
(50, 12),
(51, 18),
(52, 18),
(53, 18),
(54, 18),
(55, 18),
(56, 13),
(56, 12),
(57, 13),
(58, 13),
(59, 13),
(60, 13),
(61, 14),
(62, 14),
(63, 14),
(64, 14),
(65, 14);

-- --------------------------------------------------------

--
-- Table structure for table `saved_questions`
--

CREATE TABLE `saved_questions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `question_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `saved_questions`
--

INSERT INTO `saved_questions` (`id`, `user_id`, `question_id`) VALUES
(8, 1, 12),
(39, 1, 82),
(36, 3, 12),
(38, 14, 77);

-- --------------------------------------------------------

--
-- Table structure for table `tags`
--

CREATE TABLE `tags` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tags`
--

INSERT INTO `tags` (`id`, `name`) VALUES
(12, 'javascript'),
(13, 'css'),
(14, 'python'),
(15, 'php'),
(16, 'react'),
(17, 'angular'),
(18, 'vue'),
(19, 'nodejs'),
(20, 'mysql'),
(21, 'mongodb'),
(22, 'gaming'),
(23, 'music'),
(24, 'business'),
(25, 'design'),
(26, 'development'),
(27, 'dw'),
(28, 'java');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `mobile` varchar(15) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `is_admin` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `profile_picture` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `full_name`, `mobile`, `bio`, `is_admin`, `created_at`, `profile_picture`) VALUES
(1, 'bharat', 'bharat@gmail.com', 'bharat123', 'bharat', '9114787576', '', 0, '2025-04-18 07:36:29', NULL),
(3, 'kiran', 'kiran@gmail.com', 'kiran123', 'kiran', '9114834296', '', 0, '2025-04-19 16:35:36', NULL),
(4, 'john_doe', 'john.doe@example.com', 'password123', 'John Doe', '1234567890', 'Software developer from New York', 0, '2025-04-22 06:39:00', 'm1.png'),
(5, 'jane_smith', 'jane.smith@example.com', 'password123', 'Jane Smith', '2345678901', 'Web designer from London', 0, '2025-04-22 06:39:00', 'm2.png'),
(6, 'mike_johnson', 'mike.johnson@example.com', 'password123', 'Mike Johnson', '3456789012', 'Game developer from Tokyo', 0, '2025-04-22 06:39:00', 'm3.png'),
(7, 'sarah_williams', 'sarah.williams@example.com', 'password123', 'Sarah Williams', '4567890123', 'Music producer from Los Angeles', 0, '2025-04-22 06:39:00', 'm3.jpg'),
(8, 'david_brown', 'david.brown@example.com', 'password123', 'David Brown', '5678901234', 'Business analyst from Sydney', 0, '2025-04-22 06:39:00', 'm5.png'),
(9, 'emily_davis', 'emily.davis@example.com', 'password123', 'Emily Davis', '6789012345', 'UI/UX designer from Paris', 0, '2025-04-22 06:39:00', 'm6.png'),
(10, 'robert_miller', 'robert.miller@example.com', 'password123', 'Robert Miller', '7890123456', 'Full-stack developer from Berlin', 0, '2025-04-22 06:39:00', 'm7.png'),
(11, 'lisa_wilson', 'lisa.wilson@example.com', 'password123', 'Lisa Wilson', '8901234567', 'Digital marketer from Toronto', 0, '2025-04-22 06:39:00', 'm8.png'),
(12, 'peter_taylor', 'peter.taylor@example.com', 'password123', 'Peter Taylor', '9012345678', 'Data scientist from Singapore', 0, '2025-04-22 06:39:00', 'm9.png'),
(13, 'anna_martin', 'anna.martin@example.com', 'password123', 'Anna Martin', '0123456789', 'Graphic designer from Dubai', 0, '2025-04-22 06:39:00', 'm10.png'),
(14, 'abhishek', 'abhi@gmail.com', 'abhi123', NULL, NULL, NULL, 0, '2025-04-26 04:11:06', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `votes`
--

CREATE TABLE `votes` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `question_id` int(11) DEFAULT NULL,
  `answer_id` int(11) DEFAULT NULL,
  `vote_type` enum('up','down') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `votes`
--

INSERT INTO `votes` (`id`, `user_id`, `question_id`, `answer_id`, `vote_type`) VALUES
(41, 1, 62, NULL, 'up'),
(42, 14, 77, NULL, 'up'),
(43, 1, 78, NULL, 'down');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username_unique` (`username`);

--
-- Indexes for table `answers`
--
ALTER TABLE `answers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `question_id` (`question_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `question_id` (`question_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `comments_ibfk_2` (`answer_id`);

--
-- Indexes for table `contact`
--
ALTER TABLE `contact`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notification`
--
ALTER TABLE `notification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `questions`
--
ALTER TABLE `questions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `question_tags`
--
ALTER TABLE `question_tags`
  ADD KEY `question_id` (`question_id`),
  ADD KEY `tag_id` (`tag_id`);

--
-- Indexes for table `saved_questions`
--
ALTER TABLE `saved_questions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`question_id`);

--
-- Indexes for table `tags`
--
ALTER TABLE `tags`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `votes`
--
ALTER TABLE `votes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`question_id`),
  ADD UNIQUE KEY `user_id_2` (`user_id`,`answer_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `answers`
--
ALTER TABLE `answers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT for table `contact`
--
ALTER TABLE `contact`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `notification`
--
ALTER TABLE `notification`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT for table `questions`
--
ALTER TABLE `questions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=88;

--
-- AUTO_INCREMENT for table `saved_questions`
--
ALTER TABLE `saved_questions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `tags`
--
ALTER TABLE `tags`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `votes`
--
ALTER TABLE `votes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `answers`
--
ALTER TABLE `answers`
  ADD CONSTRAINT `answers_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `answers_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`),
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`answer_id`) REFERENCES `answers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comments_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `notification`
--
ALTER TABLE `notification`
  ADD CONSTRAINT `notification_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
