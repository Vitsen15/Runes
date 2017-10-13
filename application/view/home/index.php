<div class="container">
    <h2>Выберите параметры что бы получить нужное рунное слово</h2>
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
                <?php foreach ($this->runesController->runes as $rune): ?>
                    <?php $nextRune = next($this->runesController->runes); ?>
                    <tr>
                        <?php if (isset($nextRune->name) && $rune->name == $nextRune->name): ?>
                            <?php continue; ?>
                        <?php else:; ?>

                            <td><input type="checkbox" value="<?php echo $rune->id; ?>" name="runes[]"></td>
                            <td>
                                <label for="<?php echo $rune->id; ?>">
                                    <img src="<?php echo $rune->img_url; ?>" alt="<?php echo $rune->name; ?>">
                                </label>
                            </td>
                            <td>
                                <label for="<?php echo $rune->id; ?>">
                                    <?php echo $rune->name; ?>
                                </label>
                            </td>
                            <td><?php echo $rune->lvl; ?></td>


                            <td>
                                <?php echo $this->runesController->getRuneProperty($rune, Runes::WEAPON); ?>
                            </td>

                            <td>
                                <?php echo $this->runesController->getRuneProperty($rune, Runes::ARMOUR); ?>
                            </td>

                        <?php endif; ?>
                    </tr>
                <?php endforeach; ?>
                </tbody>
            </table>
            <label for="contains">Состоит из</label>
            <input type="checkbox" id="contains" name="contains" value="true">
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
    </form>
<!--    <table>-->
<!--        <thead>-->
<!--        <tr>-->
<!--            <td>Название</td>-->
<!--            <td>Предмет</td>-->
<!--            <td>Руны</td>-->
<!--            <td>Свойства</td>-->
<!--        </tr>-->
<!--        </thead>-->
<!--        <tbody>-->
<!--        --><?php //foreach ($this->runesWordsController->words as $words): ?>
<!--            <tr>-->
<!--                <td>--><?php //echo $words->word_name; ?><!--</td>-->
<!--                <td>--><?php //echo $words->equipment; ?><!-- (Сокеты: --><?php //echo $words->sockets; ?><!--)</td>-->
<!--                <td>Runes</td>-->
<!--                <td>Properties</td>-->
<!--            </tr>-->
<!--        --><?php //endforeach; ?>
<!--        </tbody>-->
<!--    </table>-->
    <div id="words-wrapper">
        <script id="words-template" type="text/x-handlebars-template">

        </script>
    </div>
</div>