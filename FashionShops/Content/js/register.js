$(function () {
	$('.form-holder').delegate("input", "focus", function () {
		$('.form-holder').removeClass("active-login");
		$(this).parent().addClass("active-login");
	});
});

$().ready(function () {
	$("#form_register").validate({
		onfocusout: false,
		onkeyup: false,
		onclick: false,
		rules: {
			"username": {
				required: true,
				maxlength: 15
			},
			"password": {
				required: true,
				minlength: 4,
			},
			"email": {
				required: true,
				email:true
			},
			"confirm_password": {
				required: true,
				equalTo: "#password",
            }
		},
		messages: {
			"username": {
				required: "This field is required",
				maxlength: "Please enter up to 15 characters"
			},
			"password": {
				required: "This field is required",
				minlength: "Please enter at least 4 characters"
			},
			"email": {
				required: "This field is required",
				email: "Email must be in the correct format"
			},
			"confirm_password": {
				required: "This field is required",
				equalTo: "Password is not match."
            }
		}
	});
});

