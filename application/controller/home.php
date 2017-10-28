<?php

class Home extends Controller {

    public $runesController;
    public $classesController;
    public $levelsController;
    public $equipmentController;

    public function index() {
        //load model and db connection
        require_once APP . 'core/DBConnection.php';
        require_once APP . 'model/runesModel.php';

        //load controllers
        require_once APP . 'controller/Runes.php';
        require_once APP . 'controller/Classes.php';
        require_once APP . 'controller/Levels.php';
        require_once APP . 'controller/Equipment.php';

        $this->db = new DBConnection();
        $this->model = new RunesModel($this->db);

        $this->runesController = new Runes($this->model);
        $this->classesController = new Classes($this->model);
        $this->levelsController = new Levels($this->model);
        $this->equipmentController = new Equipment($this->model);

        // load views
        require APP . 'view/_templates/header.php';
        require APP . 'view/home/index.php';
        require APP . 'view/_templates/footer.php';
    }

}
