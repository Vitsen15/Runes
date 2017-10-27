<ul data-type={<?php echo $equipment->type_name; ?>}>
    <li>
        <label for="<?php echo $equipment->type_name; ?>"><?php echo $equipment->description; ?></label>
        <input type="checkbox" id="<?php echo $equipment->type_name; ?>"
               name="equip_type[]"
               value="<?php echo $equipment->type_id; ?>">
        <?php if (isset($equipment->children_types)): ?>
            <?php $this->renderAllEquipment($equipment->children_types); ?>
        <?php endif; ?>
    </li>
    <br>
</ul>