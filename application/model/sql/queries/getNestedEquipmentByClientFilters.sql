SELECT GROUP_CONCAT(children_nodes SEPARATOR ',') AS children_nodes
FROM (
       SELECT @Ids := (
         SELECT GROUP_CONCAT(`type_id` SEPARATOR ',')
         FROM `equipment`
         WHERE FIND_IN_SET(`type_parent_id`, @Ids)
       ) children_nodes
       FROM `equipment`
         JOIN (SELECT @Ids := :equip) temp1
       WHERE FIND_IN_SET(`type_parent_id`, @Ids)
     ) temp2