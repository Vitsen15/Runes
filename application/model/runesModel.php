<?php

require_once APP . 'model/model.php';

class RunesModel extends Model {
    /**
     * Get all runes from database
     */
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

    /**
     * @return mixed
     */
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

    /**
     * get all classes
     */
    public function getClasses() {
        $sql = "SELECT
                  classes.id,
                  classes.name
                FROM classes";

        $query = $this->db->prepare($sql);
        $query->execute();

        return $query->fetchAll();
    }

    public function getWordsNamesByID(array $wordsId) {
        if ($wordsId == null) {
            return false;
        }

        $wordsIdInQuery = implode(',', $wordsId);

        $sql = "SELECT
                  words.id AS word_id,
                  words.name AS word_name
                FROM words
                WHERE words.id IN (" . $wordsIdInQuery . ")";

        $query = $this->db->prepare($sql);
        $query->execute();
        return $query->fetchAll();
    }

    /**
     * gets runes that form a runes word and their order
     * @param array|null $runes
     * @return mixed
     */
    public function getWordConsistOfRunes(array $runes = null) {

        if ($runes == null) {
            return false;
        } else {
            asort($runes);
            $runesInQuery = implode(',', $runes);
        }

        $sql = "SELECT word_runes.word_id
                FROM (SELECT
                        words.id   AS word_id,
                        words.name AS word_name,
                        runes.id   AS rune_id,
                        runes.name AS rune_name,
                        runes_order.rune_order
                      FROM words
                        INNER JOIN runes_order ON runes_order.runes_word_id = words.id
                        INNER JOIN runes ON runes.id = runes_order.rune_id) AS word_runes
                GROUP BY word_runes.word_id
                HAVING group_concat(word_runes.rune_id ORDER BY word_runes.rune_id SEPARATOR ',') = :runesInQuery";

        $query = $this->db->prepare($sql);
        $query->bindParam(':runesInQuery', $runesInQuery, PDO::PARAM_STR);
        $query->execute();

        return $query->fetchAll();
    }

    /**
     * get runes words that affect selected class properties
     * @param array $classes
     * @param array $sockets
     * @return mixed
     */
    public function getWordsByClassesAndSockets(array $classes = null, array $sockets = null) {
        if ($classes == null || $sockets == null) {
            return false;
        }

        $classesInQuery = implode(',', $classes);
        $socketsInQuery = implode(',', $sockets);

        $sql = "SELECT
                  words.id AS word_id
                FROM words
                  INNER JOIN words_word_properties ON words_word_properties.runes_word_id = words.id
                  INNER JOIN word_properties ON word_properties.id = words_word_properties.runes_word_property_id
                  INNER JOIN classes_word_properties ON classes_word_properties.runes_word_property_id = words_word_properties.id
                  INNER JOIN classes ON classes.id = classes_word_properties.class_id
                  INNER JOIN words_equipment ON words_equipment.runes_word_id = words.id
                  INNER JOIN equipment ON words_equipment.equipment_id = equipment.id
                WHERE classes.id IN (" . $classesInQuery . ") AND equipment.sockets IN (" . $socketsInQuery . ")
                GROUP BY word_id";

        $query = $this->db->prepare($sql);
        $query->execute();

        return $query->fetchAll();
    }

    /**
     * gets all runes words by gotten classes
     * @param array $classes
     * @return mixed
     */
    public function getWordsByClasses(array $classes = null) {
        if ($classes == null) {
            return false;
        }

        $classesInQuery = implode(',', $classes);

        $sql = "SELECT
                  words.id AS word_id
                FROM words
                  INNER JOIN words_word_properties ON words_word_properties.runes_word_id = words.id
                  INNER JOIN word_properties ON word_properties.id = words_word_properties.runes_word_property_id
                  INNER JOIN classes_word_properties ON classes_word_properties.runes_word_property_id = words_word_properties.id
                  INNER JOIN classes ON classes.id = classes_word_properties.class_id
                WHERE classes.id IN (" . $classesInQuery . ")
                GROUP BY word_id";

        $query = $this->db->prepare($sql);
        $query->execute();

        return $query->fetchAll();
    }

    public function getWordsBySockets(array $sockets = null) {
        if ($sockets == null) {
            return false;
        }

        $socketsInQuery = implode(',', $sockets);

        $sql = "SELECT
                  words.id AS word_id
                FROM words
                  INNER JOIN words_equipment ON words_equipment.runes_word_id = words.id
                  INNER JOIN equipment ON words_equipment.equipment_id = equipment.id
                WHERE equipment.sockets IN (" . $socketsInQuery . ")
                GROUP BY word_id";

        $query = $this->db->prepare($sql);
        $query->execute();

        return $query->fetchAll();
    }

    /**
     * @param array $runes
     * @return mixed
     */
    public function getWordsByRunes(array $runes = null) {
        if ($runes == null) {
            return false;
        }

        $runesInQuery = implode(',', $runes);

        $sql = "SELECT
                  words.id   AS word_id
                FROM words
                  INNER JOIN runes_order ON runes_order.runes_word_id = words.id
                  INNER JOIN runes ON runes.id = runes_order.rune_id
                WHERE runes.id IN (" . $runesInQuery . ")";

        $query = $this->db->prepare($sql);
        $query->execute();
        return $query->fetchAll();
    }

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
                  words.id AS word_id,
                  equipment.type_id AS equipment_id,
                  equipment.type_name AS equipment
                FROM words
                  INNER JOIN words_equipment ON words_equipment.runes_word_id = words.id
                  INNER JOIN equipment ON equipment.type_id = words_equipment.equipment_id
                WHERE words.id IN (" . $wordsIdInQuery . ")";

        $query = $this->db->prepare($sql);
        $query->execute();
        return $query->fetchAll();
    }

    public function getFilteredWordsByRunes($runes = null) {
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

        $resultQuery = $this->db->query("SELECT @Result as words")->fetch(PDO::FETCH_ASSOC);


        return $resultQuery;
    }

}
