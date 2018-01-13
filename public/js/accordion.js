jQuery(document).ready(function () {
	function close_accordion_section() {
		var $accordionContent = jQuery('.accordion .accordion-section-content');

		jQuery('.accordion .accordion-section-title').removeClass('active');
		$accordionContent.slideUp(300).removeClass('open');
	}

	jQuery('.accordion-section-title').click(function (e) {
		// Grab current anchor value
		var currentAttrValue = jQuery(this).attr('href');

		if (jQuery(e.target).is('.active')) {
			close_accordion_section();
		} else {

			// Add active class to section title
			jQuery(this).addClass('active');
			// Open up the hidden content panel
			jQuery('.accordion ' + currentAttrValue).slideDown(300).addClass('open');
		}

		e.preventDefault();
	});
});