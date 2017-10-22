DROP PROCEDURE IF EXISTS selectWordsBySockets;

DELIMITER //
CREATE PROCEDURE selectWordsBySockets(IN  sockets        VARCHAR(255),
                                      OUT wordsBySockets VARCHAR(255))
  BEGIN

    DROP TABLE IF EXISTS wordsRunesCount, explode_table;

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

    CALL explode_str(sockets);

    SELECT group_concat(wordsRunesCount.word_id)
    INTO wordsBySockets
    FROM wordsRunesCount
    WHERE wordsRunesCount.count_of_runes IN (SELECT exploded_values
                                             FROM explode_table);

    DROP TABLE IF EXISTS wordsRunesCount, explode_table;
  END//

DELIMITER ;