<?php

class Sockets extends Controller {
    const MAX_SOCKETS = 6;
    public $sockets;

    function __construct($model = null) {
        parent::__construct($model);

        $this->fillSockets();
    }

    private function fillSockets() {
        for ($i = 1; $i <= 6; $i++) {
            $this->sockets[$i] = [$i];
        }
    }
}