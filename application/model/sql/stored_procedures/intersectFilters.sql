DROP PROCEDURE IF EXISTS intersectFilters;
DELIMITER //

CREATE PROCEDURE intersectFilters(IN  runes     VARCHAR(255),
                                  IN  sockets   VARCHAR(255),
                                  IN  classes   VARCHAR(255),
                                  IN  min_level VARCHAR(255),
                                  IN  max_level VARCHAR(255),
                                  IN  equipment VARCHAR(255),
                                  OUT result    VARCHAR(255))
  BEGIN

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

  END //
DELIMITER ;