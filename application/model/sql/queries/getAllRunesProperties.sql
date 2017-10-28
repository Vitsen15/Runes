SELECT
  runes.id AS rune_id,
  rune_properties.property,
  rune_properties.in_armour,
  rune_properties.in_weapon
FROM runes
  INNER JOIN runes_rune_properties ON runes_rune_properties.rune_id = runes.id
  JOIN rune_properties ON rune_properties.id = runes_rune_properties.property_id