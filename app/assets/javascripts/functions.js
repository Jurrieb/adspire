$(function() {
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
		var value = $(this).parent().find('input[type="hidden"]').val();
		console.log(value);
		var toggle = value == 't' || value == 'f';

		if(toggle) {
			value = value == 't' ? 1 : 0;
		}

		$('#'+form_data+'_'+target).val(value);
		
		if(toggle) {
			$(this).find('button[value="'+value+'"]').addClass('active '+(value?'btn-success':'btn-danger'));
		}

		$(this).find('button').click(function() {
			$('#'+form_data+'_'+target).val($(this).val());
			
			if(toggle) {
				$(this).parent().find('button').removeClass('btn-success btn-danger');
				$(this).addClass($(this).val()==1?'btn-success':'btn-danger')
			}
		});
	});

});

// Feeds
// Fields
function toggleField(el) {
	$(el).prev().find('select > option:first-child').toggle();
	$(el).find('i').toggleClass('icon-plus icon-minus');
	$(el).prev().toggle();
	$(el).find('span').text($(el).find('i').hasClass('icon-plus')?'Use Field':'Remove Field');
}