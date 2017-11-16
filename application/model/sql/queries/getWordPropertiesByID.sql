SELECT
  word_properties.word_id,
  property_type.name,
  property_effect.effect_type,
  property_value_type.value_type,
  word_properties.property_duration AS duration,
  word_properties.property_min_value AS min,
  word_properties.property_max_value AS max
FROM word_properties
  JOIN property_type ON property_type.id = word_properties.property_type_id
  JOIN property_effect ON property_effect.id = word_properties.property_effect_id
  JOIN property_value_type ON property_value_type.id = word_properties.property_value_type_id
WHERE find_in_set(cast(word_properties.word_id AS CHAR), :words)