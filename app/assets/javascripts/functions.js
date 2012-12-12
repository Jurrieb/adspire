$(document).ready(function() {
	$('.dropdown-toggle').dropdown();
	
	$('#notifications li > button.remove').click(function() {
		$(this).parent().slideUp('fast', function() { $(this).remove(); });

		return false;
	});
});