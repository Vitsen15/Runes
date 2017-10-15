<?php

class Home extends Controller {

    public $runesController;
    public $classesController;

    /**
     * PAGE: index
     * This method handles what happens when you move to http://yourproject/home/index (which is the default page btw)
     */
    public function index() {
        //load model and db connection
        require_once APP . 'core/DBConnection.php';
        require_once APP . 'model/runesModel.php';
        require_once APP . 'controller/Runes.php';
        require_once APP . 'controller/Classes.php';
        require_once APP . 'controller/RunesWords.php';

        $this->db = new DBConnection();
        $this->model = new RunesModel($this->db);

        $this->runesController = new Runes($this->model);
        $this->classesController = new Classes($this->model);

        // load views
        require APP . 'view/_templates/header.php';
        require APP . 'view/home/index.php';
        require APP . 'view/_templates/footer.php';
    }

}
