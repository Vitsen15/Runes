-- phpMyAdmin SQL Dump
-- version 4.7.3
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Сен 30 2017 г., 21:22
-- Версия сервера: 5.6.37
-- Версия PHP: 7.1.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `runes`
--

-- --------------------------------------------------------

--
-- Структура таблицы `classes`
--

CREATE TABLE `classes` (
  `id` int(8) NOT NULL,
  `name` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `classes`
--

INSERT INTO `classes` (`id`, `name`) VALUES
(1, 'Амазонка'),
(2, 'Варвар'),
(3, 'Волшебница'),
(4, 'Некромант'),
(5, 'Паладин'),
(6, 'Ассасин'),
(7, 'Друид');

-- --------------------------------------------------------

--
-- Структура таблицы `classes_word_properties`
--

CREATE TABLE `classes_word_properties` (
  `id` int(8) NOT NULL,
  `class_id` int(8) NOT NULL,
  `runes_word_property_id` int(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `classes_word_properties`
--

INSERT INTO `classes_word_properties` (`id`, `class_id`, `runes_word_property_id`) VALUES
(1, 2, 6),
(2, 5, 9),
(3, 3, 16),
(4, 3, 17),
(5, 3, 18),
(6, 1, 22),
(7, 1, 23),
(8, 1, 24),
(9, 3, 26),
(10, 3, 27),
(11, 4, 38),
(12, 4, 39),
(13, 6, 54),
(14, 7, 21);

-- --------------------------------------------------------

--
-- Структура таблицы `equipment`
--

CREATE TABLE `equipment` (
  `id` int(8) NOT NULL,
  `name` varchar(30) NOT NULL,
  `sockets` int(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `equipment`
--

INSERT INTO `equipment` (type_id, type_name, type_parent_id) VALUES
(9, 'Дубина', 3),
(10, 'Молот', 3),
(11, 'Булава', 3),
(12, 'Оружие ближнего боя', 3),
(13, 'Скипетр', 4),
(14, 'Оружие ближнего боя', 5),
(15, 'Меч', 3),
(16, 'Скипетр', 3),
(17, 'Посох', 2),
(18, 'Дистанционное оружие', 3),
(19, 'Посох', 4),
(20, 'Любое оружие', 6),
(21, 'Меч', 2),
(22, 'Топор', 2),
(23, 'Булава', 2),
(24, 'Оружие ближнего боя', 2),
(25, 'Любое оружие', 3),
(26, 'Палочка некроманта', 2),
(27, 'Дистанционное оружие', 2),
(28, 'Шлем', 2),
(29, 'Шлем', 3),
(30, 'Щит', 3),
(31, 'Щит', 2),
(32, 'Нагрудный доспех', 3),
(33, 'Нагрудный доспех', 2);

-- --------------------------------------------------------

--
-- Структура таблицы `runes`
--

CREATE TABLE `runes` (
  `id` int(8) NOT NULL,
  `name` varchar(5) NOT NULL,
  `img_url` varchar(255) NOT NULL COMMENT 'rune image url',
  `lvl` int(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `runes`
--

INSERT INTO `runes` (`id`, `name`, `img_url`, `lvl`) VALUES
(1, 'El', 'img/runes/El.gif', 11),
(2, 'Eld', 'img/runes/Eld.gif', 11),
(3, 'Tir', 'img/runes/Tir.gif', 13),
(4, 'Nef', 'img/runes/Nef.gif', 13),
(5, 'Eth', 'img/runes/Eth.gif', 15),
(6, 'Ith', 'img/runes/Ith.gif', 15),
(7, 'Tal', 'img/runes/Tal.gif', 17),
(8, 'Ral', 'img/runes/Ral.gif', 19),
(9, 'Ort', 'img/runes/Ort.gif', 21),
(10, 'Thul', 'img/runes/Thul.gif', 23),
(11, 'Amn', 'img/runes/Amn.gif', 25),
(12, 'Sol', 'img/runes/Sol.gif', 27),
(13, 'Shael', 'img/runes/Shael.gif', 29),
(14, 'Dol', 'img/runes/Dol.gif', 31),
(15, 'Hel', 'img/runes/Hel.gif', 33),
(16, 'Io', 'img/runes/Io.gif', 35),
(17, 'Lum', 'img/runes/Lum.gif', 37),
(18, 'Ko', 'img/runes/Ko.gif', 39),
(19, 'Fal', 'img/runes/Fal.gif', 41),
(20, 'Lem', 'img/runes/Lem.gif', 43),
(21, 'Pul', 'img/runes/Pul.gif', 45),
(22, 'Um', 'img/runes/Um.gif', 47),
(23, 'Mal', 'img/runes/Mal.gif', 49),
(24, 'Ist', 'img/runes/Ist.gif', 51),
(25, 'Gul', 'img/runes/Gul.gif', 53),
(26, 'Vex', 'img/runes/Vex.gif', 55),
(27, 'Ohm', 'img/runes/Ohm.gif', 57),
(28, 'Lo', 'img/runes/Lo.gif', 59),
(29, 'Sur', 'img/runes/Sur.gif', 61),
(30, 'Ber', 'img/runes/Ber.gif', 63),
(31, 'Jah', 'img/runes/Jah.gif', 65),
(32, 'Cham', 'img/runes/Cham.gif', 67),
(33, 'Zod', 'img/runes/Zod.gif', 69);

-- --------------------------------------------------------

--
-- Структура таблицы `runes_order`
--

CREATE TABLE `runes_order` (
  `id` int(8) NOT NULL,
  `rune_id` int(8) NOT NULL,
  `runes_word_id` int(8) NOT NULL,
  `rune_order` int(4) NOT NULL COMMENT 'order of rune in runes word'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `runes_order`
--

INSERT INTO `runes_order` (`id`, `rune_id`, `runes_word_id`, `rune_order`) VALUES
(3, 10, 1, 1),
(4, 16, 1, 2),
(5, 4, 1, 3),
(6, 31, 2, 1),
(7, 25, 2, 2),
(8, 5, 2, 3),
(9, 5, 3, 1),
(10, 8, 3, 2),
(11, 9, 3, 3),
(12, 7, 3, 4),
(13, 11, 4, 1),
(14, 1, 4, 2),
(15, 6, 4, 3),
(16, 3, 4, 4),
(17, 12, 4, 5),
(18, 11, 5, 1),
(19, 8, 5, 2),
(20, 10, 5, 3),
(21, 3, 6, 1),
(22, 8, 6, 2),
(23, 6, 7, 1),
(24, 1, 7, 2),
(25, 5, 7, 3),
(26, 13, 8, 1),
(27, 18, 8, 2),
(28, 4, 8, 3),
(29, 17, 9, 1),
(30, 16, 9, 2),
(31, 12, 9, 3),
(32, 5, 9, 4),
(33, 14, 10, 1),
(34, 2, 10, 2),
(35, 15, 10, 3),
(36, 24, 10, 4),
(37, 3, 10, 5),
(38, 26, 10, 6),
(39, 3, 11, 1),
(40, 1, 11, 2),
(41, 11, 12, 1),
(42, 3, 12, 2),
(43, 7, 13, 1),
(44, 14, 13, 2),
(45, 23, 13, 3),
(46, 14, 14, 1),
(47, 16, 14, 2),
(48, 9, 15, 1),
(49, 5, 15, 2),
(50, 9, 16, 1),
(51, 12, 16, 2),
(52, 4, 17, 1),
(53, 3, 17, 2),
(54, 4, 18, 1),
(55, 12, 18, 2),
(56, 6, 18, 3),
(57, 8, 19, 1),
(58, 9, 19, 2),
(59, 7, 19, 3),
(60, 13, 20, 1),
(61, 5, 20, 2),
(62, 15, 21, 1),
(63, 17, 21, 2),
(64, 19, 21, 3),
(65, 4, 22, 1),
(66, 17, 22, 2),
(67, 7, 23, 1),
(68, 5, 23, 2),
(69, 20, 24, 1),
(70, 18, 24, 2),
(71, 3, 24, 3);

-- --------------------------------------------------------

--
-- Структура таблицы `runes_rune_properties`
--

CREATE TABLE `runes_rune_properties` (
  `id` int(8) NOT NULL,
  `rune_id` int(8) NOT NULL,
  `property_id` int(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `runes_rune_properties`
--

INSERT INTO `runes_rune_properties` (`id`, `rune_id`, `property_id`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 39),
(4, 2, 3),
(5, 2, 4),
(6, 2, 40),
(7, 3, 5),
(8, 4, 6),
(9, 4, 65),
(10, 5, 7),
(11, 5, 66),
(12, 6, 8),
(13, 6, 42),
(14, 7, 9),
(15, 7, 43),
(16, 8, 10),
(17, 8, 44),
(18, 9, 11),
(19, 9, 45),
(20, 10, 12),
(21, 10, 46),
(22, 11, 13),
(23, 11, 47),
(24, 12, 16),
(25, 12, 48),
(26, 13, 17),
(27, 13, 49),
(28, 14, 18),
(29, 14, 50),
(30, 15, 19),
(31, 15, 51),
(32, 16, 20),
(33, 17, 21),
(34, 18, 22),
(35, 19, 23),
(36, 20, 24),
(37, 20, 52),
(38, 21, 25),
(39, 21, 26),
(40, 21, 53),
(41, 22, 27),
(42, 22, 54),
(43, 23, 28),
(44, 23, 55),
(45, 24, 29),
(46, 24, 56),
(47, 25, 30),
(48, 25, 57),
(49, 26, 31),
(50, 26, 58),
(51, 27, 32),
(52, 27, 59),
(53, 28, 33),
(54, 28, 60),
(55, 29, 34),
(56, 29, 61),
(57, 30, 35),
(58, 30, 62),
(59, 31, 36),
(60, 31, 63),
(61, 32, 37),
(62, 32, 64),
(63, 33, 38);

-- --------------------------------------------------------

--
-- Структура таблицы `rune_properties`
--

CREATE TABLE `rune_properties` (
  `id` int(8) NOT NULL,
  `property` varchar(255) NOT NULL,
  `in_weapon` tinyint(1) DEFAULT '0',
  `in_armour` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `rune_properties`
--

INSERT INTO `rune_properties` (`id`, `property`, `in_weapon`, `in_armour`) VALUES
(1, '+50 To Attack Rating', 1, 0),
(2, '+1 Light Radius', 1, 1),
(3, '+75% Damage To Undead', 1, 0),
(4, '+50 Attack Rating Against Undead', 1, 0),
(5, '+2 To Mana After Each Kill', 1, 1),
(6, 'Knockback', 1, 0),
(7, '-25% To Target Defense', 1, 0),
(8, '+9 To Maximum Damage', 1, 0),
(9, '+75 Poison Damage Over 5 Seconds', 1, 0),
(10, 'Adds 5-30 Fire Damage', 1, 0),
(11, 'Adds 1-50 Lightning Damage', 1, 0),
(12, 'Adds 3-14 Cold Damage - 3 Second Duration', 1, 0),
(13, '7% Life Stolen Per Hit', 1, 0),
(16, '+9 To Minimum Damage', 1, 0),
(17, '20% Increased Attack Speed', 1, 0),
(18, 'Hit Causes Monster To Flee 25%', 1, 0),
(19, 'Requirements -20%', 1, 0),
(20, '+10 To Vitality', 1, 1),
(21, '+10 To Energy', 1, 1),
(22, '+10 To Dexterity', 1, 1),
(23, '+10 To Strength', 1, 1),
(24, '75% Extra Gold From Monsters', 1, 0),
(25, '+75% Damage To Demons', 1, 0),
(26, '+100 Attack Rating Against Demons', 1, 0),
(27, '25% Chance of Open Wounds', 1, 0),
(28, 'Prevent Monster Heal', 1, 0),
(29, '30% Better Chance of Getting Magic Items', 1, 0),
(30, '20% Bonus To Attack Rating', 1, 0),
(31, '7% Mana Stolen Per Hit', 1, 0),
(32, '+50% Enhanced Damage', 1, 0),
(33, '20% Deadly Strike', 1, 0),
(34, 'Hit Blinds Target', 1, 0),
(35, '20% Chance of Crushing Blow', 1, 0),
(36, 'Ignore Target\'s Defense', 1, 0),
(37, 'Freeze Target +3', 1, 0),
(38, 'Indestructible', 1, 1),
(39, '+15 Defense', 0, 1),
(40, '15% Slower Stamina Drain/7% Increased Chance of Blocking (Shields)', 0, 1),
(41, '+2 To Mana After Each Kill', 0, 0),
(42, '15% Damage Taken Goes to Mana', 0, 1),
(43, 'Poison Resist 30%/Poison Resist 35% (Shields)', 0, 1),
(44, 'Fire Resist 30%/Fire Resist 35% (Shields)', 0, 1),
(45, 'Lightning Resist 30%/Lightning Resist 35% (Shields)', 0, 1),
(46, 'Cold Resist 30%/Cold Resist 35% (Shields)', 0, 1),
(47, 'Attacker Takes Damage of 14', 0, 1),
(48, 'Damage Reduced By 7', 0, 1),
(49, '20% Faster Hit Recovery/20% Faster Block Rate (Shields)', 0, 1),
(50, 'Replenish Life +7', 0, 1),
(51, 'Requirements -15%', 0, 1),
(52, '50% Extra Gold From Monsters', 0, 1),
(53, '+30% Enhanced Defense', 0, 1),
(54, 'All Resistances +15 (Armor/Helms) +22 (Shields)', 0, 1),
(55, 'Magic Damage Reduced By 7', 0, 1),
(56, '25% Better Chance of Getting Magic Items', 0, 1),
(57, '5% To Maximum Poison Resist', 0, 1),
(58, '5% To Maximum Fire Resist', 0, 1),
(59, '5% To Maximum Cold Resist', 0, 1),
(60, '5% To Maximum Lightning Resist', 0, 1),
(61, 'Maximum Mana 5%/+50 To Mana (Shields)', 0, 1),
(62, 'Damage Reduced by 8%', 0, 1),
(63, 'Increase Maximum Life 5%/+50 Life (Shields)', 0, 1),
(64, 'Cannot Be Frozen', 0, 1),
(65, '+30 Defense Vs. Missile', 0, 1),
(66, 'Regenerate Mana 15%', 0, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `words`
--

CREATE TABLE `words` (
  `id` int(8) NOT NULL,
  `name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `words`
--

INSERT INTO `words` (`id`, `name`) VALUES
(1, 'Black'),
(2, 'Fury'),
(3, 'Holy Thunder'),
(4, 'Honor'),
(5, 'King\'s Grace'),
(6, 'Leaf'),
(7, 'Malice'),
(8, 'Melody'),
(9, 'Memory'),
(10, 'Silence'),
(11, 'Steel'),
(12, 'Strength'),
(13, 'Venom'),
(14, 'White'),
(15, 'Zephyr'),
(16, 'Lore'),
(17, 'Nadir'),
(18, 'Radiance'),
(19, 'Ancient\'s Pledge'),
(20, 'Rhyme'),
(21, 'Lionheart'),
(22, 'Smoke'),
(23, 'Stealth'),
(24, 'Wealth');

-- --------------------------------------------------------

--
-- Структура таблицы `words_equipment`
--

CREATE TABLE `words_equipment` (
  `id` int(8) NOT NULL,
  `runes_word_id` int(8) NOT NULL,
  `equipment_id` int(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `words_equipment`
--

INSERT INTO `words_equipment` (`id`, `runes_word_id`, `equipment_id`) VALUES
(1, 1, 11),
(2, 1, 9),
(3, 1, 10),
(4, 2, 12),
(5, 3, 13),
(6, 4, 14),
(7, 5, 15),
(8, 5, 16),
(9, 6, 17),
(10, 7, 12),
(11, 8, 18),
(12, 9, 19),
(13, 10, 20),
(14, 11, 21),
(15, 11, 22),
(16, 11, 23),
(17, 12, 24),
(18, 13, 25),
(19, 14, 26),
(20, 15, 27),
(21, 16, 28),
(22, 17, 28),
(23, 18, 29),
(24, 19, 30),
(25, 20, 31),
(26, 21, 32),
(27, 22, 33),
(28, 23, 33),
(29, 24, 32);

-- --------------------------------------------------------

--
-- Структура таблицы `words_word_properties`
--

CREATE TABLE `words_word_properties` (
  `id` int(8) NOT NULL,
  `runes_word_id` int(8) NOT NULL,
  `runes_word_property_id` int(8) NOT NULL COMMENT 'property id of runes word'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `words_word_properties`
--

INSERT INTO `words_word_properties` (`id`, `runes_word_id`, `runes_word_property_id`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(4, 2, 4),
(5, 2, 5),
(6, 2, 6),
(7, 3, 7),
(8, 3, 8),
(9, 3, 9),
(10, 4, 10),
(11, 4, 11),
(12, 4, 12),
(13, 5, 13),
(14, 5, 14),
(15, 5, 15),
(16, 6, 16),
(17, 6, 17),
(18, 6, 18),
(19, 7, 19),
(20, 7, 12),
(21, 7, 21),
(22, 8, 22),
(23, 8, 23),
(24, 8, 24),
(25, 9, 25),
(26, 9, 26),
(27, 9, 27),
(28, 10, 28),
(29, 10, 29),
(30, 10, 30),
(31, 11, 31),
(32, 11, 32),
(33, 11, 33),
(34, 12, 34),
(35, 12, 35),
(36, 13, 36),
(37, 13, 37),
(38, 14, 38),
(39, 14, 39),
(40, 15, 40),
(41, 15, 41),
(42, 16, 42),
(43, 16, 43),
(44, 16, 44),
(45, 17, 45),
(46, 17, 46),
(47, 18, 48),
(48, 18, 49),
(49, 19, 50),
(50, 19, 51),
(51, 19, 52),
(52, 20, 53),
(53, 20, 54),
(54, 20, 55),
(55, 21, 57),
(56, 22, 58),
(57, 22, 59),
(58, 23, 60),
(59, 23, 61),
(60, 24, 62),
(61, 24, 63);

-- --------------------------------------------------------

--
-- Структура таблицы `word_properties`
--

CREATE TABLE `word_properties` (
  `id` int(8) NOT NULL,
  `property` varchar(225) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `word_properties`
--

INSERT INTO `word_properties` (`id`, `property`) VALUES
(1, '+120% увеличенный урон'),
(2, '40% шанс сокрушительного удара'),
(3, '+200 к рейтингу атаки'),
(4, '+209% увеличенный урон'),
(5, '40% увеличенная скорость атаки'),
(6, '+5 к навыку Frenzy (только варвар)'),
(7, '+60% увеличенный урон'),
(8, '-25% защиты у цели'),
(9, '+3 к навыку Holy Shock (только паладин)'),
(10, '+160% увеличенный урон'),
(11, '+9 к минимальному урону'),
(12, '+9 к максимальному урону'),
(13, '+100% увеличенный урон'),
(14, '+100% урона по демонам'),
(15, '+50% урона по мертвецам'),
(16, '+3 к навыку Fire Bolt (только волшебница)'),
(17, '+3 к навыку Inferno (только волшебница)'),
(18, '+3 к навыку Warmth (только волшебница)'),
(19, '+33% увеличенный урон'),
(21, '100% шанс открытой раны'),
(22, '+3 к навыам лука и арбалета (только амазонка)'),
(23, '+3 к навыку Critical Strike (только амазонка)'),
(24, '+3 к навыку Dodge (только амазонка)'),
(25, '+3 к навыкам волшебницы'),
(26, '+3 к навыку Energy Shield (только волшебница)'),
(27, '+2 к навыку Static Field (только волшебница)'),
(28, '200% увеличенный урон'),
(29, '+75% урона по мертвецам'),
(30, 'Требования -20%'),
(31, '20% увеличенный урон'),
(32, '+3 к минимальному урону'),
(33, '+3 к максимальному урону'),
(34, '35% увеличенный урон'),
(35, '25% шанс сокрушительного удара'),
(36, '25% при ударе обратить монстра в бегство'),
(37, 'Запрещает монстру лечиться'),
(38, '+3 к навыку Poison And Bone Skills (только некромант)'),
(39, '+3 к навыку Bone Armor (только некромант)'),
(40, '+66% к рейтингу атаки'),
(41, 'Добавляет 1-50 урона молнией'),
(42, '+1 ко всем навыкам'),
(43, '+10 к энергии\r\n'),
(44, '+2 к мане за каждое убийство'),
(45, '+50% увеличенная защита'),
(46, '33% больше золота с монстров'),
(48, '+10 к живучести'),
(49, '15% урона идет по мане'),
(50, '+43% сопротивление холоду'),
(51, '+48% сопротивление огню '),
(52, '+48% сопротивление молнии'),
(53, '20% увеличенный шанс блокирования'),
(54, '40% ускоренный блок'),
(55, 'Все сопротивляемости +25'),
(57, 'Требования -15%'),
(58, '+280 защиты от стрел'),
(59, '20% более быстрое восстановление после удара'),
(60, 'Магический урон уменьшается на 3'),
(61, '+6 к ловкости'),
(62, '300% больше золота с монстров'),
(63, '100% больше шансов найти магический предмет');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `classes`
--
ALTER TABLE `classes`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `classes_word_properties`
--
ALTER TABLE `classes_word_properties`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `equipment`
--
ALTER TABLE `equipment`
  ADD PRIMARY KEY (type_id);

--
-- Индексы таблицы `runes`
--
ALTER TABLE `runes`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `runes_order`
--
ALTER TABLE `runes_order`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `runes_rune_properties`
--
ALTER TABLE `runes_rune_properties`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `rune_properties`
--
ALTER TABLE `rune_properties`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `words`
--
ALTER TABLE `words`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `words_equipment`
--
ALTER TABLE `words_equipment`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `words_word_properties`
--
ALTER TABLE `words_word_properties`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `word_properties`
--
ALTER TABLE `word_properties`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `classes`
--
ALTER TABLE `classes`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT для таблицы `classes_word_properties`
--
ALTER TABLE `classes_word_properties`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
--
-- AUTO_INCREMENT для таблицы `equipment`
--
ALTER TABLE `equipment`
  MODIFY type_id int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;
--
-- AUTO_INCREMENT для таблицы `runes`
--
ALTER TABLE `runes`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;
--
-- AUTO_INCREMENT для таблицы `runes_order`
--
ALTER TABLE `runes_order`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;
--
-- AUTO_INCREMENT для таблицы `runes_rune_properties`
--
ALTER TABLE `runes_rune_properties`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;
--
-- AUTO_INCREMENT для таблицы `rune_properties`
--
ALTER TABLE `rune_properties`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;
--
-- AUTO_INCREMENT для таблицы `words`
--
ALTER TABLE `words`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;
--
-- AUTO_INCREMENT для таблицы `words_equipment`
--
ALTER TABLE `words_equipment`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;
--
-- AUTO_INCREMENT для таблицы `words_word_properties`
--
ALTER TABLE `words_word_properties`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;
--
-- AUTO_INCREMENT для таблицы `word_properties`
--
ALTER TABLE `word_properties`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
