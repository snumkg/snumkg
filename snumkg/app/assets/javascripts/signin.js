
function setCookie(cName, cValue, cDay){
	var expire = new Date();
	expire.setDate(expire.getDate() + cDay);
	cookies = cName + '=' + escape(cValue) + '; path=/ '; // 한글 깨짐을 막기위해 escape(cValue)를 합니다.
	if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
	document.cookie = cookies;
}


function getCookie(cName) {
	cName = cName + '=';
	var cookieData = document.cookie;
	var start = cookieData.indexOf(cName);
	var cValue = '';
	if(start != -1){
		start += cName.length;
		var end = cookieData.indexOf(';', start);
		if(end == -1)end = cookieData.length;
		cValue = cookieData.substring(start, end);
	}
	return unescape(cValue);
}

function deleteCookie(cookieName)
{
	var expireDate = new Date();

	//어제 날짜를 쿠키 소멸 날짜로 설정한다.
	expireDate.setDate( expireDate.getDate() - 1 );
	document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString() + "; path=/";
}


// 아이디 저장 기능을 위한 스크립트
$(function(){

	var cookie = getCookie("userid");

	if( cookie != ""){
		$("#username").attr("value", cookie);
		$("#idsave").prop("checked",true);
	}
	

	$("#login_submit").click(function(){

		var id = $("#username").attr("value");

		if($("#idsave").is(":checked") == true){
			setCookie("userid",id,7);
		}
		else{
			deleteCookie("userid");	
		}
	});


	$("myModal").modal();

});
