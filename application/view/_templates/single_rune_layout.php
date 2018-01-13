<?php for ($i = $counter; $i < $difficulty; $i++): ?>
    <div class="runes__item">
        <div class="runes__item-name">
            <?php echo $this->runesController->runesWithProperties[$i]->name; ?>
        </div>

        <input type="checkbox" value="<?php echo $this->runesController->runesWithProperties[$i]->id; ?>"
               id="<?php echo $this->runesController->runesWithProperties[$i]->name; ?>"
               name="runes[]">

        <label class="runes__item-image" for="<?php echo $this->runesController->runesWithProperties[$i]->name; ?>">
            <img src="<?php echo '/runes/' . $this->runesController->runesWithProperties[$i]->img_url . '.png'; ?>"
                 alt="<?php echo $this->runesController->runesWithProperties[$i]->name; ?>">
        </label>

        <div class="runes__item-lvl"><?php echo $this->runesController->runesWithProperties[$i]->lvl; ?></div>
        <div class="runes__item-weapon-property">
            <?php foreach ($this->runesController->runesWithProperties[$i]->properties->in_weapon as $key => $weaponProp): ?>
                <?php if (count($this->runesController->runesWithProperties[$i]->properties->in_weapon) - 1 == $key): ?>
                    <?php echo $weaponProp; ?>
                    <?php break; ?>
                <?php else: ?>
                    <?php echo $weaponProp; ?>
                    <?php echo ', '; ?>
                <?php endif; ?>
            <?php endforeach; ?>
        </div>

        <div class="runes__item-armour-property">
            <?php foreach ($this->runesController->runesWithProperties[$i]->properties->in_armour as $key => $armourProp): ?>
                <?php if (count($this->runesController->runesWithProperties[$i]->properties->in_armour) - 1 == $key): ?>
                    <?php echo $armourProp; ?>
                    <?php break; ?>
                <?php else: ?>
                    <?php echo $armourProp; ?>
                    <?php echo ', '; ?>
                <?php endif; ?>
            <?php endforeach; ?>
        </div>
    </div>
<?php endfor; ?>