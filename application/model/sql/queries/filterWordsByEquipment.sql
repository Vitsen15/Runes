SELECT group_concat(words.word_id) AS words
FROM (SELECT words_equipment.runes_word_id AS word_id
      FROM words_equipment
        INNER JOIN equipment ON equipment.type_id = words_equipment.equipment_id
      WHERE find_in_set(cast(equipment.type_id AS CHAR), :equipment)) AS words