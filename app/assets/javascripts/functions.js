$(document).ready(function() {
	$('.dropdown-toggle').dropdown();
	
	$('#notifications li > button.remove').click(function() {
		$(this).parent().slideUp('fast', function() { $(this).remove(); });

		return false;
	});


	// Form items
	$('.btn-group[data-toggle="buttons-radio"]').each(function() {
		var target = $(this).attr('data-target');
		var value = $(this).find('button.active').val();
		$('#'+target).val(value);

		$(this).find('button').click(function() {
			$('#'+target).val($(this).val());
		});
	});
});