<?php

require_once APP . 'core/DBConnection.php';
require_once APP . 'model/runesModel.php';

class WordsAjaxHandler extends Controller {
    public $wordsByClassesAndSockets;

    public function ajaxHandle() {

        $this->db = new DBConnection();
        $this->model = new RunesModel($this->db);

        $ajaxResult = $_POST;

//        var_dump($ajaxResult);

        if (array_key_exists('classes', $ajaxResult) && array_key_exists('sockets', $ajaxResult)) {
            $this->wordsByClassesAndSockets = $this->model->getWordsByClassAndSockets($ajaxResult['classes'], $ajaxResult['sockets']);
            var_dump($this->wordsByClassesAndSockets);
        }
//
//        if (array_key_exists('contains', $ajaxResult)) {
//            var_dump($ajaxResult['contains']);
//        }
    }
}