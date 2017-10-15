<?php

class Runes extends Controller {
    private $runes;
    private $runesProperties;
    public $runesWithProperties;

    function __construct(RunesModel $model = null) {
        parent::__construct($model);

        $this->runes = $this->model->getAllRunes();
        $this->runesProperties = $this->model->getAllRunesProperties();
        $this->runesWithProperties = $this->createStdObjectOfRunes();
    }

    /**
     * @return array of std objects of runes and their properties
     */
    public function createStdObjectOfRunes() {
        $runes = [];

        foreach ($this->runes as $key => $rune) {
            $runeObj = new stdClass();
            $props = [];

            $runeObj->{'id'} = $rune->id;
            $runeObj->{'name'} = $rune->name;
            $runeObj->{'img_url'} = $rune->img_url;
            $runeObj->{'lvl'} = $rune->lvl;

            foreach ($this->runesProperties as $property) {

                if ($rune->id === $property->rune_id){

                    if($property->in_weapon) {
                        $props['in_weapon'][] = $property->property;
                    }

                    if ($property->in_armour){
                        $props['in_armour'][] = $property->property;
                    }
                }
            }
            $runeObj->{'properties'} = (object) $props;
            $runes[] = $runeObj;
        }

        return $runes;
    }
}
