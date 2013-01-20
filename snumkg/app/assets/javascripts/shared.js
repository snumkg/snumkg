$(function(){
	$('#error_message').modal({
		show: true
	});

  $('input[placeholder], textarea[placeholder]').placeholder();
  $(".dropdown-toggle").dropdown();

 // 다른 영역을 클릭했을 때 hidden 되도록
 // e.stopPropagation()을 이용하여 구현
 // login_box, name_info 보여주기.숨기기 
	$(document).click(function(e){
		var login = $('.login_box[visibility="visible"]');
		var alarm_list = $("#alarm_list_box").hide();
		var search_list = $("#search_list");
		$(name).css("visibility","hidden");
		$(login[0]).css("visibility","hidden");
		$(search_list).hide();

	});

  $('.user').click(function(e){
		e.stopPropagation();

    $(this).next().css("visibility","visible")
									.attr("visibility","visible");
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
    load_alarms(1);
    $('#alarm_list_box').show().getNiceScroll().resize();
		return false;
  });
  $('#alarm_list_box').scroll(function(){
    var ele = $(this);
    var scrollHeight = ele.get(0).scrollHeight;
    var scrollTop = ele.scrollTop();
    var scrollBottom = ele.scrollTop() + ele.height();
    var difference = scrollHeight - scrollBottom;
    if (difference < 10){
      var current_page = parseInt($('#alarm_list_box').attr('page')) || 1;
      load_alarms(current_page + 1);
    }
  }).niceScroll({cursorcolor: "#999"});
  //
  $(window).scroll(function(){
    $('#alarm_list_box').getNiceScroll().resize();
  });

});

// 알람을 로딩해서 alarm_list_box에 붙임
function load_alarms(page){
  var box = $('#alarm_list_box');
  if (box.attr('loading') == 'true') return;
  page = page || 1;
  if (page == 1){
    box.attr('completed', 'false');
  }
  if (box.attr('completed') == 'true') return;
  $.ajax({
    url: '/alarms?page='+page,
    beforeSend: function(){
      if (page == 1){
        $("#alarm_list").children().remove();
      }
      $("#loading-image").show();
    },
    success: function(data){
      var html_dom = $(data);
      var new_item_count = html_dom.children().size();
      box.attr('loading', 'false');
      $("#loading-image").hide();
      $("#alarm_list").append(html_dom.children());
      $('#alarm_count_text').text(0);
      refresh_alarm_count();

      if (new_item_count == 0){
        box.attr('completed', 'true');
        return false;
      }
      else {
        box.attr('page', page);
      }

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
      $('#alarm_list_box').trigger('scroll');
    }
  });
  box.attr('loading', 'true');
}

//알람 카운트가 0이면 숨김
function refresh_alarm_count(){
  var alarm_count = $('#alarm_count_text');
  if (alarm_count.text() == '0'){
    alarm_count.hide();
    $('title').text("서울대학교 모꼬지");
  }
  else {
    alarm_count.show();
    $('title').text("서울대학교 모꼬지 ("+alarm_count.text()+")");
  }
}

//서버에서 새 알람 수를 얻어옴
function fetch_new_alarm_count(){
  $.ajax({
    url: "/new_alarm_count",
    success: function(x){
      $('#alarm_count_text').text(x.count);
      refresh_alarm_count();
    }
  });
}
setInterval(fetch_new_alarm_count, 12000); //12초마다 반복

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

//프로필 사진 클릭 시
function show_profile(user_id){
  $.ajax({
    url: '/profile/' + user_id + ".json",
    success: function(data){
      var user = data.user;
      var profile_modal = $('#profile_modal');
      profile_modal.find('.user-nickname').html(user.nickname);
      profile_modal.find('.profile_image').attr('src', user.profile_url);
      profile_modal.find('.username').html(user.username);
      profile_modal.find('.email').html(user.email);
      profile_modal.find('.birthday').html(user.birthday);
      profile_modal.find('.department').html(user.department);

      profile_modal.find('.message_link').attr('href', user.message_path);
      profile_modal.find('.profile_link').attr('href', user.profile_path);
      profile_modal.modal('show');
    }
  });
  return false;
}
