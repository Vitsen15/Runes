$(document).ready(function () {
	function close_accordion_section() {
		var $accordionContent = $('.accordion .accordion-section-content');

		$('.accordion .accordion-section-title').removeClass('active');
		$accordionContent.slideUp(300).removeClass('open');
	}

	$('.accordion-section-title').click(function (e) {
		// Grab current anchor value
		var currentAttrValue = $(this).attr('href');
		var currentSection = $('.accordion ' + currentAttrValue);

		if ($(e.target).is('.active')) {
			close_accordion_section();
		} else {
			close_accordion_section();
			// Add active class to section title
			$(this).addClass('active');
			// Open up the hidden content panel
			currentSection.slideDown(300).addClass('open');
			currentSection.css('display', 'flex');
		}

		e.preventDefault();
	});
});