'use strict';

$(function () {

    $(document).ready(function () {
        formSubmitPreventDefault();
        levelFiltersValidation();
        resetFilters();
        resetWords();
    });

    function formSubmitPreventDefault() {
        $('form[name=runes-form]').submit(function (e) {
            e.preventDefault();
        });
    }

    function resetFilters() {
        var $resetFilters = $('#reset-filters');
        var $filters = $("input[name='runes[]'], [name='sockets[]'], [name='classes[]'], [name='equip_type[]']");
        var levelFilters = $("input[name='maxLevel'], [name='minLevel']");
        var levelsFiltersOutput = $("output[name='minLevelOutput'], [name='maxLevelOutput']");


        $resetFilters.click(function () {
            $filters.prop('checked', false);
            levelFilters.val(false);
            levelsFiltersOutput.val(false);
        });
    }

    function resetWords() {
        var $resetWordsButton = $("#reset-words");
        var $wordsWrapper = $("#words-wrapper");

        $resetWordsButton.click(function () {
            $wordsWrapper.empty();
        });
    }

    function levelFiltersValidation() {
        var $minLevelInput = $("input[type='range'][name='minLevel']");
        var $maxLevelInput = $("input[type='range'][name='maxLevel']");

        var $minLevelOutput = $("output[name='minLevelOutput']");
        var $maxLevelOutput = $("output[name='maxLevelOutput']");

        setMinLevelLimiter();
        setMaxLevelLimiter();

        function setMinLevelLimiter() {
            var previousMinLevel = $minLevelOutput.val();

            $minLevelInput.click(function () {
                previousMinLevel = this.value;
            }).change(function () {
                if (this.value > $maxLevelInput.val()) {
                    $(this).val(previousMinLevel);
                    $minLevelOutput.val(this.value);

                }
            });
        }

        function setMaxLevelLimiter() {
            var previousMaxLevel = $maxLevelInput.val();

            $maxLevelInput.click(function () {
                previousMaxLevel = this.value;
            }).change(function () {
                if (this.value < $minLevelInput.val()) {
                    $(this).val(previousMaxLevel);
                    $maxLevelOutput.val(this.value);
                }
            });
        }

    }

    window.sendFilterData = function sendFiltersData() {
        var data = $('form[name=runes-form]').serialize();

        $.ajax({
            method: "POST",
            url: url + "WordsAjaxHandler/ajaxHandle",
            data: data
        })
            .done(function (data) {
                if (data === 'error') {
                    appendNotFoundException();
                    return;
                }
                console.log(JSON.parse(data));
                appendFoundWords(JSON.parse(data));
            });
    };

    function appendFoundWords(words) {
        var $wordsWrapper = $('#words-wrapper');
        var source = $('#template').html();
        var template = Handlebars.compile(source);

        $wordsWrapper.html(template({items: words}));
    }

    function appendNotFoundException() {
        var $wordsWrapper = $('#words-wrapper');

        $wordsWrapper.html('<h1>Ничего не найдено!</h1>');
    }

});
