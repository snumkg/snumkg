$(function(){
	$('#error_message').modal({
		show: true
	});


 // 다른 영역을 클릭했을 때 hidden 되도록
 // e.stopPropagation()을 이용하여 구현
 // login_box, name_info 보여주기.숨기기 
	$(document).click(function(e){
		var name = $('.user_menu[visibility="visible"]');
		var login = $('.login_box[visibility="visible"]');
		var alarm_list = $("#alarm_list");
		var search_list = $("#search_list");
		$(name).css("visibility","hidden");
		$(login[0]).css("visibility","hidden");
		$(alarm_list).hide();
		$(search_list).hide();

	});

  $('.user').click(function(e){
		e.stopPropagation();

    $(this).next().css("visibility","visible")
									.attr("visibility","visible");
  });

	$('.user_menu').click(function(e){
		e.stopPropagation();
	});

	$('.login_box').click(function(e){
		e.stopPropagation();
	});

	$('.login').click(function(e){
		e.stopPropagation();

		$(this).next().css("visibility","visible")
		.css("top", e.pageY + 20)
		.attr("visibility","visible");


	});
	//sub_menu drop down
	//
	
	$('#menu ul > li > a').mouseenter(function(){

		$(this).next().slideDown('fast');
	
	});
	
	$('#menu ul > li').mouseleave(function(){
		$(this).find('.sub_menu').css("display","none")
	});

  //알람 읽어오기
  refresh_alarm_count();
  $("#alarm_link").click(function(){
    $.ajax({
      url: '/alarms',
      beforeSend: function(){
        $("#alarm_list").html("").show();
        $("#loading-image").show();
      },
      success: function(data){
        $("#loading-image").hide();
        $("#alarm_list").append($(data).children()).show();
        $('#alarm_count_text').text(0);
        refresh_alarm_count();

        //클릭하면 alarm-group state를 2로
        $('.alarm-link').unbind('click').click(function(){
          var href = $(this).attr('href');
          $.ajax({
            url: "/change_alarm_state/" + $(this).attr('alarm-group-id'),
            success: function(result){
              if (result.success){
                location.href = href;
              }
            }
          });
          return false;
        });
      }
    });
  });

});

//알람 카운트가 0이면 숨김
function refresh_alarm_count(){
  var alarm_count = $('#alarm_count_text');
  if (alarm_count.text() == '0'){
    alarm_count.hide();
  }
  else {alarm_count.show();}
}

//infinite scroll
//
//{
//	url: "/everyday", 
//	param_name: "page" (default로 page 지정되어 있음), 
//	success: function(data){ ...} (ajax call 성공 시)
//}
$.fn.infiniteScroll = function(object){
	var target = $(this);
	target.attr("data-page", "1");

	//ajax call로 page 변수 날리고 데이터 값 얻어오는 부분
	function ajax_call(target, object){
		param_name = object.param_name || "page";
		page = parseInt(target.attr("data-page")) + 1;
		target.attr("data-page", page);
		$.ajax({
			url: object.url + "?" + param_name + "=" + page,
			success: function(data){
				object.success(data);
			}
		});
	}

	if(target.css('overflow') == 'scroll'){
		target.scroll(function(e){
			if( target.scrollTop() + 50 >=  (target[0].scrollHeight - target.height())){
				ajax_call(target, object);
			}
		});
	}
	else{
		$(window).scroll(function(e){
			// scroll이 끝까지 내려갔을 경우
			if($(window).scrollTop() + 30 >= ($(document).height() - $(window).height())){
				ajax_call(target, object);
			}
		});
	}
}
