/* eslint-disable no-undef */
$(document).ready(() => {
	function close_accordion_section($target) {
		// let $accordionContent = $('.accordion .accordion-section-content');

		$target.parent().find('.accordion-section-title').removeClass('active');
		$target.slideUp(300).removeClass('open');
	}

	$('.accordion-section-title').click(function (e) {
		// Grab current anchor value
		let currentAttrValue = $(this).attr('href');
		let currentSection = $(currentAttrValue);

		if ($(e.target).is('.active')){
			close_accordion_section($(e.target).parent().find('.accordion-section-content'));
		} else {
			// Add active class to section title
			$(this).addClass('active');
			// Open up the hidden content panel
			currentSection.slideDown(300).addClass('open');
			currentSection.css('display', 'flex');
		}

		e.preventDefault();
	});
});