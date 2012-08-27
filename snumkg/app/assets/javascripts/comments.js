

$(function(){
	$('.like_list_btn').click(function(){
		var cid = $(this).attr('data-id');
		$("div[data-id=modal"+cid+"]").modal({show: true});
		
	});
});
