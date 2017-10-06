<div class="container">
    <h2>Select parameters to find rune word</h2>
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
<!--        --><?php //var_dump($this->runes->runes); ?>
        <?php foreach ($this->runesController->runes as $rune): ?>
            <?php $nextRune = next($this->runesController->runes); ?>
            <tr>
                <?php if (isset($nextRune->name) && $rune->name == $nextRune->name): ?>
                    <?php continue; ?>
                <?php else:; ?>

                    <td><input type="checkbox" value="<?php echo $rune->id; ?>"></td>
                    <td><img src="<?php echo $rune->img_url; ?>" alt="<?php echo $rune->name; ?>"></td>
                    <td><?php echo $rune->name; ?></td>
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
</div>