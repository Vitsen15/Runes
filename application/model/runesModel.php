<?php

include 'model.php';

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

    public function getAllRunesProperties() {
        $sql = "SELECT
                  runes.id as rune_id,
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
     * gets all words and appropriate equip for each word
     */
    public function getRunesWordsAndEquip() {
        $sql = "SELECT
                  words.name AS word_name,
                  equipment.name AS equipment,
                  equipment.sockets
                FROM words
                  INNER JOIN words_equipment ON words_equipment.id = words.id
                  INNER JOIN equipment ON words_equipment.equipment_id = equipment.id";
        $query = $this->db->prepare($sql);

        $query->execute();

        return $query->fetchAll();
    }

    /**
     * gets all words and their properties
     */
    public function getAllWordProperties() {
        $sql = "SELECT
                  words.id,
                  words.name,
                  word_properties.property
                FROM words
                  INNER JOIN words_word_properties ON words_word_properties.runes_word_id = words.id
                  INNER JOIN word_properties ON word_properties.id = words_word_properties.runes_word_property_id";

        $query = $this->db->prepare($sql);
        $query->execute();

        return $query->fetchAll();
    }

    /**
     * gets runes that form a runes word and their order
     */
    public function getWordsRunesOrder() {
        $sql = "SELECT
                  words.id AS wore_id,
                  words.name AS word_name,
                  runes.name AS rune_name,
                  runes_order.rune_order
                FROM words
                  INNER JOIN runes_order ON runes_order.runes_word_id = words.id
                  INNER JOIN runes ON runes_order.rune_id = runes.id";

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

    /**
     * get runes words that affect selected class properties
     * @param $class_id
     */
    public function getWordsForClass($class_id) {
        $sql = "SELECT
                  words.id as word_id,
                  words.name AS word_name,
                  classes.name,
                  word_properties.property
                FROM words
                  INNER JOIN words_word_properties ON words_word_properties.runes_word_id = words.id
                  INNER JOIN word_properties ON word_properties.id = words_word_properties.runes_word_property_id
                  INNER JOIN classes_word_properties ON classes_word_properties.runes_word_property_id = words_word_properties.id
                  INNER JOIN classes ON classes.id = classes_word_properties.class_id
                WHERE classes.id = :class_id";

        $query = $this->db->prepare($sql);
        $parameters = array(':class_id' => $class_id);
        $query->execute();

        return $query->fetchAll();
    }

}
