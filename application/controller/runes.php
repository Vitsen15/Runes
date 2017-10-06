<?php


class Runes extends Controller {
    /**
     * PAGE: index
     */
    public $runes;
    public $runesProperties;
    public $weaponProperties;

    const WEAPON = 'is weapon';
    const ARMOUR = 'is armour';

    function __construct($model = null) {
        parent::__construct($model);

        $this->runes = $this->model->getAllRunes();
        $this->runesProperties = $this->model->getAllRunesProperties();
    }

    /**
     * This method check if the current
     * property has appropriate type
     *
     * @param $property - current property std object in loop
     * @param $rune - current rune std object in loop
     * @param string $inputPropertyType - type of displayed property
     * @return bool - returns true if the type of property is matched
     */
    private function checkIsProperty($property, $rune, string $inputPropertyType): bool {
        $propertyType = null;
        if($inputPropertyType == self::WEAPON){
            $propertyType = $property->in_weapon;
        } elseif ($inputPropertyType == self::ARMOUR){
            $propertyType = $property->in_armour;
        }

        if ($property->rune_id == $rune->id && $propertyType) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * This method check if the current rune has a more
     * than one property of given type
     *
     * @param array $property - current property std object in loop
     * @param int $runeID - current rune id in loop
     * @param int $currentProp - index of current property in array of std objects
     * @param string $inputPropertyType - required class constant for defining property type
     * @return bool - returns true if rune has next property of given type
     */
    private function checkNextProperty(array $property, int $runeID, int $currentProp, string $inputPropertyType): bool {
        if (count($property) - 1 == $currentProp) {
            return false;
        }

        $nextProp = $property[$currentProp + 1];

        $propertyType = null;
        if($inputPropertyType == self::WEAPON){
            $propertyType = $nextProp->in_weapon;
        } elseif ($inputPropertyType == self::ARMOUR){
            $propertyType = $nextProp->in_armour;
        }

        if ($runeID == $nextProp->rune_id && $propertyType) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * This method filter properties by a given type and format string for output
     *
     * @param $rune - current rune std object in loop
     * @param string $propertyType - type of displayed property
     * @return string - formatted string of given type property(ies)
     */
    public function getRuneProperty($rune, string $propertyType): string {
        $result = '';

        for ($i = 0; $i < count($this->runesProperties); $i++) {
            $runeID = $this->runesProperties[$i]->rune_id;
            if ($this->checkIsProperty($this->runesProperties[$i], $rune, $propertyType) && $this->checkNextProperty($this->runesProperties, $runeID, $i, $propertyType)) {
                $result .= $this->runesProperties[$i]->property . ', ';
            } elseif ($this->checkIsProperty($this->runesProperties[$i], $rune, $propertyType)) {
                $result .= $this->runesProperties[$i]->property;
            }
        }

        return $result;

    }

}
