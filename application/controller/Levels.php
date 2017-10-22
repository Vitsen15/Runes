<?php

class Levels extends Controller {
    public $levels;
    private $stdArrayLevels;

    function __construct(RunesModel $model = null) {
        parent::__construct($model);

        $this->model = $model;
        $this->addLevelsToArray();
    }

    /**
     * Converts model response data to indexed array
     */
    private function addLevelsToArray() {
        $this->stdArrayLevels = $this->model->getLevels();
        $levelsArray = [];

        foreach ($this->stdArrayLevels as $level) {
            $levelsArray[] = $level->lvl;
        }

        $this->levels = $levelsArray;
    }
}