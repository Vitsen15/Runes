<div class="container">
    <form action="" name="runes-form" class="accordion">
        <div class="runes accordion-section">
            <a class="accordion-section-title" href="#runes-accordion">Выберите руны</a>
            <div id="runes-accordion" class="runes__items-container accordion-section-content">
                <?php $counter = 0; ?>
                <?php $difficulty = 11; ?>
                <div class="normal-difficulty-runes">
                    <?php include APP . 'view/_templates/single_rune_layout.php'; ?>
                    <?php $counter += 11; ?>
                    <?php $difficulty += 11; ?>
                </div>

                <div class="hell-difficulty-runes">
                    <?php include APP . 'view/_templates/single_rune_layout.php'; ?>
                    <?php $counter += 11; ?>
                    <?php $difficulty += 11; ?>
                </div>

                <div class="nightmare-difficulty-runes">
                    <?php include APP . 'view/_templates/single_rune_layout.php'; ?>
                    <?php unset($counter); ?>
                    <?php unset($difficulty); ?>
                </div>
            </div>
        </div>

        <div class="filer accordion-section">
            <a class="accordion-section-title" href="#sockets-accordion">Выберите количество сокетов</a>
            <div id="sockets-accordion" class="accordion-section-content">
                <label for="2">2</label>
                <input type="checkbox" id="2" value="2" name="sockets[]">

                <br>

                <label for="3">3</label>
                <input type="checkbox" id="3" value="3" name="sockets[]">

                <br>

                <label for="4">4</label>
                <input type="checkbox" id="4" value="4" name="sockets[]">

                <br>

                <label for="5">5</label>
                <input type="checkbox" id="5" value="5" name="sockets[]">

                <br>

                <label for="6">6</label>
                <input type="checkbox" id="6" value="6" name="sockets[]">
            </div>
        </div>

        <div class="filer accordion-section">
            <a class="accordion-section-title" href="#classes-accordion">Выберите класс</a>

            <div id="classes-accordion" class="accordion-section-content">
                <?php foreach ($this->classesController->classes as $class): ?>
                    <label for="<?php echo $class->name; ?>"><?php echo $class->name; ?></label>
                    <input type="checkbox" id="<?php echo $class->name; ?>" name="classes[]"
                           value="<?php echo $class->id; ?>">
                    <br>
                <?php endforeach; ?>
            </div>
        </div>

        <div class="filer accordion-section">
            <a href="#levels-accordion" class="accordion-section-title">Выберите уровень</a>
            <div id="levels-accordion" class="accordion-section-content">
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
        </div>

        <div class="filer accordion-section">
            <a href="#equipment-accordion" class="accordion-section-title">Выберите тип снаряжения</a>
            <div id="equipment-accordion" class="accordion-section-content">
                <ul id="equip-tree">
                    <?php $this->equipmentController->renderAllEquipment($this->equipmentController->equipment); ?>
                </ul>
            </div>
        </div>

        <button type="submit" onclick="sendFilterData()">Найти</button>
        <button id="reset-filters">Сбросить фильтры</button>
        <button id="reset-words">Сбросить найденые слова</button>
    </form>
    <div id="words-wrapper"></div>
</div>