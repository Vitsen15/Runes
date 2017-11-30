SELECT group_concat(words.id) AS words
FROM (SELECT word_properties.id
      FROM word_properties
        JOIN property_type ON property_type.id = word_properties.property_type_id
        JOIN classes_property_type ON classes_property_type.property_type_id = property_type.id
        JOIN classes ON classes.id = classes_property_type.class_id
      WHERE find_in_set(cast(classes.id AS CHAR), :classes)
      GROUP BY word_properties.id) AS words