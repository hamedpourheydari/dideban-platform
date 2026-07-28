-- Dideban Platform - Persistent Instruction Center
CREATE TABLE IF NOT EXISTS `DidebanInstructions` (
  `id` varchar(64) NOT NULL,
  `title` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `priority` varchar(20) DEFAULT 'normal',
  `pinned` int DEFAULT 0,
  `require_ack` int DEFAULT 0,
  `target_type` varchar(20) DEFAULT 'all',
  `target_value` text,
  `status` varchar(20) DEFAULT 'active',
  `created_by` varchar(255),
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);
CREATE TABLE IF NOT EXISTS `DidebanInstructionReads` (
  `row_id` int NOT NULL AUTO_INCREMENT,
  `instruction_id` varchar(64) NOT NULL,
  `ke` varchar(50) NOT NULL,
  `uid` varchar(50) NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `acknowledged_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`row_id`),
  UNIQUE KEY `dideban_instruction_read_unique` (`instruction_id`,`ke`,`uid`)
);
