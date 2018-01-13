<!-- define the project's URL (to make AJAX calls possible, even when using this in sub-folders etc) -->
<script>
    var url = "<?php echo URL; ?>";
</script>

<script id="template" type="text/x-handlebars-template">
    <table>
        <thead>
        <tr>
            <td>Название</td>
            <td>Предмет</td>
            <td>Руны</td>
            <td>Свойства</td>
        </tr>
        </thead>
        <tbody>
        {{#each items.words}}
        <tr>
            <td>{{name}}</td>
            <td>
                {{#each equipment.idEquip_equip}}
                    {{this}}<br>
                {{/each}}
            </td>
            <td>
                {{#each runes.id_name}}
                    {{this}} {{#if @last}} {{break}} {{else}} + {{/if}}
                {{/each}}
            </td>
            <td>
                {{#each properties}}
                    {{this}}<br>
                {{/each}}
            </td>
        </tr>
        {{/each}}
        </tbody>
    </table>
</script>

<!-- our JavaScript -->
<script src="<?php echo URL; ?>libs/jquery-3.2.1.js"></script>
<script src="<?php echo URL; ?>libs/handlebars-v4.0.10.js"></script>
<script src="<?php echo URL; ?>js/min/application.js"></script>
<script src="<?php echo URL; ?>js/min/accordion.js""></script>
</body>
</html>
