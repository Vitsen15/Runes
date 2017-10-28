SELECT
  words.id   AS word_id,
  words.name AS word_name
FROM words
WHERE find_in_set(cast(words.id AS CHAR), :words)