'use strict';

$(function () {

    $(document).ready(function () {
        formSubmitPreventDefault();
        changeFiltersByCotsistOfFilter();
    });

    function formSubmitPreventDefault() {
        $('form[name=runes-form]').submit(function (e) {
            e.preventDefault();
        });
    }

    function changeFiltersByCotsistOfFilter() {
        var $contains = $('#contains');

        $contains.change(function () {
            if ($contains.prop('checked')) {
                changeSocketsAndClassesInputs(false);
            } else {
                changeSocketsAndClassesInputs(true);
            }
        });
    }

    function changeSocketsAndClassesInputs(disabled) {
        var $sockets = $("input[name='sockets[]']");
        var $classes = $("input[name='classes[]']");

        if (disabled === false) {
            $sockets.prop('disabled', true);
            $classes.prop('disabled', true);
        } else {
            $sockets.prop('disabled', false);
            $classes.prop('disabled', false);
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
                    appendExeption();
                    return;
                }
                // console.log();
                appendWords(JSON.parse(data));
            });
    };

    function appendWords(words) {
        var $wordsWrapper = $('#words-wrapper');

        console.log(words);

        var source = $('#template').html();
        var template = Handlebars.compile(source);

        $wordsWrapper.html(template({items: words}));
    }

    function appendExeption() {
        var $wordsWrapper = $('#words-wrapper');

        $wordsWrapper.html('<h1>Ничего не найдено!</h1>');
    }

});
