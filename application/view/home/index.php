<div class="container">
    <h2>Выберите параметры что бы получить нужные рунные слова(о)</h2>
    <form action="" name="runes-form">
        <fieldset name="runes">
            <legend>Выберите руны</legend>
            <table>
                <thead>
                <tr>
                    <td>Checked</td>
                    <td>Вид</td>
                    <td>Название</td>
                    <td>Уровень</td>
                    <td>Свойство в оружии</td>
                    <td>Свойство в броне</td>
                </tr>
                </thead>
                <tbody>
                <?php foreach ($this->runesController->runesWithProperties as $rune): ?>
                    <tr>
                        <td><input type="checkbox" value="<?php echo $rune->id; ?>" name="runes[]"></td>

                        <td>
                            <img src="<?php echo $rune->img_url; ?>" alt="<?php echo $rune->name; ?>">
                        </td>

                        <td>
                            <?php echo $rune->name; ?>
                        </td>

                        <td><?php echo $rune->lvl; ?></td>
                        <td>
                            <?php foreach ($rune->properties->in_weapon as $key => $weaponProp): ?>
                                <?php if (count($rune->properties->in_weapon) - 1 == $key): ?>
                                    <?php echo $weaponProp; ?>
                                    <?php break; ?>
                                <?php else: ?>
                                    <?php echo $weaponProp; ?>
                                    <?php echo ', '; ?>
                                <?php endif; ?>
                            <?php endforeach; ?>
                        </td>

                        <td>
                            <?php foreach ($rune->properties->in_armour as $key => $armourProp): ?>
                                <?php if (count($rune->properties->in_armour) - 1 == $key): ?>
                                    <?php echo $armourProp; ?>
                                    <?php break; ?>
                                <?php else: ?>
                                    <?php echo $armourProp; ?>
                                    <?php echo ', '; ?>
                                <?php endif; ?>
                            <?php endforeach; ?>
                        </td>

                    </tr>
                <?php endforeach; ?>
                </tbody>
            </table>
        </fieldset>

        <fieldset name="sockets">
            <legend>Выберите количество сокетов</legend>
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
        </fieldset>

        <fieldset name="classes">
            <legend>Выберите класс</legend>

            <?php foreach ($this->classesController->classes as $class): ?>
                <label for="<?php echo $class->name; ?>"><?php echo $class->name; ?></label>
                <input type="checkbox" id="<?php echo $class->name; ?>" name="classes[]"
                       value="<?php echo $class->id; ?>">
                <br>
            <?php endforeach; ?>
        </fieldset>

        <button type="submit" onclick="sendFilterData()">Найти</button>
        <button id="reset-filters">Сбросить фильтры</button>
    </form>
    <div id="words-wrapper">

    </div>
</div>