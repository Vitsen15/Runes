SELECT group_concat(words.id) AS words
FROM (SELECT words.id
      FROM words
        INNER JOIN runes_order ON runes_order.runes_word_id = words.id
        INNER JOIN runes ON runes.id = runes_order.rune_id
      WHERE runes.lvl BETWEEN :min AND :max AND words.id NOT IN (
        SELECT words.id
        FROM (
               SELECT words.id
               FROM words
                 INNER JOIN runes_order ON runes_order.runes_word_id = words.id
                 INNER JOIN runes ON runes.id = runes_order.rune_id
               WHERE runes.lvl < :min OR runes.lvl > :max
             ) AS words
      )
      GROUP BY words.id) words