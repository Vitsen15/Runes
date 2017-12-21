DROP PROCEDURE IF EXISTS selectWordsByRunes;
DELIMITER //

CREATE PROCEDURE selectWordsByRunes(IN  runes_id VARCHAR(255),
                                    OUT result   VARCHAR(255))
  BEGIN
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
  END//
DELIMITER ;