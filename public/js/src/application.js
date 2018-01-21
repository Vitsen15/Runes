/* eslint-disable no-console,no-undef */
'use strict';

$(document).ready(function () {
	formSubmitPreventDefault();
	levelFiltersValidation();
	equipmentSelectionHandler();
	resetFilters();
	resetWords();
});

function formSubmitPreventDefault() {
	$('form[name=runes-form]').submit(function (e) {
		e.preventDefault();
	});
}

function resetFilters() {
	let $resetFilters = $('#reset-filters');
	let $filters = $('input[name=\'runes[]\'], [name=\'sockets[]\'], [name=\'classes[]\'], [name=\'equip_type[]\']');
	let $maxLevelFilter = $('input[name=\'maxLevel\']');
	let $minLevelFilter = $('input[name=\'minLevel\']');
	let $maxLevelFilterOutput = $('output[name=\'maxLevelOutput\']');
	let $minLevelFilterOutput = $('output[name=\'minLevelOutput\']');


	$resetFilters.click(function () {
		$filters.prop('checked', false);
		$maxLevelFilter.val($maxLevelFilter.prop('max'));
		$minLevelFilter.val($maxLevelFilter.prop('min'));
		$maxLevelFilterOutput.val($maxLevelFilter.prop('max'));
		$minLevelFilterOutput.val($maxLevelFilter.prop('min'));
	});
}

function resetWords() {
	let $resetWordsButton = $('#reset-words');
	let $wordsWrapper = $('#words-wrapper');

	$resetWordsButton.click(function () {
		$wordsWrapper.empty();
	});
}

function levelFiltersValidation() {
	let $minLevelInput = $('input[type=\'range\'][name=\'minLevel\']');
	let $maxLevelInput = $('input[type=\'range\'][name=\'maxLevel\']');

	let $minLevelOutput = $('output[name=\'minLevelOutput\']');
	let $maxLevelOutput = $('output[name=\'maxLevelOutput\']');

	setMinLevelLimiter();
	setMaxLevelLimiter();

	function setMinLevelLimiter() {
		let previousMinLevel = $minLevelOutput.val();

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
		let previousMaxLevel = $maxLevelInput.val();

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

function equipmentSelectionHandler() {
	let $equipment = $('.equip-tree').find('li input[type=checkbox]');

	$equipment.on('click', function () {
		$(this).parent().parents('li').children('input[type=checkbox]').prop({'indeterminate': true, 'checked': false});

		let $children = $(this).parent().find('li input[type=checkbox]');
		let checkedState = $(this).prop('checked');

		$children.prop('checked', checkedState);
	});
}

window.sendFilterData = function sendFiltersData() {
	let data = $('form[name=runes-form]').serialize();

	$.ajax({
		method: 'POST',
		url: url + 'WordsAjaxHandler/ajaxHandle',
		data: data
	})
		.done(function (data) {
			if (data === 'error') {
				appendNotFoundException();
				return;
			}
			console.log(data);
			console.log(JSON.parse(data));
			appendFoundWords(JSON.parse(data));
		});
};

function appendFoundWords(words) {
	let $wordsWrapper = $('#words-wrapper');
	let source = $('#template').html();
	let template = Handlebars.compile(source);

	$wordsWrapper.html(template({items: words}));
}

function appendNotFoundException() {
	let $wordsWrapper = $('#words-wrapper');

	$wordsWrapper.html('<h1>Ничего не найдено!</h1>');
}