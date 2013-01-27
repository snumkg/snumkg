$(function(){

	$('.anonymous').click(function(){
		$('#article_password').modal('show');
		$('#article_password form').attr('action', $(this).attr('href'));
		return false;
	});
	// 익명게시판 password 입력
});
