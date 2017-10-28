SELECT
  words.id,
  word_properties.property
FROM word_properties
  INNER JOIN words_word_properties ON word_properties.id = words_word_properties.runes_word_property_id
  INNER JOIN words ON words.id = words_word_properties.runes_word_id
WHERE find_in_set(cast(words.id AS CHAR), :words)