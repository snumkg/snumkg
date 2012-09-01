$(function(){
	//최근사진 보기 화살표 위로
	$('#photo_navigation_up_button').click(function(){
		var selected = $('#main_picture_navigation .photo.selected');
		//선택된 사진이 첫 번째 사진이면
		if (selected.is($('#main_picture_navigation .photo').first())){
			$('#main_picture_navigation .photo').last().trigger('click');
		}
		else {
			selected.prev().trigger('click');
		}
		return false;
	});
	$('#photo_navigation_down_button').click(function(){
		var selected = $('#main_picture_navigation .photo.selected');
		//선택된 사진이 마지막 사진이면
		if (selected.is($('#main_picture_navigation .photo').last())){
			$('#main_picture_navigation .photo').first().trigger('click');
		}
		else {
			selected.next().trigger('click');
		}
		return false;
	});
	//그림 클릭하면 해당그림으로 변경
	$('#main_picture_navigation .photo').click(function(){
		$('#main_picture_navigation .selected').removeClass('selected');
		var ele = $(this).addClass('selected');

		var current_image = $('#main_picture_screen_image img');
		var link = $('#main_picture_screen_image a').attr('href', ele.attr('href'));
		var new_image = $('<img />').attr('src', ele.attr('src')).appendTo(link).addClass('screen_image');
		current_image.fadeOut(500, function(){
			$(this).remove();
		});
		new_image.fadeIn(500);
		$('#main_picture_screen_title').text(ele.attr('title'));
	});
	
});
