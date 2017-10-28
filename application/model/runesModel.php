<?php

require_once APP . 'model/model.php';

class RunesModel extends Model {
    public function getAllRunes() {
        $sql = file_get_contents('sql/queries/getAllRunes.sql', FILE_USE_INCLUDE_PATH);
        $query = $this->db->prepare($sql);
        $query->execute();

        return $query->fetchAll();
    }

    public function getAllRunesProperties() {
        $sql = file_get_contents('sql/queries/getAllRunesProperties.sql', FILE_USE_INCLUDE_PATH);
        $query = $this->db->prepare($sql);
        $query->execute();

        return $query->fetchAll();
    }

    public function getClasses() {
        $sql = file_get_contents('sql/queries/getClasses.sql', FILE_USE_INCLUDE_PATH);

        $query = $this->db->prepare($sql);
        $query->execute();

        return $query->fetchAll();
    }

    public function getLevels() {
        $sql = file_get_contents('sql/queries/getLevels.sql', FILE_USE_INCLUDE_PATH);;

        $query = $this->db->prepare($sql);
        $query->execute();

        return $query->fetchAll();
    }

    public function getEquipment() {
        $sql = file_get_contents('sql/queries/getEquipment.sql', FILE_USE_INCLUDE_PATH);;;

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

        $sql = file_get_contents('sql/queries/filterWordsByClasses.sql', FILE_USE_INCLUDE_PATH);

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
        $sql = file_get_contents('sql/queries/filterWordsByLevels.sql', FILE_USE_INCLUDE_PATH);

        $query = $this->db->prepare($sql);

        $query->bindParam(':min', $minLevel, PDO::PARAM_INT);
        $query->bindParam(':max', $maxLevel, PDO::PARAM_INT);
        $query->execute();

        return $query->fetch();
    }

    public function filterWordsByEquipment(array $equipment) {
        if ($equipment == null) {
            return false;
        } else {
            asort($equipment);
            $equipmentInQuery = implode(',', $equipment);
        }

        $EquipSQL = file_get_contents('sql/queries/getNestedEquipmentByClientFilters.sql', FILE_USE_INCLUDE_PATH);

        $equipQuery = $this->db->prepare($EquipSQL);

        $equipQuery->bindParam(':equip', $equipmentInQuery);
        $equipQuery->execute();
        $equipResult = $equipQuery->fetch();
        $equipQuery->closeCursor();

        if (isset($equipResult->children_nodes)) {
            $equipResult = explode(',', $equipResult->children_nodes);
            $equipResult = array_unique($equipResult);
            $equipResult = array_merge($equipResult, $equipment);// add selected item to searched
            $equipResult = implode(',', $equipResult);
        } else {
            $equipResult = $equipmentInQuery;
        }

        $wordsSQL = file_get_contents('sql/queries/filterWordsByEquipment.sql', FILE_USE_INCLUDE_PATH);

        $wordsQuery = $this->db->prepare($wordsSQL);
        $wordsQuery->bindParam(':equipment', $equipResult);
        $wordsQuery->execute();

        return $wordsQuery->fetch();
    }

//  ======================  Words properties  =================================
    public function getWordsNamesByID(array $wordsId) {
        if ($wordsId == null) {
            return false;
        }

        $wordsIdInQuery = implode(',', $wordsId);

        $sql = file_get_contents('sql/queries/getWordsNamesByID.sql', FILE_USE_INCLUDE_PATH);

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

        $sql = file_get_contents('sql/queries/getWordsRunesByID.sql', FILE_USE_INCLUDE_PATH);;

        $query = $this->db->prepare($sql);
        $query->bindParam(':words', $wordsIdInQuery);
        $query->execute();
        return $query->fetchAll();
    }

    public function getWordPropertiesByID(array $wordsId = null) {
        if ($wordsId == null) {
            return false;
        }

        $wordsIdInQuery = implode(',', $wordsId);

        $sql = file_get_contents('sql/queries/getWordPropertiesByID.sql', FILE_USE_INCLUDE_PATH);

        $query = $this->db->prepare($sql);
        $query->bindParam(':words', $wordsIdInQuery);
        $query->execute();
        return $query->fetchAll();
    }

    public function getWordsEquipmentByID(array $wordsId = null) {
        if ($wordsId == null) {
            return false;
        }

        $wordsIdInQuery = implode(',', $wordsId);

        $sql = file_get_contents('sql/queries/getWordsEquipmentByID.sql', FILE_USE_INCLUDE_PATH);

        $query = $this->db->prepare($sql);
        $query->bindParam(':words', $wordsIdInQuery, PDO::PARAM_STR);
        $query->execute();

        return $query->fetchAll();
    }
}
