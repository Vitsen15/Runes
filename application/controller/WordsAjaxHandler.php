<?php

require_once APP . 'core/DBConnection.php';
require_once APP . 'model/runesModel.php';

class WordsAjaxHandler extends Controller
{
    // Data from client filters
    private $runesFromClient;
    private $socketsFromClient;
    private $classesFromClient;
    private $minLevelFromClient;
    private $maxLevelFromClient;
    private $equipmentFromClient;

    // Filtered words id
    private $wordsIdByRunes;
    private $wordsIdBySockets;
    private $wordsIdByClasses;
    private $wordsIdByLevels;
    private $wordsIdByEquipment;

    // Combined words id by all filters
    private $uniqueWordsID;

    // Data to form response json
    private $wordsNames;
    private $wordsRunes;
    private $wordsEquip;
    private $wordsProperties;

    public $responseJSON;

    public function ajaxHandle()
    {
        $this->db = new DBConnection();
        $this->model = new RunesModel($this->db);

        $this->getClientFiltersData();

        $this->getFiltersResults();

        $this->formResponseJSON();
    }

    /**
     * Saves filters data that comes from client
     */
    private function getClientFiltersData()
    {
        $ajaxResult = $_POST;

        $this->runesFromClient = isset($ajaxResult['runes']) ? $this->runesFromClient = $ajaxResult['runes'] : null;

        $this->socketsFromClient = isset($ajaxResult['sockets']) ? $ajaxResult['sockets'] : null;

        $this->classesFromClient = isset($ajaxResult['classes']) ? $ajaxResult['classes'] : null;

        $this->minLevelFromClient = isset($ajaxResult['minLevel']) ? $ajaxResult['minLevel'] : null;

        $this->maxLevelFromClient = isset($ajaxResult['maxLevel']) ? $ajaxResult['maxLevel'] : null;

        $this->equipmentFromClient = isset($ajaxResult['equip_type']) ? $ajaxResult['equip_type'] : null;
    }

    /**
     * Gets words id from DB by filters values from client
     */
    private function getFiltersResults()
    {
        $this->wordsIdByRunes = $this->runesFromClient ? $this->model->filterWordsByRunes($this->runesFromClient) : null;

        $this->wordsIdByClasses = $this->classesFromClient ? $this->model->filterWordsByClasses($this->classesFromClient) : null;

        $this->wordsIdBySockets = $this->socketsFromClient ? $this->model->filterWordsBySockets($this->socketsFromClient) : null;

        $this->wordsIdByLevels = ($this->minLevelFromClient && $this->maxLevelFromClient) ? $this->model->filterWordsByLevels($this->minLevelFromClient, $this->maxLevelFromClient) : null;

        $this->wordsIdByEquipment = $this->equipmentFromClient ? $this->model->filterWordsByEquipment($this->equipmentFromClient) : null;
    }

    /**
     * Creates JSON as result of all filters work and send it to client
     */
    private function formResponseJSON()
    {
        if (!$this->collectDataForResponse()) {
            echo 'error';
            return;
        } else {
            $this->responseJSON['words'] = $this->combineWordsData($this->uniqueWordsID);

            echo json_encode($this->responseJSON, JSON_UNESCAPED_UNICODE);
        }
    }

    /**
     * Tries to collect all data for response JSON
     * @return bool
     */
    private function collectDataForResponse()
    {
        $this->uniqueWordsID = $this->selectUniqueWordsIDFromFilters();

        if (!$this->uniqueWordsID) {
            return false;
        } else {
            asort($this->uniqueWordsID);

            $this->wordsNames = $this->getWordsNames($this->uniqueWordsID);

            $this->wordsProperties = $this->getWordsProperties($this->uniqueWordsID);

            $this->wordsRunes = $this->getWordsRunes($this->uniqueWordsID);

            $this->wordsEquip = ($this->getWordsEquipment($this->uniqueWordsID));

            return true;
        }
    }

    /**
     * @return mixed array of unique id's of filtered words by input filters
     * or false if not selected any filter
     */
    private function selectUniqueWordsIDFromFilters()
    {
        $filtersData = [];

        if (isset($this->wordsIdByRunes->words)) {
            $filtersData[] = explode(',', $this->wordsIdByRunes->words);
        }

        if (isset($this->wordsIdBySockets->words)) {
            $filtersData[] = explode(',', $this->wordsIdBySockets->words);
        }

        if (isset($this->wordsIdByClasses->words)) {
            $filtersData[] = explode(',', $this->wordsIdByClasses->words);
        }

        if (isset($this->wordsIdByLevels->words)) {
            $filtersData[] = explode(',', $this->wordsIdByLevels->words);
        }

        if (isset($this->wordsIdByEquipment->words)) {
            $filtersData[] = explode(',', $this->wordsIdByEquipment->words);
        }

        if (count($filtersData) === 1) {
            return $filtersData[0];
        } elseif (count($filtersData) === 0) {
            return false;
        } else {
            $uniqueWords = array_intersect(...$filtersData);
            return $uniqueWords;
        }
    }

    /**
     * @param array $uniqueWords filtered word's id
     * @return array of words names
     */
    private function getWordsNames(array $uniqueWords)
    {
        $wordsNames = $this->model->getWordsNamesByID($uniqueWords);
        $formattedWordsNames = [];

        foreach ($uniqueWords as $key => $wordId) {

            foreach ($wordsNames as $name) {

                if ($name->word_id == $wordId) {
                    $formattedWordsNames[$wordId] = $name->word_name;
                }
            }
        }

        return $formattedWordsNames;
    }

    /**
     * @param array $uniqueWords - filtered word's id
     * @return array of words properties where keys are words id and them values are arrays of properties
     */
    private function getWordsProperties(array $uniqueWords)
    {
        $wordsProperties = $this->model->getWordPropertiesByID($uniqueWords);
        $wordProperties = [];
        $formattedWordsProperties = [];

        foreach ($uniqueWords as $key => $wordId) {

            foreach ($wordsProperties as $property) {

                if ($property->word_id == $wordId) {

                    $propertyStr = $property->effect_type;

                    if (($property->max - $property->min) == 0) {

                        $propertyStr .= $property->min;
                    } else {

                        $propertyStr .= $property->min . ' - ' . $property->max;
                    }

                    if ($property->value_type == '%') {

                        $propertyStr .= $property->value_type . ' ';
                    }

                    $wordProperties[] = $propertyStr . " {$property->name}";
                }
            }

        $formattedWordsProperties[$wordId] = $wordProperties;
        $wordProperties = null;
    }

return $formattedWordsProperties;
}

/**
 * @param array $uniqueWords - filtered word's id
 * @return array of words runes where keys are words id's and them values are two arrays:
 * 1. first array contains runes order in witch keys are rune id and values are rune order in word.
 * 2. second array contains runes names in witch keys are rune id and values are rune name.
 */
private
function getWordsRunes(array $uniqueWords)
{
    $wordsRunes = $this->model->getWordsRunesByID($uniqueWords);
    $wordRunes = [];
    $formattedWordsRunes = [];

    foreach ($uniqueWords as $key => $wordId) {

        foreach ($wordsRunes as $rune) {

            if ($rune->word_id == $wordId) {
                $wordRunes['id_order'][$rune->rune_id] = $rune->rune_order;
                $wordRunes['id_name'][$rune->rune_id] = $rune->rune_name;
            }
        }

        $formattedWordsRunes[$wordId] = $wordRunes;
        $wordRunes = null;
    }

    return $formattedWordsRunes;
}

/**
 * @param array $uniqueWords - filtered word's id
 * @return array of word equipment where keys are words id's and them values are two arrays:
 * 1. first array contains equipment name in witch keys are equipment id and values are equipment name.
 * 2. second array contains equipment sockets in witch keys are equipment id and values are count of sockets.
 */
private
function getWordsEquipment(array $uniqueWords)
{
    $wordsEquipment = $this->model->getWordsEquipmentByID($uniqueWords);
    $wordEquipment = [];
    $formattedWordEquipment = [];

    foreach ($uniqueWords as $key => $wordId) {

        foreach ($wordsEquipment as $equipment) {

            if ($equipment->word_id == $wordId) {
                $wordEquipment['idEquip_equip'][$equipment->equipment_id] = $equipment->description;
            }
        }

        $formattedWordEquipment[$wordId] = $wordEquipment;
        $wordEquipment = null;
    }

    return $formattedWordEquipment;
}

/**
 * this method combines all data of words in one array to convert it to JSON
 * @param array $uniqueWords - filtered word's id
 * @return array of words and their properties, runes and equipment
 */
private
function combineWordsData(array $uniqueWords)
{
    $wordsArray = [];

    foreach ($uniqueWords as $key => $wordId) {
        $wordsArray[$this->wordsNames[$wordId]]['name'] = $this->wordsNames[$wordId];
        $wordsArray[$this->wordsNames[$wordId]]['id'] = $wordId;
        $wordsArray[$this->wordsNames[$wordId]]['properties'] = $this->wordsProperties[$wordId];
        $wordsArray[$this->wordsNames[$wordId]]['equipment'] = $this->wordsEquip[$wordId];
        $wordsArray[$this->wordsNames[$wordId]]['runes'] = $this->wordsRunes[$wordId];
    }

    return $wordsArray;
}

}