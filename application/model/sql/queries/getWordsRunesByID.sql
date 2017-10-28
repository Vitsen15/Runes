SELECT
  words.id   AS word_id,
  runes.id   AS rune_id,
  runes.name AS rune_name,
  runes_order.rune_order
FROM words
  INNER JOIN runes_order ON runes_order.runes_word_id = words.id
  INNER JOIN runes ON runes.id = runes_order.rune_id
WHERE find_in_set(cast(words.id AS CHAR), :words)