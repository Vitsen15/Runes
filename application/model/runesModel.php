<?php

require_once APP . 'model/model.php';

class RunesModel extends Model {
    public function getAllRunes() {
        $sql = "SELECT
                  runes.id,
                  runes.name,
                  runes.img_url,
                  runes.lvl
                FROM runes";
        $query = $this->db->prepare($sql);
        $query->execute();

        return $query->fetchAll();
    }

    public function getAllRunesProperties() {
        $sql = "SELECT
                  runes.id AS rune_id,
                  rune_properties.property,
                  rune_properties.in_armour,
                  rune_properties.in_weapon
                FROM runes
                  INNER JOIN runes_rune_properties ON runes_rune_properties.rune_id = runes.id
                  JOIN rune_properties ON rune_properties.id = runes_rune_properties.property_id";
        $query = $this->db->prepare($sql);
        $query->execute();

        return $query->fetchAll();
    }

    public function getClasses() {
        $sql = "SELECT
                  classes.id,
                  classes.name
                FROM classes";

        $query = $this->db->prepare($sql);
        $query->execute();

        return $query->fetchAll();
    }

    public function getLevels() {
        $sql = "SELECT DISTINCT runes.lvl
                FROM runes
                ORDER BY runes.lvl ASC";

        $query = $this->db->prepare($sql);
        $query->execute();

        return $query->fetchAll();
    }

//  ==================  Words filters  ============================
    public function getAllWords() {

        $sql = "SELECT
                  words.id AS word_id
                FROM words
                  INNER JOIN runes_order ON runes_order.runes_word_id = words.id
                  INNER JOIN runes ON runes.id = runes_order.rune_id";

        $query = $this->db->prepare($sql);
        $query->execute();
        return $query->fetchAll();
    }

    public function filterWordsByRunes(array $runes = null) {
        if ($runes == null) {
            return false;
        } else {
            asort($runes);
            $runesInQuery = implode(',', $runes);
        }

        $wordsByRunes = "CALL selectWordsByRunes(:id, @Result)";

        $query = $this->db->prepare($wordsByRunes);

        $query->bindParam(':id', $runesInQuery, PDO::PARAM_STR);
        $query->execute();
        $query->closeCursor();
        $words = $this->db->query("SELECT @Result as words")->fetch();

        return $words;
    }

    public function filterWordsByClasses(array $classes = null) {
        if ($classes == null) {
            return false;
        }

        $classesInQuery = implode(',', $classes);

        $sql = "SELECT group_concat(words.id) AS words
                FROM (SELECT words.id
                      FROM words
                        INNER JOIN words_word_properties ON words_word_properties.runes_word_id = words.id
                        INNER JOIN word_properties ON word_properties.id = words_word_properties.runes_word_property_id
                        INNER JOIN classes_word_properties ON classes_word_properties.runes_word_property_id = words_word_properties.id
                        INNER JOIN classes ON classes.id = classes_word_properties.class_id
                      WHERE find_in_set(cast(classes.id AS CHAR), :classes)
                      GROUP BY words.id) AS words";

        $query = $this->db->prepare($sql);
        $query->bindParam(':classes', $classesInQuery);
        $query->execute();

        return $query->fetch();
    }

    public function filterWordsBySockets(array $sockets = null) {
        if ($sockets == null) {
            return false;
        } else {
            asort($sockets);
            $socketsInQuery = implode(',', $sockets);
        }

        $wordsBySockets = "CALL selectWordsBySockets(:sockets, @Result)";

        $query = $this->db->prepare($wordsBySockets);

        $query->bindParam(':sockets', $socketsInQuery, PDO::PARAM_STR);
        $query->execute();
        $query->closeCursor();
        $words = $this->db->query("SELECT @Result as words")->fetch();

        return $words;
    }

    public function filterWordsByLevels(int $minLevel, int $maxLevel) {
        $sql = "SELECT group_concat(words.id) AS words FROM (SELECT
                   words.id
                 FROM words
                   INNER JOIN runes_order ON runes_order.runes_word_id = words.id
                   INNER JOIN runes ON runes.id = runes_order.rune_id
                 WHERE runes.lvl BETWEEN :min AND :max AND words.id NOT IN (
                   SELECT words.id
                   FROM (
                          SELECT words.id
                          FROM words
                            INNER JOIN runes_order ON runes_order.runes_word_id = words.id
                            INNER JOIN runes ON runes.id = runes_order.rune_id
                          WHERE runes.lvl < :min OR runes.lvl > :max
                        ) AS words
                 )
                 GROUP BY words.id) words";

        $query = $this->db->prepare($sql);

        $query->bindParam(':min', $minLevel, PDO::PARAM_INT);
        $query->bindParam(':max', $maxLevel, PDO::PARAM_INT);
        $query->execute();

        return $query->fetch();
    }

//  ======================  Words properties  =================================
    public function getWordsNamesByID(array $wordsId) {
        if ($wordsId == null) {
            return false;
        }

        $wordsIdInQuery = implode(',', $wordsId);

        $sql = "SELECT
                  words.id AS word_id,
                  words.name AS word_name
                FROM words
                WHERE find_in_set(cast(words.id AS CHAR), :words)";

        $query = $this->db->prepare($sql);
        $query->bindParam(':words', $wordsIdInQuery, PDO::PARAM_STR);
        $query->execute();

        return $query->fetchAll();
    }

    public function getWordsRunesByID($wordsId = null) {
        if ($wordsId == null) {
            return false;
        }

        $wordsIdInQuery = implode(',', $wordsId);

        $sql = "SELECT
                  words.id AS word_id,
                  runes.id   AS rune_id,
                  runes.name AS rune_name,
                  runes_order.rune_order
                FROM words
                  INNER JOIN runes_order ON runes_order.runes_word_id = words.id
                  INNER JOIN runes ON runes.id = runes_order.rune_id
                WHERE words.id IN (" . $wordsIdInQuery . ")";

        $query = $this->db->prepare($sql);
        $query->execute();
        return $query->fetchAll();
    }

    public function getWordPropertiesByID(array $wordsId = null) {
        if ($wordsId == null) {
            return false;
        }

        $wordsIdInQuery = implode(',', $wordsId);

        $sql = "SELECT
                  words.id,
                  word_properties.property
                FROM word_properties
                  INNER JOIN words_word_properties ON word_properties.id = words_word_properties.runes_word_property_id
                  INNER JOIN words ON words.id = words_word_properties.runes_word_id
                WHERE words.id IN (" . $wordsIdInQuery . ")";

        $query = $this->db->prepare($sql);
        $query->execute();
        return $query->fetchAll();
    }

    public function getWordsEquipmentByID(array $wordsId = null) {
        if ($wordsId == null) {
            return false;
        }

        $wordsIdInQuery = implode(',', $wordsId);

        $sql = "SELECT
                  words.id            AS word_id,
                  equipment.type_id   AS equipment_id,
                  equipment.description AS description
                FROM words
                  INNER JOIN words_equipment ON words_equipment.runes_word_id = words.id
                  INNER JOIN equipment ON equipment.type_id = words_equipment.equipment_id
                WHERE find_in_set(cast(words.id AS CHAR), :words)";

        $query = $this->db->prepare($sql);
        $query->bindParam(':words', $wordsIdInQuery, PDO::PARAM_STR);
        $query->execute();
        return $query->fetchAll();
    }
}
