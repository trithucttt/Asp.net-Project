$(function () {
	$('.form-holder').delegate("input", "focus", function () {
		$('.form-holder').removeClass("active-login");
		$(this).parent().addClass("active-login");
	});
});

$().ready(function () {
	$("#form_login").validate({
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
				minlength: 4
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
			}
		}
	});
});

$("#rememberme").on('change', function () {
	if ($(this).is(':checked')) {
		$(this).attr('value', 'true');
	} else {
		$(this).attr('value', 'false');
	}
	let re = $('#rememberme').val();
	console.log(re);
});
