<?php

class Filters extends Controller {
    private $runesController;
    private $socketsController;
    private $classesController;
    private $levelsController;
    private $equipmentController;

    private $runes;
    private $sockets;
    private $classes;
    private $levels;
    private $equipment;

    public $filters;

    function __construct($model = null) {
        parent::__construct($model);

        //load model and db connection
        require_once APP . 'core/DBConnection.php';
        require_once APP . 'model/runesModel.php';

        //load controllers
        require_once APP . 'controller/Runes.php';
        require_once APP . 'controller/Classes.php';
        require_once APP . 'controller/Sockets.php';
        require_once APP . 'controller/Levels.php';
        require_once APP . 'controller/Equipment.php';

        $this->db = new DBConnection();
        $this->model = new RunesModel($this->db);

        $this->runesController = new Runes($this->model);
        $this->socketsController = new Sockets();
        $this->classesController = new Classes($this->model);
        $this->levelsController = new Levels($this->model);
        $this->equipmentController = new Equipment($this->model);

        $this->runes = $this->runesController->runesWithProperties;
        $this->sockets = $this->socketsController->sockets;
        $this->classes = $this->classesController->classes;
        $this->levels = $this->levelsController->levels;
        $this->equipment = $this->equipmentController->equipment;

        $this->createFiltersObject();
    }

    private function createFiltersObject() {
        $this->filters['runes'] = $this->runes;
        $this->filters['sockets'] = $this->sockets;
        $this->filters['classes'] = (array)$this->classes;
        $this->filters['levels'] = $this->levels;
        $this->filters['equipment'] = $this->equipment;

        $this->filters = json_encode($this->filters, JSON_UNESCAPED_UNICODE);
    }

}