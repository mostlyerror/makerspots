$(document).ready(function() {
	$('.help-text').on('click', '.link-toggle', function() {
		$('.signin, .signup').toggleClass('hide');
	});
});