<?php

class Controller {
    /**
     * @var null Database Connection
     */
    protected $db = null;

    /**
     * @var null model
     */
    protected $model = null;

    /**
     * Whenever controller is created, open a database connection too and load "the model".
     * @param Model|null $model - model for current controller
     */
    function __construct($model = null) {
        if ($model == null) {
            return;
        } else {
            $this->loadModel($model);
        }
    }

    /**
     * Loads the "model".
     * @param Model $model
     * @return object model
     */
    public function loadModel(Model $model) {
        require_once APP . 'model/runesModel.php';
        // create new "model" (and pass the database connection)
        $this->model = $model;
    }

    public function console_log($data) {
        echo '<script>';
        echo 'console.log(' . json_encode($data) . ')';
        echo '</script>';
    }
}
