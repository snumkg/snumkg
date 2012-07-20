
$(function(){


	var cnt = $('#alarm_list').attr('data-alarmcounts');

	$('#alarm_list li:lt('+cnt+')').animate({
		backgroundColor: "#fee"
	});

	
});
