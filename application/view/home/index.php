<div class="container">
    <h2>Выберите параметры что бы получить нужные рунные слова(о)</h2>
    <form action="" name="runes-form">
        <h2>Выберите руны</h2>
        <div class="runes">
            <div class="runes__items-heading">
                <div>Checked</div>
                <div>Вид</div>
                <div>Название</div>
                <div>Уровень</div>
                <div>Свойство в оружии</div>
                <div>Свойство в броне</div>
            </div>
            <div class="runes__items-container">
                <?php foreach ($this->runesController->runesWithProperties as $rune): ?>
                    <div class="runes__item">

                        <input type="checkbox" value="<?php echo $rune->id; ?>" id="<?php echo $rune->name; ?>" name="runes[]">

                        <label class="runes__item-image" for="<?php echo $rune->name; ?>">
                            <img src="<?php echo '/runes/' . $rune->img_url . '.png'; ?>" alt="<?php echo $rune->name; ?>">
                        </label>

                        <div class="runes__item-name">
                            <?php echo $rune->name; ?>
                        </div>

                        <div class="runes__item-lvl"><?php echo $rune->lvl; ?></div>
                        <div class="runes__item-weapon-property">
                            <?php foreach ($rune->properties->in_weapon as $key => $weaponProp): ?>
                                <?php if (count($rune->properties->in_weapon) - 1 == $key): ?>
                                    <?php echo $weaponProp; ?>
                                    <?php break; ?>
                                <?php else: ?>
                                    <?php echo $weaponProp; ?>
                                    <?php echo ', '; ?>
                                <?php endif; ?>
                            <?php endforeach; ?>
                        </div>

                        <div class="runes__item-armour-property">
                            <?php foreach ($rune->properties->in_armour as $key => $armourProp): ?>
                                <?php if (count($rune->properties->in_armour) - 1 == $key): ?>
                                    <?php echo $armourProp; ?>
                                    <?php break; ?>
                                <?php else: ?>
                                    <?php echo $armourProp; ?>
                                    <?php echo ', '; ?>
                                <?php endif; ?>
                            <?php endforeach; ?>
                        </div>
                    </div>
                <?php endforeach; ?>
            </div>
        </div>

        <h2>Выберите количество сокетов</h2>
        <label for="2">2</label>
        <input type="checkbox" id="2" value="2" name="sockets[]">

        <label for="3">3</label>
        <input type="checkbox" id="3" value="3" name="sockets[]">

        <label for="4">4</label>
        <input type="checkbox" id="4" value="4" name="sockets[]">

        <label for="5">5</label>
        <input type="checkbox" id="5" value="5" name="sockets[]">

        <label for="6">6</label>
        <input type="checkbox" id="6" value="6" name="sockets[]">

        <h2>Выберите класс</h2>

        <?php foreach ($this->classesController->classes as $class): ?>
            <label for="<?php echo $class->name; ?>"><?php echo $class->name; ?></label>
            <input type="checkbox" id="<?php echo $class->name; ?>" name="classes[]"
                   value="<?php echo $class->id; ?>">
            <br>
        <?php endforeach; ?>


        <h2>Выберите уровень</h2>
        <div>
            <h2>Минимальный уровень</h2>
            <input type="range" name="minLevel" list="min-levels-list"
                   min="<?php echo $this->levelsController->levels[0]; ?>"
                   max="<?php echo end($this->levelsController->levels); ?>"
                   value="<?php echo $this->levelsController->levels[0]; ?>"
                   oninput="minLevelOutput.value = minLevel.value">
            <output name="minLevelOutput"><?php echo $this->levelsController->levels[0]; ?></output>
            <datalist id="min-levels-list">
                <?php foreach ($this->levelsController->levels as $level): ?>
                <option value="<?php echo $level; ?>">
                    <?php endforeach; ?>
            </datalist>
        </div>
        <div>
            <h2>Максимальный уровень</h2>
            <input type="range" name="maxLevel" list="min-levels-list"
                   min="<?php echo $this->levelsController->levels[0]; ?>"
                   max="<?php echo end($this->levelsController->levels); ?>"
                   value="<?php echo end($this->levelsController->levels); ?>"
                   oninput="maxLevelOutput.value = maxLevel.value">
            <output name="maxLevelOutput"><?php echo end($this->levelsController->levels); ?></output>
            <datalist id="min-levels-list">
                <?php foreach ($this->levelsController->levels as $level): ?>
                <option value="<?php echo $level; ?>">
                    <?php endforeach; ?>
            </datalist>
        </div>

        <h2>Выберите тип снаряжения</h2>
        <ul id="equip-tree">
            <?php $this->equipmentController->renderAllEquipment($this->equipmentController->equipment); ?>
        </ul>

        <button type="submit" onclick="sendFilterData()">Найти</button>
        <button id="reset-filters">Сбросить фильтры</button>
        <button id="reset-words">Сбросить найденые слова</button>
    </form>
    <div id="words-wrapper"></div>
</div>