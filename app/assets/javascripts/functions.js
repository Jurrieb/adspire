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
				$(this).addClass($(this).val()==1?'btn-success':'btn-danger');
			}
		});
	});


	// Feeds
	// New feed
	$('.btn-group[data-target="method_type"] > button').click(function() {
		if(!$(this).hasClass('active')) {
			$(this).parents('form').find('div.'+$(this).val()).toggle();
			$(this).parents('form').find('div.'+$(this).prev().val()).hide();
			$(this).parents('form').find('div.'+$(this).next().val()).hide();
		}
	});

	// Feeds fields, open when value is selected
	$('form[id^="edit_feed"] > fieldset > div.control-group').each(function() {
		var open = false;
		$(this).find('select > option[selected]').each(function() {
			if($(this).text() != 'dont use') {
				$(this).parents('span').show();
				open = true;
			}
		});

		if(open) {
			$(this).find('a').toggleClass('btn-success btn-danger').find('i').toggleClass('icon-plus icon-minus');
			$(this).find('a > span').text('');
		}
	});

});

// Feeds
// Fields
function toggleField(el) {
	$(el).toggleClass('btn-success btn-danger');
	$(el).find('i').toggleClass('icon-plus icon-minus');
	$(el).prev().toggle().find('option').attr('selected',false).first().attr('selected',true);
	$(el).find('span').text($(el).find('i').hasClass('icon-plus')?'Use Field':'');
}