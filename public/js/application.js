$(function () {

    $(document).ready(function () {
        limitSelectedRunesCount();

        $('form[name=runes-form]').submit(function (e) {
            e.preventDefault();
        });
    });

    function limitSelectedRunesCount() {
        $("input[name='runes[]']").change(function () {
            var maxAllowed = 6;
            var cnt = $("input[name='runes[]']:checked").length;
            if (cnt > maxAllowed) {
                $(this).prop("checked", "");
                alert('You may select maximum ' + maxAllowed + ' runes!');
            }
        });
    }

    window.sendFilterData = function sendFiltersData() {

        var data = $('form[name=runes-form]').serialize();
        // alert(data);

        $.ajax({
            method: "POST",
            url: url + "WordsAjaxHandler/ajaxHandle",
            data: data
        })
            .done(function (data) {
                console.log("Data Saved: " + data);
            });
    }

});
