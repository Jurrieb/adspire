$(function() {
	$("input[name='type']").change(function(){
    	$('.url').toggleClass('hidden');
    	$('.file').toggleClass('hidden');
	});
});