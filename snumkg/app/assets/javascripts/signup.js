
function error_msg(obj, msg){

	obj.removeClass("green").addClass("red").html(msg);
}

function success_msg(obj, msg){

	obj.removeClass("red").addClass("green").html(msg);
}

$(function(){

	var regex = /^[a-zA-Z](\d|\w)*/;

	$("#user_username").focusout(function(){
		var id = $(this).val();
		
		//입력하지 않았을 경우, 에러 출력 안함
		if( id.length == 0){
			return;
		}

		if(id.length < 6){

			error_msg($(this).next(), "아이디는 6글자 이상이어야 합니다.");
		}
		else{

			//ID형식이 맞지 않을 경우
			if(!regex.test(id)){
				error_msg($(this).next(), "사용할 수 없는 형식의 ID입니다.");
			}
			else{
				//중복되는 아이디 검색
				$.ajax({
					url: '/search_id?id="'+id+'"',
					success: function(data){
						if(data["valid"] == "true"){
							console.log(data["text"]);
							success_msg($("#user_username").next(), data["text"]);
						}
						else{
							error_msg($("#user_username").next(), data["text"]);
						}

					}
					
				});
											
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
			success_msg($(this).next(), "사용가능한 비밀번호입니다.");
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

			success_msg($(this).next(), "비밀번호가 일치합니다.");
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

			success_msg($(this).next(), "사용가능한 이메일입니다.");
		}
	});

});
