
function error_msg(obj, msg){

	obj.html(msg);
}

$(function(){

	var regex = /^[a-zA-Z](\d|\w)*/;

	$("#user_username").focusout(function(){
		
		//입력하지 않았을 경우, 에러 출력 안함
		if( $(this).val().length == 0){
			return;
		}

		if($(this).val().length < 6){

			error_msg($(this).next(), "아이디는 6글자 이상이어야 합니다.");
		}
		else{

			//ID형식이 맞지 않을 경우
			if(!regex.test($(this).val())){
				error_msg($(this).next(), "사용할 수 없는 형식의 ID입니다.");
			}
			else{
				error_msg($(this).next().removeClass("red").addClass("green"), "사용가능한 ID입니다.");
											
			}
		}
	});

	$("#user_password").focusout(function(){

		if( $(this).val().length == 0){
			return;
		}

		if($(this).val().length < 6){
			error_msg($(this).next(), "비밀번호는 6자리 이상이어야 합니다.");
		}
		else{
			error_msg($(this).next().removeClass("red").addClass("green"), "사용가능한 비밀번호입니다.");
		}
	});

	$("#user_password_confirmation").focusout(function(){
		var pw = $("#user_password").val();


		if( $(this).val().length == 0){
			return;
		}

		if( pw != $(this).val() ){
			error_msg($(this).next(), "비밀번호가 일치하지 않습니다.");
		}
		else{

			error_msg($(this).next().removeClass("red").addClass("green"), "비밀번호가 일치합니다.");
		}
	});

	$("#user_email").focusout(function(){

		var regex = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i;
		
		if($(this).val().length == 0){
			return;
		}

		if(!regex.test($(this).val())){
			
			error_msg($(this).next(), "잘못된 이메일 형식입니다.");
		}
		else{

			error_msg($(this).next().removeClass("red").addClass("green"), "사용가능한 이메일입니다.");
		}
	});

});
