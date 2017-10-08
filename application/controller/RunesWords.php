<?php

class RunesWords extends Controller {

    public $words;
    public $wordsProperties;

    function __construct(RunesModel $model = null) {
        parent::__construct($model);
    }
}