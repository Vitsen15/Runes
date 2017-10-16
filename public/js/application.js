'use strict';

$(function () {

    $(document).ready(function () {
        formSubmitPreventDefault();
        resetFilters();
    });

    function formSubmitPreventDefault() {
        $('form[name=runes-form]').submit(function (e) {
            e.preventDefault();
        });
    }

    function resetFilters() {
        var $resetFilters = $('#reset-filters');
        var $filters = $("input[name='runes[]'], [name='sockets[]'], [name='classes[]']");

        console.log($filters);

        $resetFilters.click(function () {
            $filters.prop('checked', false);
        });
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
                    appendException();
                    return;
                }
                appendWords(JSON.parse(data));
            });
    };

    function appendWords(words) {
        var $wordsWrapper = $('#words-wrapper');
        var source = $('#template').html();
        var template = Handlebars.compile(source);

        $wordsWrapper.html(template({items: words}));
    }

    function appendException() {
        var $wordsWrapper = $('#words-wrapper');

        $wordsWrapper.html('<h1>Ничего не найдено!</h1>');
    }

});
