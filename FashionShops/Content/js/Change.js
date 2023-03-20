$(function () {
	$('.form-holder').delegate("input", "focus", function () {
		$('.form-holder').removeClass("active-login");
		$(this).parent().addClass("active-login");
	});
});

$().ready(function () {
	$("#form_change_password").validate({
		onfocusout: false,
		onkeyup: false,
		onclick: false,
		rules: {
			"currentpassword": {
				required: true,
			},
			"newpassword": {
				required: true,
				minlength: 4
			}
		},
		messages: {
			"curentpassword": {
				required: "This field is required",
			},
			"newpassword": {
				required: "This field is required",
				minlength: "Please enter at least 4 characters"
			}
		}
	});
});

