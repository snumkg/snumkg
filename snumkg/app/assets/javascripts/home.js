$(function(){
	$('#error_message').modal({
		show: true
	});

  $('.name').click(function(){
    $(this).next().css("visibility","visible");
  });

});
