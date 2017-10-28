SELECT group_concat(words.id) AS words
FROM (SELECT words.id
      FROM words
        INNER JOIN words_word_properties ON words_word_properties.runes_word_id = words.id
        INNER JOIN word_properties ON word_properties.id = words_word_properties.runes_word_property_id
        INNER JOIN classes_word_properties ON classes_word_properties.runes_word_property_id = words_word_properties.id
        INNER JOIN classes ON classes.id = classes_word_properties.class_id
      WHERE find_in_set(cast(classes.id AS CHAR), :classes)
      GROUP BY words.id) AS words