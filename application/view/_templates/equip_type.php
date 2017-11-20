
<?php if (isset($equipment->children_types)): ?>
    <li>
        <label for="<?php echo $equipment->type_name; ?>"><?php echo $equipment->description; ?></label>
        <input type="checkbox" id="<?php echo $equipment->type_name; ?>"
               name="equip_type[]"
               value="<?php echo $equipment->type_id; ?>">
        <?php if (isset($equipment->children_types)): ?>
            <ul data-type="<?php echo $equipment->type_name; ?>">
                <?php $this->renderAllEquipment($equipment->children_types); ?>
            </ul>
        <?php endif; ?>
    </li>
    <br>
<?php else: ?>
    <li data-type="<?php echo $equipment->type_name; ?>">
        <label for="<?php echo $equipment->type_name; ?>"><?php echo $equipment->description; ?></label>
        <input type="checkbox" id="<?php echo $equipment->type_name; ?>"
               name="equip_type[]"
               value="<?php echo $equipment->type_id; ?>">
    </li>
    <br>
<?php endif; ?>