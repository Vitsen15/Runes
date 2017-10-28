SELECT
  words.id              AS word_id,
  equipment.type_id     AS equipment_id,
  equipment.description AS description
FROM words
  INNER JOIN words_equipment ON words_equipment.runes_word_id = words.id
  INNER JOIN equipment ON equipment.type_id = words_equipment.equipment_id
WHERE find_in_set(cast(words.id AS CHAR), :words)