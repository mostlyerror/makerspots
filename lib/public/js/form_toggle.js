$(document).ready(function() {
	// click handler
	$('.help-text').on('click', '.link-toggle', function() {
		$('.signin, .signup').toggleClass('hide');
	});
});