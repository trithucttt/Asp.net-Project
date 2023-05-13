$(function () {
	$('.form-holder').delegate("input", "focus", function () {
		$('.form-holder').removeClass("active-login");
		$(this).parent().addClass("active-login");
	});
});


