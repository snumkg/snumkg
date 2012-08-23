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

});


