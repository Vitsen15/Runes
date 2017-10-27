<?php

require_once APP . 'core/DBConnection.php';
require_once APP . 'model/runesModel.php';

class WordsAjaxHandler extends Controller {
    // Data from client filters
    private $runes;
    private $sockets;
    private $classes;
    private $minLevel;
    private $maxLevel;
    private $equipment;

    // Filters values
    private $wordsByRunes;
    private $wordsBySockets;
    private $wordsByClasses;
    private $wordsByLevels;
    private $wordsByEquipment;

    // Combined words id's by all filters
    private $uniqueWordsID;

    // Data to form response json
    private $wordsNames;
    private $wordsRunes;
    private $wordsEquip;
    private $wordsProperties;

    public $responseJSON;

    public function ajaxHandle() {
        $this->db = new DBConnection();
        $this->model = new RunesModel($this->db);

        $this->getClientFiltersData();

        $this->getAllFiltersData();

        $this->formResponseJSON();
    }

    /**
     * Creates JSON as result of all filters work and sent it to client
     */
    private function formResponseJSON() {
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
    private function collectDataForResponse() {
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
     * Saves filters data that comes from client
     */
    private function getClientFiltersData() {
        $ajaxResult = $_POST;

        if (isset($ajaxResult['runes'])) {
            $this->runes = $ajaxResult['runes'];
//            var_dump($this->runes);
        } else $this->runes = null;

        if (isset($ajaxResult['sockets'])) {
            $this->sockets = $ajaxResult['sockets'];
//            var_dump($this->sockets);
        } else $this->sockets = null;

        if (isset($ajaxResult['classes'])) {
            $this->classes = $ajaxResult['classes'];
//            var_dump($this->classes);
        } else $this->classes = null;

        if (isset($ajaxResult['minLevel'])) {
            $this->minLevel = $ajaxResult['minLevel'];
//            var_dump($this->minLevel);
        } else $this->minLevel = null;

        if (isset($ajaxResult['maxLevel'])) {
            $this->maxLevel = $ajaxResult['maxLevel'];
//            var_dump($this->maxLevel);
        } else $this->maxLevel = null;

        if (isset($ajaxResult['equip_type'])) {
            $this->equipment = $ajaxResult['equip_type'];
//            var_dump($this->equipment);
        }
    }

    private function getAllFiltersData() {

        if ($this->runes) {
            $this->wordsByRunes = $this->model->filterWordsByRunes($this->runes);
        } else $this->wordsByRunes = null;

        if ($this->classes) {
            $this->wordsByClasses = $this->model->filterWordsByClasses($this->classes);
        } else $this->wordsByClasses = null;

        if ($this->sockets) {
            $this->wordsBySockets = $this->model->filterWordsBySockets($this->sockets);
        } else $this->wordsBySockets = null;

        if ($this->minLevel && $this->maxLevel) {
            $this->wordsByLevels = $this->model->filterWordsByLevels($this->minLevel, $this->maxLevel);
        } else $this->wordsBySockets = null;

        if ($this->equipment) {
            $this->wordsByEquipment = $this->model->filterWordsByEquipment($this->equipment);
//            var_dump($this->wordsByEquipment);
        } else $this->wordsByEquipment = null;

    }

    /**
     * @return mixed of unique id's of filtered words by input filters
     */
    private function selectUniqueWordsIDFromFilters() {
        $filtersData = [];

        if (isset($this->wordsByRunes->words)) {
            $filtersData[] = explode(',', $this->wordsByRunes->words);
        }

        if (isset($this->wordsBySockets->words)) {
            $filtersData[] = explode(',', $this->wordsBySockets->words);
        }

        if (isset($this->wordsByClasses->words)) {
            $filtersData[] = explode(',', $this->wordsByClasses->words);
        }

        if (isset($this->wordsByLevels->words)) {
            $filtersData[] = explode(',', $this->wordsByLevels->words);
        }

        if (isset($this->wordsByEquipment->words)) {
            $filtersData[] = explode(',', $this->wordsByEquipment->words);
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
    private function getWordsNames(array $uniqueWords) {
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
    private function getWordsProperties(array $uniqueWords) {
        $wordsProperties = $this->model->getWordPropertiesByID($uniqueWords);
        $wordProperties = [];
        $formattedWordsProperties = [];

        foreach ($uniqueWords as $key => $wordId) {

            foreach ($wordsProperties as $property) {

                if ($property->id == $wordId) {
                    $wordProperties[] = $property->property;
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
    private function getWordsRunes(array $uniqueWords) {
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
    private function getWordsEquipment(array $uniqueWords) {
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
    private function combineWordsData(array $uniqueWords) {
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