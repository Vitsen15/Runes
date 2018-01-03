-- phpMyAdmin SQL Dump
-- version 4.7.3
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Янв 01 2018 г., 19:44
-- Версия сервера: 10.1.25-MariaDB
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

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`%` PROCEDURE `intersectFilters` (IN `runes` VARCHAR(255) COLLATE utf8_general_ci, IN `sockets` VARCHAR(255) COLLATE utf8_general_ci, IN `classes` VARCHAR(255) COLLATE utf8_general_ci, IN `min_level` VARCHAR(255) COLLATE utf8_general_ci, IN `max_level` VARCHAR(255) COLLATE utf8_general_ci, IN `equipment` VARCHAR(255) COLLATE utf8_general_ci, OUT `result` VARCHAR(255))  BEGIN

    CALL selectWordsByRunes(runes, @Runes);

    CALL selectWordsBySockets(sockets, @Sockets);

    SELECT group_concat(words.id)
    FROM words
    WHERE IF(runes != '', words.id IN (
      SELECT words.id
      FROM words
      WHERE
        find_in_set(cast(words.id AS CHAR),
                    (SELECT *
                     FROM (SELECT @Runes AS Runes) AS runes))),
             TRUE)
          AND IF(sockets != '',
                 words.id IN (
                   SELECT words.id
                   FROM words
                   WHERE find_in_set(cast(words.id AS CHAR),
                                     (SELECT *
                                      FROM (SELECT @Sockets AS Sockets) AS sockets))),
                 TRUE)
          AND IF(classes != '',
                 words.id IN (SELECT word_properties.word_id AS words
                              FROM word_properties
                                JOIN property_type
                                  ON property_type.id =
                                     word_properties.property_type_id
                                JOIN classes_property_type
                                  ON classes_property_type.property_type_id =
                                     property_type.id
                                JOIN classes
                                  ON classes.id = classes_property_type.class_id
                              WHERE find_in_set(cast(classes.id AS CHAR),
                                                classes)
                              GROUP BY word_properties.id), TRUE)
          AND
          IF(min_level < max_level,
             words.id IN (SELECT words.id AS words
                          FROM (SELECT words.id
                                FROM words
                                  INNER JOIN runes_order
                                    ON runes_order.runes_word_id
                                       = words.id
                                  INNER JOIN runes ON runes.id =
                                                      runes_order.rune_id
                                WHERE
                                  runes.lvl BETWEEN min_level AND max_level
                                  AND words.id NOT IN (
                                    SELECT words.id
                                    FROM (
                                           SELECT words.id
                                           FROM words
                                             INNER JOIN
                                             runes_order
                                               ON
                                                 runes_order.runes_word_id
                                                 = words.id
                                             INNER JOIN runes
                                               ON runes.id =
                                                  runes_order.rune_id
                                           WHERE
                                             runes.lvl < min_level OR
                                             runes.lvl > max_level
                                         ) AS words
                                  )
                                GROUP BY words.id) words), TRUE)
          AND IF(equipment != '',
                 words.id IN (SELECT words_equipment.runes_word_id AS words
                              FROM words_equipment
                                INNER JOIN equipment
                                  ON equipment.type_id =
                                     words_equipment.equipment_id
                              WHERE
                                find_in_set(cast(equipment.type_id AS CHAR),
                                            equipment)),
                 TRUE)
    INTO result;

  END$$

CREATE DEFINER=`root`@`%` PROCEDURE `selectWordsByRunes` (IN `runes_id` VARCHAR(255), OUT `result` VARCHAR(255))  BEGIN
    DROP TABLE IF EXISTS AllWordsRunesCount, SelectedWordsRunesCount, SelectedWordsByRunes;

    CREATE TEMPORARY TABLE AllWordsRunesCount (
      word_id    INT,
      rune_count INT
    );

    INSERT INTO AllWordsRunesCount (word_id, rune_count) SELECT
                                                           words.id AS id_word,
                                                           COUNT(*) AS rune_count
                                                         FROM words
                                                           INNER JOIN runes_order
                                                             ON runes_order.runes_word_id = words.id
                                                           INNER JOIN runes ON runes_order.rune_id = runes.id
                                                         GROUP BY words.id
                                                         HAVING COUNT(*) > 1;

    CREATE TEMPORARY TABLE SelectedWordsByRunes (
      word_id   INT,
      word_name VARCHAR(30),
      rune_id   INT,
      rune_name VARCHAR(30)
    );

    INSERT INTO SelectedWordsByRunes (word_id, word_name, rune_id, rune_name)
      SELECT
        words.id   AS id_word,
        words.name AS name_word,
        runes.id   AS id_rune,
        runes.name AS rune_name
      FROM words
        INNER JOIN runes_order
          ON runes_order.runes_word_id =
             words.id
        INNER JOIN runes
          ON runes_order.rune_id = runes.id
      WHERE find_in_set(cast(runes.id AS CHAR), runes_id);


    CREATE TEMPORARY TABLE SelectedWordsRunesCount (
      id    INT,
      count INT
    );

    INSERT INTO SelectedWordsRunesCount (id, count) SELECT
                                                      SelectedWordsByRunes.word_id,
                                                      count(SelectedWordsByRunes.rune_id) AS rune_count
                                                    FROM SelectedWordsByRunes
                                                    GROUP BY SelectedWordsByRunes.word_id
                                                    HAVING count(SelectedWordsByRunes.rune_id) > 1;

    SELECT group_concat(SelectedWordsRunesCount.id) AS word_id
    FROM SelectedWordsRunesCount
      INNER JOIN AllWordsRunesCount
        ON AllWordsRunesCount.word_id = SelectedWordsRunesCount.id
    WHERE AllWordsRunesCount.rune_count = SelectedWordsRunesCount.count
    INTO result;

    DROP TABLE IF EXISTS AllWordsRunesCount, SelectedWordsRunesCount, SelectedWordsByRunes;
  END$$

CREATE DEFINER=`root`@`%` PROCEDURE `selectWordsBySockets` (IN `sockets` VARCHAR(255), OUT `wordsBySockets` VARCHAR(255))  BEGIN

    DROP TABLE IF EXISTS wordsRunesCount;

    CREATE TEMPORARY TABLE wordsRunesCount (
      word_id        INT,
      count_of_runes INT
    );

    INSERT INTO wordsRunesCount (word_id, count_of_runes) SELECT
                                                            words.id                   AS word_id,
                                                            count(runes_order.rune_id) AS runes_count
                                                          FROM words
                                                            INNER JOIN runes_order
                                                              ON runes_order.runes_word_id = words.id
                                                          GROUP BY word_id;

    SELECT group_concat(wordsRunesCount.word_id)
    INTO wordsBySockets
    FROM wordsRunesCount
    WHERE find_in_set(cast(wordsRunesCount.count_of_runes AS CHAR), sockets);

    DROP TABLE IF EXISTS wordsRunesCount;
  END$$

DELIMITER ;

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
-- Структура таблицы `classes_property_type`
--

CREATE TABLE `classes_property_type` (
  `id` int(8) NOT NULL,
  `class_id` int(8) NOT NULL,
  `property_type_id` int(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `classes_property_type`
--

INSERT INTO `classes_property_type` (`id`, `class_id`, `property_type_id`) VALUES
(15, 1, 69),
(17, 1, 70),
(18, 1, 18),
(19, 2, 5),
(20, 3, 77),
(21, 3, 57),
(22, 3, 58),
(23, 3, 78),
(24, 3, 59),
(25, 1, 16),
(26, 4, 98),
(27, 4, 96),
(28, 4, 99),
(29, 4, 97),
(30, 4, 100),
(31, 5, 46);

-- --------------------------------------------------------

--
-- Структура таблицы `equipment`
--

CREATE TABLE `equipment` (
  `type_id` int(8) NOT NULL,
  `type_name` varchar(30) NOT NULL,
  `type_parent_id` int(8) DEFAULT NULL,
  `description` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `equipment`
--

INSERT INTO `equipment` (`type_id`, `type_name`, `type_parent_id`, `description`) VALUES
(1, 'ms', NULL, 'разнообразное снаряжение'),
(2, 'am', 1, 'амулет'),
(3, 'bk', 1, 'том'),
(4, 'cm', 1, 'талисман'),
(7, 'cg', 4, 'великий талисман'),
(8, 'ch', 4, 'талисмон сглаза'),
(9, 'cl', 4, 'большой талисман'),
(10, 'cn', 4, 'узкий талисман'),
(11, 'cq', 4, 'квадратный талисман'),
(12, 'cs', 4, 'маленький талисман'),
(13, 'ct', 4, 'высокий талисман'),
(14, 'gem', 1, 'камень'),
(15, 'jwl', 1, 'драгоценный камень'),
(16, 'ri', 1, 'кольцо'),
(17, 'we', NULL, 'оружие'),
(18, 'me', 17, 'контактное оружие'),
(19, 'ax', 18, 'топор'),
(20, 'ta', 19, 'метательный топор'),
(21, 'bl', 18, 'грубое оружие'),
(22, 'cb', 21, 'дубина'),
(23, 'ha', 21, 'молот'),
(24, 'ma', 21, 'скипетр'),
(25, 'ro', 21, 'магичический жезл'),
(26, 'sc', 25, 'скипетр'),
(27, 'st', 25, 'посох'),
(28, 'wa', 25, 'палочка'),
(29, 'cw', 18, 'когти'),
(30, 'ck', 18, 'нож'),
(31, 'tk', 30, 'метатательный нож'),
(32, 'or', 18, 'сфера'),
(33, 'po', 18, 'алебарда'),
(34, 'sp', 18, 'копье'),
(35, 'as', 34, 'амазон копье'),
(36, 'ja', 18, 'дротик'),
(37, 'aj', 36, 'амазон дротик'),
(38, 'sw', 18, 'меч'),
(39, 'th', 17, 'метательное оружие'),
(40, 'ja', 39, 'дротик'),
(41, 'aj', 40, 'амазон дротик'),
(42, 'ta', 39, 'метательный топор'),
(43, 'tk', 39, 'метатательный нож'),
(44, 'mi', 17, 'стрелковое оружие'),
(45, 'bo', 44, 'лук'),
(46, 'ab', 45, 'амазон лук'),
(47, 'xb', 44, 'арбалет'),
(48, 'ar', NULL, 'броня'),
(49, 'be', 48, 'пояс'),
(50, 'bt', 48, 'сапоги'),
(51, 'gl', 48, 'перчатки'),
(52, 'he', 48, 'шлем'),
(53, 'ci', 52, 'венок'),
(54, 'pe', 52, 'шкура другида'),
(55, 'ph', 52, 'примитивный шлем'),
(56, 'sh', 48, 'щит'),
(57, 'au', 56, 'золотой щит'),
(58, 'hd', 56, 'некро щит'),
(59, 'to', 48, 'торсовая броня');

-- --------------------------------------------------------

--
-- Структура таблицы `property_effect`
--

CREATE TABLE `property_effect` (
  `id` int(8) NOT NULL,
  `effect_type` char(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='contains property effects (positive or negative effect value)';

--
-- Дамп данных таблицы `property_effect`
--

INSERT INTO `property_effect` (`id`, `effect_type`) VALUES
(1, '+'),
(2, '-'),
(3, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `property_type`
--

CREATE TABLE `property_type` (
  `id` int(8) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `property_type`
--

INSERT INTO `property_type` (`id`, `name`) VALUES
(92, 'быстрее бег/ходьба'),
(85, 'Вас не могут заморозить'),
(38, 'вероятность нанесения смертельного удара'),
(93, 'вероятность нанести сокрушающий удар'),
(50, 'восстановление жизни'),
(87, 'восстановление после удара'),
(65, 'все резисты'),
(49, 'все умения'),
(68, 'высасывание жизни'),
(64, 'жизнь'),
(40, 'жизнь воруемая за удар'),
(35, 'заморозка'),
(91, 'запас выносливости'),
(102, 'защита'),
(60, 'защита (Основано на уровне персонажа - 2 за каждый уровень)'),
(6, 'защита врага'),
(67, 'защита монстров за удар'),
(80, 'защита от дальних атак'),
(31, 'здоровье'),
(82, 'золото от монстров'),
(39, 'игнорирует защиту цели'),
(63, 'ловкость'),
(33, 'магические повреждения'),
(76, 'максимальный запаса маны'),
(45, 'максимальный резист к молнии'),
(9, 'максимальный урон'),
(104, 'мана воруемая за удар'),
(53, 'маны после каждого убийства'),
(8, 'минимальный урон'),
(25, 'монстры не смогут лечиться'),
(96, 'навык Bone (Только для Некроманта)'),
(98, 'навык Bone Armor (Только для Некроманта)'),
(99, 'навык Bone Spear (Только для Некроманта)'),
(69, 'навык Bow (Только для Амазонки)'),
(71, 'навык Critical Strike (Только для Амазонки)'),
(70, 'навык Crossbow (Только для Амазонки)'),
(18, 'навык Dodge (только для Амазонки)'),
(77, 'навык Energy Shield (Только для Волшебницы)'),
(57, 'навык Fire Bolt (Только для Волшебницы)'),
(5, 'навык Frenzy (только для Варвара)'),
(46, 'навык Holy Shock (только для Паладина)'),
(58, 'навык Inferno (Только для Волшебницы)'),
(97, 'навык Poison(Только для Некроманта)'),
(100, 'навык Skeleton Mastery (Только для Некроманта)'),
(73, 'навык Slow Missiles (Только для Амазонки)'),
(78, 'навык Static Field (Только для Волшебницы)'),
(59, 'навык Warmth (Только для Волшебницы)'),
(16, 'навык лука и арбалета (только для Амазонки)'),
(19, 'навыки волшебницы'),
(72, 'нвавык Dodge (Только для Амазонки)'),
(56, 'огненные умения'),
(32, 'отброс'),
(66, 'повреждения'),
(24, 'при ударе обратить монстра в бегство'),
(52, 'радиус света'),
(84, 'регенерация маны'),
(28, 'резист к молнии'),
(27, 'резист к огню'),
(26, 'резист к холоду'),
(29, 'резист к яду'),
(3, 'рейтинг атаки'),
(55, 'рейтинг атаки против восставших'),
(54, 'рейтинг атаки против демонов'),
(51, 'сила'),
(4, 'скорость атаки'),
(103, 'скорость блокирования'),
(75, 'скорость наложения заклинаний'),
(22, 'требования'),
(88, 'удар заставляет монстров убегать'),
(89, 'удар ослепляет цель'),
(74, 'умения Волшебницы'),
(48, 'Уровень Chain Lightning (60 Зарядов)'),
(81, 'уровень Cloak of Shadows (9 Зарядов)'),
(36, 'уровень Corpse explosion'),
(47, 'уровень Corpse Explosion (12 Зарядов) '),
(94, 'Уровень Poison Explosion (27 Зарядов)'),
(95, 'Уровень Poison Nova (11 Зарядов)'),
(90, 'Уровень Weaken (18 Зарядов)'),
(1, 'урон'),
(42, 'урон молнией'),
(41, 'урон огнем'),
(10, 'урон по демонам'),
(11, 'урон по мертвецам'),
(34, 'урон холодом'),
(43, 'урон ядом'),
(30, 'урона идет в ману'),
(83, 'шанс блока'),
(86, 'шанс выпадения магических вещей'),
(37, 'шанс нанести открытые раны'),
(15, 'шанс открытой раны'),
(101, 'шанс прочитать заклинание уровня 1 Twister при попадании'),
(2, 'шанс сокрушительного удара'),
(61, 'энергия');

-- --------------------------------------------------------

--
-- Структура таблицы `property_value_type`
--

CREATE TABLE `property_value_type` (
  `id` int(8) NOT NULL,
  `value_type` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='contains type of property value (precenteges, integer numbers, seconds)';

--
-- Дамп данных таблицы `property_value_type`
--

INSERT INTO `property_value_type` (`id`, `value_type`) VALUES
(1, '%'),
(2, 'integer'),
(3, NULL);

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
  `runes_word_id` int(8) UNSIGNED NOT NULL,
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
  `id` int(8) UNSIGNED NOT NULL,
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
  `runes_word_id` int(8) UNSIGNED NOT NULL,
  `equipment_id` int(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `words_equipment`
--

INSERT INTO `words_equipment` (`id`, `runes_word_id`, `equipment_id`) VALUES
(1, 1, 22),
(2, 1, 23),
(4, 2, 18),
(5, 3, 24),
(6, 4, 18),
(7, 5, 38),
(8, 5, 26),
(9, 6, 27),
(10, 7, 18),
(11, 8, 39),
(12, 9, 27),
(13, 10, 17),
(14, 11, 38),
(15, 11, 19),
(16, 11, 22),
(17, 12, 18),
(18, 13, 17),
(19, 14, 28),
(20, 15, 39),
(21, 16, 52),
(22, 17, 52),
(23, 18, 52),
(24, 19, 56),
(25, 20, 56),
(26, 21, 59),
(27, 22, 59),
(28, 23, 59),
(29, 24, 59);

-- --------------------------------------------------------

--
-- Структура таблицы `word_properties`
--

CREATE TABLE `word_properties` (
  `id` int(8) NOT NULL,
  `word_id` int(8) UNSIGNED NOT NULL,
  `property_type_id` int(8) NOT NULL COMMENT 'property type id (damage to the undead e.t.c)',
  `property_effect_id` int(8) DEFAULT NULL COMMENT 'type of property effect (positive or negative)',
  `property_value_type_id` int(8) DEFAULT NULL COMMENT 'value type (percentages, \ninteger values, seconds)',
  `property_duration` int(8) DEFAULT NULL COMMENT 'seconds',
  `property_min_value` int(8) DEFAULT NULL,
  `property_max_value` int(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `word_properties`
--

INSERT INTO `word_properties` (`id`, `word_id`, `property_type_id`, `property_effect_id`, `property_value_type_id`, `property_duration`, `property_min_value`, `property_max_value`) VALUES
(1, 1, 1, 1, 1, NULL, 120, 120),
(2, 1, 93, NULL, 1, NULL, 40, 40),
(3, 1, 3, 1, 1, NULL, 200, 200),
(62, 1, 34, 1, 2, 3, 3, 14),
(63, 1, 31, 1, 2, NULL, 10, 10),
(64, 1, 4, NULL, 1, NULL, 15, 15),
(65, 1, 32, NULL, NULL, NULL, NULL, NULL),
(66, 1, 33, 1, 2, NULL, 2, 2),
(67, 1, 36, NULL, 2, NULL, 4, 4),
(68, 19, 102, 1, 1, NULL, 50, 50),
(69, 19, 26, 1, 1, NULL, 43, 43),
(70, 1, 27, 1, 1, NULL, 48, 48),
(71, 19, 28, 1, 1, NULL, 48, 48),
(72, 19, 29, 1, 1, NULL, 48, 48),
(73, 19, 30, 1, 1, NULL, 10, 10),
(74, 2, 1, 1, 1, NULL, 209, 209),
(75, 2, 4, 1, 1, NULL, 40, 40),
(76, 2, 25, 3, 3, NULL, NULL, NULL),
(77, 2, 37, 3, 1, NULL, 66, 66),
(78, 2, 38, 3, 1, NULL, 33, 33),
(79, 2, 39, 3, 3, NULL, NULL, NULL),
(80, 2, 6, 2, 1, NULL, 25, 25),
(81, 2, 3, 3, 1, NULL, 20, 20),
(82, 2, 40, 3, 1, NULL, 6, 6),
(83, 2, 5, 1, 1, NULL, 5, 5),
(84, 3, 1, 1, 1, NULL, 60, 60),
(85, 3, 6, 2, 1, NULL, 25, 25),
(86, 3, 41, 1, 2, NULL, 5, 30),
(87, 3, 42, 1, 2, NULL, 21, 110),
(88, 3, 43, 1, 2, 5, 75, 75),
(89, 3, 9, 1, 2, NULL, 10, 10),
(91, 3, 28, 1, 1, NULL, 60, 60),
(92, 3, 45, 1, 2, NULL, 5, 5),
(93, 3, 46, 1, 2, NULL, 3, 3),
(94, 3, 48, 3, 2, NULL, 7, 7),
(95, 4, 1, 1, 1, NULL, 160, 160),
(96, 4, 9, 1, 2, NULL, 9, 9),
(97, 4, 8, 1, 2, NULL, 9, 9),
(98, 4, 38, 3, 1, NULL, 25, 25),
(99, 4, 3, 1, 3, NULL, 250, 250),
(100, 4, 49, 1, 2, NULL, 1, 1),
(101, 4, 40, 3, 1, NULL, 7, 7),
(102, 4, 50, 1, 2, NULL, 10, 10),
(103, 4, 51, 1, 3, NULL, 10, 10),
(104, 4, 52, 1, 2, NULL, 1, 1),
(105, 1, 53, 1, 2, NULL, 2, 2),
(106, 5, 1, 1, 1, NULL, 100, 100),
(107, 5, 10, 1, 1, NULL, 100, 100),
(108, 5, 11, 1, 1, NULL, 50, 50),
(109, 5, 41, 1, 2, NULL, 5, 30),
(110, 5, 34, 1, 2, 3, 3, 14),
(111, 5, 3, 3, 2, NULL, 150, 150),
(112, 5, 54, 1, 2, NULL, 100, 100),
(113, 5, 55, 1, 2, NULL, 100, 100),
(114, 5, 40, 3, 1, NULL, 7, 7),
(115, 6, 41, 1, 2, NULL, 5, 30),
(116, 6, 56, 1, 2, NULL, 3, 3),
(117, 6, 57, 1, 2, NULL, 3, 3),
(118, 6, 58, 1, 2, NULL, 3, 3),
(119, 6, 59, 1, 2, NULL, 3, 3),
(120, 6, 53, 1, 2, NULL, 2, 2),
(121, 6, 60, 1, 2, NULL, 2, 198),
(122, 6, 26, 1, 1, NULL, 33, 33),
(123, 21, 1, 1, 1, NULL, 20, 20),
(124, 21, 22, 2, 1, NULL, 15, 15),
(125, 21, 51, 1, 2, NULL, 25, 25),
(126, 21, 61, 1, 2, NULL, 10, 10),
(127, 21, 31, 1, 2, NULL, 20, 20),
(128, 21, 63, 1, 2, NULL, 15, 15),
(129, 21, 64, 1, 2, NULL, 50, 50),
(130, 21, 65, 1, 2, NULL, 30, 30),
(131, 16, 49, 1, 2, NULL, 1, 1),
(132, 16, 61, 1, 2, NULL, 10, 10),
(133, 16, 53, 1, 2, NULL, 2, 2),
(134, 16, 28, 1, 1, NULL, 30, 30),
(135, 16, 66, 2, 2, NULL, 7, 7),
(136, 16, 52, 1, 2, NULL, 2, 2),
(137, 7, 1, 1, 1, NULL, 33, 33),
(138, 7, 9, 1, 2, NULL, 9, 9),
(139, 7, 37, 3, 1, NULL, 100, 100),
(140, 7, 6, 2, 1, NULL, 25, 25),
(141, 7, 67, 2, 2, NULL, 100, 100),
(142, 7, 25, 3, 3, NULL, NULL, NULL),
(143, 7, 3, 1, 2, NULL, 50, 50),
(144, 7, 68, 3, 3, NULL, 5, 5),
(145, 8, 1, 1, 1, NULL, 50, 50),
(146, 8, 11, 1, 1, NULL, 300, 300),
(147, 8, 69, 1, 2, NULL, 3, 3),
(148, 8, 70, 1, 2, NULL, 3, 3),
(149, 8, 71, 1, 2, NULL, 3, 3),
(150, 8, 18, 1, 2, NULL, 3, 3),
(151, 8, 73, 1, 2, NULL, 3, 3),
(152, 8, 4, 3, 1, NULL, 20, 20),
(153, 8, 63, 1, 2, NULL, 10, 10),
(154, 8, 32, 3, 3, NULL, NULL, NULL),
(155, 9, 74, 1, 2, NULL, 3, 3),
(156, 9, 75, 1, 1, NULL, 33, 33),
(157, 9, 76, 1, 1, NULL, 20, 20),
(158, 9, 77, 1, 2, NULL, 3, 3),
(159, 9, 78, 1, 2, NULL, 2, 2),
(160, 9, 61, 1, 2, NULL, 10, 10),
(161, 9, 31, 1, 2, NULL, 10, 10),
(162, 9, 8, 1, 2, NULL, 9, 9),
(163, 9, 6, 2, 1, NULL, 25, 25),
(164, 9, 33, 2, 1, NULL, 7, 7),
(165, 9, 102, 1, 1, NULL, 50, 50),
(166, 17, 102, 1, 1, NULL, 50, 50),
(167, 17, 102, 1, 2, NULL, 10, 10),
(168, 17, 80, 1, 2, NULL, 30, 30),
(169, 17, 81, 3, 2, NULL, 13, 13),
(170, 17, 53, 1, 2, NULL, 2, 2),
(171, 17, 51, 1, 2, NULL, 5, 5),
(172, 17, 82, 2, 1, NULL, 33, 33),
(173, 17, 52, 2, 2, NULL, 3, 3),
(174, 18, 102, 1, 1, NULL, 75, 75),
(175, 18, 80, 1, 2, NULL, 30, 30),
(176, 18, 61, 1, 2, NULL, 10, 10),
(177, 18, 31, 1, 2, NULL, 10, 10),
(178, 18, 30, 3, 1, NULL, 15, 15),
(179, 18, 33, 1, 2, NULL, 3, 3),
(180, 18, 76, 1, 2, NULL, 33, 33),
(181, 18, 66, 2, 2, NULL, 7, 7),
(182, 18, 52, 1, 2, NULL, 5, 5),
(183, 20, 83, 1, 1, NULL, 20, 20),
(184, 20, 103, 1, 1, NULL, 40, 40),
(185, 20, 65, 1, 2, NULL, 25, 25),
(186, 20, 84, 3, 1, NULL, 15, 15),
(187, 20, 85, 3, 3, NULL, NULL, NULL),
(188, 20, 82, 1, 1, NULL, 50, 50),
(189, 20, 86, 1, 1, NULL, 25, 25),
(190, 10, 1, 1, 1, NULL, 200, 200),
(191, 10, 11, 1, 1, NULL, 75, 75),
(192, 10, 22, 2, 1, NULL, 20, 20),
(193, 10, 4, 1, 1, NULL, 20, 20),
(194, 10, 55, 1, 2, NULL, 50, 50),
(195, 10, 49, 1, 2, NULL, 2, 2),
(196, 10, 65, 1, 2, NULL, 2, 2),
(197, 10, 87, 1, 1, NULL, 20, 20),
(198, 10, 104, 3, 1, NULL, 11, 11),
(199, 10, 88, 3, 1, NULL, 25, 25),
(200, 10, 89, 1, 2, NULL, 33, 33),
(201, 10, 53, 1, 2, NULL, 2, 2),
(202, 10, 86, 1, 1, NULL, 30, 30),
(203, 22, 102, 1, 1, NULL, 75, 75),
(204, 22, 80, 1, 2, NULL, 280, 280),
(205, 22, 65, 1, 2, NULL, 50, 50),
(206, 22, 87, 1, 1, NULL, 20, 20),
(207, 22, 90, 3, 2, NULL, 6, 6),
(208, 22, 61, 1, 2, NULL, 10, 10),
(209, 22, 52, 2, 2, NULL, 1, 1),
(210, 23, 33, 2, 2, NULL, 3, 3),
(211, 23, 63, 1, 2, NULL, 6, 6),
(212, 23, 91, 1, 2, NULL, 15, 15),
(213, 23, 29, 1, 1, NULL, 30, 30),
(214, 23, 84, 3, 1, NULL, 15, 15),
(215, 23, 92, 3, 1, NULL, 25, 25),
(216, 23, 75, 1, 1, NULL, 25, 25),
(217, 23, 87, 1, 1, NULL, 25, 25),
(218, 11, 1, 3, 1, NULL, 20, 20),
(219, 11, 8, 1, 2, NULL, 3, 3),
(220, 11, 9, 1, 2, NULL, 3, 3),
(221, 11, 3, 1, 2, NULL, 50, 50),
(222, 11, 37, 3, 1, NULL, 50, 50),
(223, 11, 4, 1, 1, NULL, 25, 25),
(224, 11, 53, 1, 2, NULL, 2, 2),
(225, 11, 52, 1, 2, NULL, 1, 1),
(226, 12, 1, 1, 1, NULL, 35, 35),
(227, 12, 93, 3, 1, NULL, 25, 25),
(228, 12, 40, 3, 1, NULL, 7, 7),
(229, 12, 53, 1, 2, NULL, 2, 2),
(230, 12, 51, 1, 2, NULL, 20, 20),
(231, 12, 31, 1, 2, NULL, 10, 10),
(232, 13, 88, 3, 1, NULL, 25, 25),
(233, 13, 25, 3, 3, NULL, NULL, NULL),
(234, 13, 39, 3, 3, NULL, NULL, NULL),
(235, 13, 104, 3, 1, NULL, 7, 7),
(236, 13, 94, 3, 2, NULL, 15, 15),
(237, 13, 95, 3, 2, NULL, 13, 13),
(238, 13, 43, 1, 2, 6, 273, 273),
(239, 24, 82, 1, 1, NULL, 300, 300),
(240, 24, 86, 1, 1, NULL, 100, 100),
(241, 24, 53, 1, 2, NULL, 2, 2),
(242, 24, 63, 1, 2, NULL, 10, 10),
(243, 14, 88, 3, 1, NULL, 25, 25),
(244, 14, 31, 1, 2, NULL, 10, 10),
(245, 14, 97, 1, 2, NULL, 3, 3),
(246, 14, 96, 1, 2, NULL, 3, 3),
(247, 14, 98, 1, 2, NULL, 3, 3),
(248, 14, 99, 1, 2, NULL, 2, 2),
(249, 14, 100, 1, 2, NULL, 4, 4),
(250, 14, 33, 2, 2, NULL, 4, 4),
(251, 14, 75, 1, 1, NULL, 20, 20),
(252, 14, 76, 1, 2, NULL, 13, 13),
(253, 15, 1, 1, 1, NULL, 33, 33),
(254, 15, 3, 1, 2, NULL, 66, 66),
(255, 15, 42, 1, 2, NULL, 1, 50),
(256, 15, 6, 2, 1, NULL, 25, 25),
(257, 15, 102, 1, 2, NULL, 25, 25),
(258, 15, 92, 1, 1, NULL, 25, 25),
(259, 15, 4, 1, 1, NULL, 25, 25),
(260, 15, 101, 3, 1, NULL, 7, 7);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `classes`
--
ALTER TABLE `classes`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `classes_property_type`
--
ALTER TABLE `classes_property_type`
  ADD PRIMARY KEY (`id`),
  ADD KEY `classes_property_type_classes_id_fk` (`class_id`),
  ADD KEY `classes_property_type_property_type_id_fk` (`property_type_id`);

--
-- Индексы таблицы `equipment`
--
ALTER TABLE `equipment`
  ADD PRIMARY KEY (`type_id`),
  ADD KEY `equipment_equipment_type_id_fk` (`type_parent_id`);

--
-- Индексы таблицы `property_effect`
--
ALTER TABLE `property_effect`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `property_type`
--
ALTER TABLE `property_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `property_type_name_uindex` (`name`);

--
-- Индексы таблицы `property_value_type`
--
ALTER TABLE `property_value_type`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `runes`
--
ALTER TABLE `runes`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `runes_order`
--
ALTER TABLE `runes_order`
  ADD PRIMARY KEY (`id`),
  ADD KEY `runes_order_runes_id_fk` (`rune_id`),
  ADD KEY `runes_order_words_id_fk` (`runes_word_id`);

--
-- Индексы таблицы `runes_rune_properties`
--
ALTER TABLE `runes_rune_properties`
  ADD PRIMARY KEY (`id`),
  ADD KEY `runes_rune_properties_runes_id_fk` (`rune_id`),
  ADD KEY `runes_rune_properties_rune_properties_id_fk` (`property_id`);

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
  ADD PRIMARY KEY (`id`),
  ADD KEY `words_equipment_words_id_fk` (`runes_word_id`),
  ADD KEY `words_equipment_equipment_type_id_fk` (`equipment_id`);

--
-- Индексы таблицы `word_properties`
--
ALTER TABLE `word_properties`
  ADD PRIMARY KEY (`id`),
  ADD KEY `word_properties_words_id_fk` (`word_id`),
  ADD KEY `word_properties_property_type_id_fk` (`property_type_id`),
  ADD KEY `word_properties_property_effect_id_fk` (`property_effect_id`),
  ADD KEY `word_properties_property_value_type_id_fk` (`property_value_type_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `classes`
--
ALTER TABLE `classes`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT для таблицы `classes_property_type`
--
ALTER TABLE `classes_property_type`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;
--
-- AUTO_INCREMENT для таблицы `property_effect`
--
ALTER TABLE `property_effect`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT для таблицы `property_type`
--
ALTER TABLE `property_type`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=105;
--
-- AUTO_INCREMENT для таблицы `property_value_type`
--
ALTER TABLE `property_value_type`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
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
  MODIFY `id` int(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;
--
-- AUTO_INCREMENT для таблицы `words_equipment`
--
ALTER TABLE `words_equipment`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;
--
-- AUTO_INCREMENT для таблицы `word_properties`
--
ALTER TABLE `word_properties`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=261;
--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `classes_property_type`
--
ALTER TABLE `classes_property_type`
  ADD CONSTRAINT `classes_property_type_classes_id_fk` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `classes_property_type_property_type_id_fk` FOREIGN KEY (`property_type_id`) REFERENCES `property_type` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `equipment`
--
ALTER TABLE `equipment`
  ADD CONSTRAINT `equipment_equipment_type_id_fk` FOREIGN KEY (`type_parent_id`) REFERENCES `equipment` (`type_id`) ON DELETE SET NULL;

--
-- Ограничения внешнего ключа таблицы `runes_order`
--
ALTER TABLE `runes_order`
  ADD CONSTRAINT `runes_order_runes_id_fk` FOREIGN KEY (`rune_id`) REFERENCES `runes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `runes_order_words_id_fk` FOREIGN KEY (`runes_word_id`) REFERENCES `words` (`id`);

--
-- Ограничения внешнего ключа таблицы `runes_rune_properties`
--
ALTER TABLE `runes_rune_properties`
  ADD CONSTRAINT `runes_rune_properties_rune_properties_id_fk` FOREIGN KEY (`property_id`) REFERENCES `rune_properties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `runes_rune_properties_runes_id_fk` FOREIGN KEY (`rune_id`) REFERENCES `runes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `words_equipment`
--
ALTER TABLE `words_equipment`
  ADD CONSTRAINT `words_equipment_equipment_type_id_fk` FOREIGN KEY (`equipment_id`) REFERENCES `equipment` (`type_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `words_equipment_words_id_fk` FOREIGN KEY (`runes_word_id`) REFERENCES `words` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `word_properties`
--
ALTER TABLE `word_properties`
  ADD CONSTRAINT `word_properties_property_effect_id_fk` FOREIGN KEY (`property_effect_id`) REFERENCES `property_effect` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `word_properties_property_type_id_fk` FOREIGN KEY (`property_type_id`) REFERENCES `property_type` (`id`),
  ADD CONSTRAINT `word_properties_property_value_type_id_fk` FOREIGN KEY (`property_value_type_id`) REFERENCES `property_value_type` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `word_properties_words_id_fk` FOREIGN KEY (`word_id`) REFERENCES `words` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
