<?php

class Equipment extends Controller {
    private $unstructuredEquipment;
    public $equipment;

    function __construct(RunesModel $model = null) {
        parent::__construct($model);
        $this->unstructuredEquipment = $this->model->getEquipment();
        $this->unstructuredEquipment = $this->resetResponseDBArrayIndex($this->unstructuredEquipment);
        $this->equipment = (object)$this->createTreeOfEquipmentTypes($this->unstructuredEquipment);
        $this->console_log((object)$this->equipment);
    }


    private function resetResponseDBArrayIndex(array $sourceArr) {
        $outPutArr = [];
        foreach ($sourceArr as $item) {
            $outPutArr[$item->type_id] = $item;
        }
        return $outPutArr;
    }

    private function createTreeOfEquipmentTypes($equipmentArr) {
        $tree = array();
        if (!empty($equipmentArr)) {
            foreach ($equipmentArr as &$equipment) {
                if ($equipment->type_parent_id === null) {
                    $tree[$equipment->type_id] = &$equipment;
                } else {
                    $equipmentArr[$equipment->type_parent_id]->{'children_types'}->{$equipment->type_id} = &$equipment;// - не понятно что эта хуйня делает
                }
            }
        }
        return $tree;
    }

    public function renderAllEquipment($array){
        foreach ($array as $equipment){
            include APP . 'view/_templates/equip_type.php';
        }
    }
}