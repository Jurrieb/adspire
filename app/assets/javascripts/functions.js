$(document).ready(function() {
	$('.dropdown-toggle').dropdown();
	
	// Notifications
	$('#notifications li > button.remove').click(function() {
		$(this).parent().slideUp('fast', function() { $(this).remove(); });

		return false;
	});


	// Form items
	// Radio buttons
	$('.btn-group[data-toggle="buttons-radio"]').each(function() {
		var form_data = $(this).parents('form').attr('data');
		var target = $(this).attr('data-target');
		var value = $(this).parent().find('input[type="hidden"]').val() == 't' ? 1 : 0;

		$('#'+form_data+'_'+target).val(value);
		$(this).find('button[value="'+value+'"]').addClass('active '+(value?'btn-success':'btn-danger'));

		$(this).find('button').click(function() {
			$('#'+form_data+'_'+target).val($(this).val());
			$(this).parent().find('button').removeClass('btn-success btn-danger');
			$(this).addClass($(this).val()==1?'btn-success':'btn-danger')
		});
	});
	// Checkboxes
	$('.btn-group[data-toggle="buttons-checkbox"]').each(function() {
		var form_data = $(this).parents('form').attr('data');
		var target = $(this).attr('data-target');
		var value = $(this).find('button.active').val();
		
		if($(form_data+'['+target+']').length == 0) {
			$(this).parent().prepend('<input type="hidden" name="'+form_data+'['+target+']" value=');
		}
	});
});