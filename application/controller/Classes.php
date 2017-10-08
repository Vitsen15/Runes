<?php

class Classes extends Controller {
    public $model;
    public $classes;

    function __construct(RunesModel $model = null) {
        parent::__construct($model);

        $this->model = $model;
        $this->classes = $this->model->getClasses();
    }
}