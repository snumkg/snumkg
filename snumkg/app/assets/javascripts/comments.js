

$(function(){
	$('.like_list_btn').mouseover(function(e){
		
		var cid = $(this).attr('data-id');

		
		$("ul[data-id="+cid+"]").css({
			'top':e.pageY,
			'left':e.pageX
		}).slideDown('fast');
	}).mouseleave(function(){
		var cid = $(this).attr('data-id');

		$("ul[data-id="+cid+"]").slideUp('fast');
	}).click(function(){
		var cid = $(this).attr('data-id');
		$("div[data-id=modal"+cid+"]").modal();
		
	});
});
