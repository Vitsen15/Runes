<?php

require_once APP . 'core/DBConnection.php';
require_once APP . 'model/runesModel.php';

class WordsAjaxHandler extends Controller {
    public $wordsByClassesAndSockets;
    public $wordsByRunes;
    public $uniqueWords;
    public $wordsRunes;
    public $wordsEquip;
    public $wordsProperties;
    public $responseJSON;

    public function ajaxHandle() {

        $this->db = new DBConnection();
        $this->model = new RunesModel($this->db);

        $ajaxResult = $_POST;
// TODO: search follow syntax
//        $classes = $ajaxResult['classes']??null;

        if (isset($ajaxResult['classes'])) {
            $classes = $ajaxResult['classes'];
        } else $classes = null;

        if (isset($ajaxResult['sockets'])) {
            $sockets = $ajaxResult['sockets'];
        } else $sockets = null;

        if (isset($ajaxResult['runes'])) {
            $runes = $ajaxResult['runes'];
        } else $runes = null;

        $classesChecked = array_key_exists('classes', $ajaxResult);
        $socketsChecked = array_key_exists('sockets', $ajaxResult);
        $runesChecked = array_key_exists('runes', $ajaxResult);
        $consistChecked = array_key_exists('contains', $ajaxResult);

        if ($classesChecked && $socketsChecked) {
            $this->wordsByClassesAndSockets = $this->model->getWordsByClassesAndSockets($classes, $sockets);
//            var_dump($this->wordsByClassesAndSockets);//+
        } elseif ($classesChecked && !$socketsChecked) {
            $this->wordsByClassesAndSockets = $this->model->getWordsByClasses($classes);
//            var_dump($this->wordsByClassesAndSockets);//+
        } elseif ($socketsChecked && !$classesChecked) {
            $this->wordsByClassesAndSockets = $this->model->getWordsBySockets($sockets);
//            var_dump($this->wordsByClassesAndSockets);//+
        }

        if ($runesChecked && !$consistChecked) {
            $this->wordsByRunes = $this->model->getWordsByRunes($runes);
//            var_dump($this->wordsByRunes);//+
        } elseif ($runesChecked && $consistChecked) {
            $this->wordsByRunes = $this->model->getWordConsistOfRunes($runes);
//            var_dump($this->wordsByRunes);//+
        }
//        else {
//            $this->wordsByRunes = $this->model->getAllWords();
//            var_dump($this->wordsByRunes);//+
//        }

        $this->formResponseJSON();

    }

    private function formResponseJSON() {
        if (!$this->getFiltersData()){
            echo 'error';
            return;
        } else{
            $this->responseJSON['words'] ['words_runes'] = $this->wordsRunes;
            $this->responseJSON['words'] ['words_equipment'] = $this->wordsEquip;
            $this->responseJSON['words'] ['words_properties'] = $this->wordsProperties;

            echo json_encode($this->responseJSON, JSON_UNESCAPED_UNICODE);
        }
    }

    private function getFiltersData() {
        $this->uniqueWords = $this->selectUniqueWordsFromFilters($this->wordsByRunes, $this->wordsByClassesAndSockets);
        asort($this->uniqueWords);

        $this->wordsProperties = $this->getWordsProperties($this->uniqueWords);

        $this->wordsRunes = $this->getWordsRunes($this->uniqueWords);

        $this->wordsEquip = ($this->getWordsEquipment($this->uniqueWords));

        if (!$this->uniqueWords) {
            return false;
        } else {
            return true;
        }
    }


    /**
     * @param array $runesFilter - words id's filtered by runes
     * @param array $classesAndSocketsFilters - words id's filtered by classes and sockets
     * @return array of unique id's of filtered words by input filters
     */
    private function selectUniqueWordsFromFilters(array $runesFilter = null, array $classesAndSocketsFilters = null) {
        $runesFilterValues = [];
        $classesAndSocketsFiltersValues = [];

        if ($runesFilter) {

            foreach ($runesFilter as $word) {
                $runesFilterValues[] = $word->word_id;
            }
        }

        if ($classesAndSocketsFilters) {

            foreach ($classesAndSocketsFilters as $word) {
                $classesAndSocketsFiltersValues[] = $word->word_id;
            }
        }

        $uniqueWords = array_merge($runesFilterValues, $classesAndSocketsFiltersValues);

        return array_unique($uniqueWords);

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
                    $wordEquipment['idEquip_equip'][$equipment->equipment_id] = $equipment->equipment;
                    $wordEquipment['idEquip_sockets'][$equipment->equipment_id] = $equipment->sockets;
                }
            }
            $formattedWordEquipment[$wordId] = $wordEquipment;

            $wordEquipment = null;
        }

        return $formattedWordEquipment;

    }

}