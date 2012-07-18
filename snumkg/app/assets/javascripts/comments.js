

$(function(){
	$('.like_list_btn').click(function(e){
		
		var cid = $(this).attr('data-id');

		
		$("ul[data-id="+cid+"]").css({
			'top':e.pageY,
			'left':e.pageX
		}).slideDown();
	}).mouseleave(function(){
		var cid = $(this).attr('data-id');

		$("ul[data-id="+cid+"]").slideUp();
	});
});
