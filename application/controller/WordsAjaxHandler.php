<?php

require_once APP . 'core/DBConnection.php';
require_once APP . 'model/runesModel.php';

class WordsAjaxHandler extends Controller {
    public $wordsByClassesAndSockets;
    public $wordsByRunes;
    public $wordsProperties;
    public $wordsRunes;
    public $wordsEquip;

    public function ajaxHandle() {

        $this->db = new DBConnection();
        $this->model = new RunesModel($this->db);

        $ajaxResult = $_POST;

        if (isset($ajaxResult['classes'])){
            $classes = $ajaxResult['classes'];
        } else $classes = null;

        if (isset($ajaxResult['sockets'])){
            $sockets = $ajaxResult['sockets'];
        } else $sockets = null;

        if (isset($ajaxResult['runes'])){
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
        } elseif ($socketsChecked && !$classesChecked){
            $this->wordsByClassesAndSockets = $this->model->getWordsBySockets($sockets);
//            var_dump($this->wordsByClassesAndSockets);//+
        }

        if ($runesChecked && !$consistChecked) {
            $this->wordsByRunes = $this->model->getWordsByRunes($runes);
//            var_dump($this->wordsByRunes);//+
        } elseif ($runesChecked && $consistChecked) {
            $this->wordsByRunes = $this->model->getWordConsistOfRunes($runes);
//            var_dump($this->wordsByRunes);//+
        } else {
            $this->wordsByRunes = $this->model->getAllWords();
        }

//        var_dump($this->model->getWordRunesByID('2'));

//        var_dump($this->wordsByRunes);
//        echo '
//
//';
//        var_dump($this->wordsByClassesAndSockets);
    }

}