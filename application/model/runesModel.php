<?php

require_once APP . 'model/model.php';

class RunesModel extends Model
{
    public function getAllRunes()
    {
        $sql = file_get_contents('sql/queries/getAllRunes.sql', FILE_USE_INCLUDE_PATH);
        $query = $this->db->prepare($sql);
        $query->execute();

        return $query->fetchAll();
    }

    public function getAllRunesProperties()
    {
        $sql = file_get_contents('sql/queries/getAllRunesProperties.sql', FILE_USE_INCLUDE_PATH);
        $query = $this->db->prepare($sql);
        $query->execute();

        return $query->fetchAll();
    }

    public function getClasses()
    {
        $sql = file_get_contents('sql/queries/getClasses.sql', FILE_USE_INCLUDE_PATH);

        $query = $this->db->prepare($sql);
        $query->execute();

        return $query->fetchAll();
    }

    public function getLevels()
    {
        $sql = file_get_contents('sql/queries/getLevels.sql', FILE_USE_INCLUDE_PATH);;

        $query = $this->db->prepare($sql);
        $query->execute();

        return $query->fetchAll();
    }

    public function getEquipment()
    {
        $sql = file_get_contents('sql/queries/getEquipment.sql', FILE_USE_INCLUDE_PATH);;;

        $query = $this->db->prepare($sql);
        $query->execute();

        return $query->fetchAll();
    }

//  ==================  Filtration  ============================================
    public function combineFilters(stdClass $filters)
    {
        $wordsByRunes = "CALL intersectFilters(:runes, :sockets, :classes, :minLevel, :maxLevel, :equipment, @Result)";

        $query = $this->db->prepare($wordsByRunes);

        $query->bindParam(':runes', $filters->runes, PDO::PARAM_STR);
        $query->bindParam(':sockets', $filters->sockets, PDO::PARAM_STR);
        $query->bindParam(':classes', $filters->classes, PDO::PARAM_STR);
        $query->bindParam(':minLevel', $filters->minLevel, PDO::PARAM_STR);
        $query->bindParam(':maxLevel', $filters->maxLevel, PDO::PARAM_STR);
        $query->bindParam(':equipment', $filters->equipment, PDO::PARAM_STR);
        $query->execute();
        $query->closeCursor();
        $words = $this->db->query("SELECT @Result as words")->fetch();

        return $words;
    }

//  ======================  Words attributes  =================================
    public function getWordsNamesByID(array $wordsId)
    {
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

    public function getWordsRunesByID($wordsId = null)
    {
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

    public function getWordPropertiesByID(array $wordsId = null)
    {
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

    public function getWordsEquipmentByID(array $wordsId = null)
    {
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
