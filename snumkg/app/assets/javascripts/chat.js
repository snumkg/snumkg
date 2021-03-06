//GLOBAL VARIABLES
var socket;
var where = "0";
var key;

function refresh_online_user_list(users)
{
	var list = $('#lobby_user_list');
	list.children().remove();

	for (var i=0;i<users.length;i++){
		var user = users[i];
		var div = $('<div></div>').appendTo(list);
		$('<img />').attr('src', user.profile_thumb_url).appendTo(div);
		$('<span></span').appendTo(div).text(user.nickname);
	}
}

function refresh_room_user_list(users)
{
	var list = $('#room_user_list');
	list.children().remove();

	for (var i=0;i<users.length;i++){
		var user = users[i];
		var div = $('<div></div>').appendTo(list);
		$('<img />').attr('src', user.profile_thumb_url).appendTo(div);
		$('<span></span').appendTo(div).text(user.nickname);
	}
}

function refresh_room_list(rooms)
{
	var tbody = $('#room_list tbody');
	tbody.children().remove();
	for (var i=0;i<rooms.length;i++){
		var room = rooms[i];
		var tr = $('<tr></tr>').appendTo(tbody);
		$('<td></td>').text(room.title).appendTo(tr).addClass('title');
		$('<td></td>').text(String(room.users.length) + '/' + String(room.capacity)).appendTo(tr).addClass('master');
		$('<td></td>').text(room.master.nickname).appendTo(tr).addClass('master');
		var button_td = $('<td></td>').appendTo(tr).addClass('button');
		var enter_button = $('<a href="#">입장</a>').appendTo(button_td).addClass('btn').attr('rid', room.rid);

		//입장버튼 클릭 시
		enter_button.click(function(){
			var rid = $(this).attr('rid');
			socket.emit('enter_room', {
				rid: rid,
				uid: uid,
				key: key
			});
			return false;
		});
	}
}

function change_view(view)
{
	if (view == 'room'){
		$('#lobby_wrapper').hide();
		$('#room_wrapper').show();
		$('#room_message_text').focus();
	}
	else if (view == 'lobby'){
		$('#room_wrapper').hide();
		$('#lobby_wrapper').show();
	}
	else {
		alert('change view error');
	}
}

$(function(){
	//채팅방 서버가 꺼져있으면 error
	if (typeof io == 'undefined'){
		$('div').remove();
		alert('채팅 서버가 꺼져있습니다.');
		return;
	}
	change_view('lobby');

	//방만들기 버튼
	$('#create_room_button').click(function(){
		$('#create_room_dialog').modal('show');
	});
	$('#create_room_dialog').on('shown', function(){
		$('#room_title').focus();
	});

	//방만들기 확인 버튼
	$('#create_room_form').submit(function(){
		var title = $('#room_title').val();
		$('#room_title').val("");

		socket.emit('create_room', {
			master_uid: uid,
			key: key,
			title: title
		});
		return false;
	});

	//메시지 보내기
	$('#room_message_form').submit(function(){
		var message = $('#room_message_text').val();
		$('#room_message_text').val("");
		socket.emit('room_message', {
			uid: uid,
			key: key,
			rid: where,
			message: message
		});
		return false;
	});

	//방에서 나가기
	$('#quit_room_button').click(function(){
		socket.emit('quit_room', {
			uid: uid,
			key: key
		});
	});

	//최초 연결
	socket = io.connect(':4000');
	socket.emit('connect', {
		uid: uid,
		user_id: user_id,
		nickname: nickname,
		profile_thumb_url: profile_thumb_url
	});

	//LISTEN
	socket.on('init_client', function(data){
		key = data.key;
	});
	//방 목록 정보
	socket.on('room_list', function(data){
		refresh_room_list(data.rooms);
	});
	//접속중인 유저 정보
	socket.on('online_users', function(data){
		refresh_online_user_list(data.users);
	});

	//방만들기 완료
	socket.on('create_room_complete', function(data){
		socket.emit('enter_room', {
			uid: uid,
			key: key,
			rid: data.room.rid
		});
		$('#create_room_dialog').modal('hide');
	});

	//방 입장 실패
	socket.on('enter_room_fail', function(data){
		alert(data.message);
	});

	//방 입장
	socket.on('enter_room_complete', function(data){
		change_view('room');
		where = data.room.rid;
		$('#room_messages').children().remove();
	});

	//메시지 보내기 실패
	socket.on('room_message_fail', function(data){
		alert(data.message);
	});
	
	//메시지 옴
	socket.on('room_message_complete', function(data){
		var room_messages = $('#room_messages');
		var message_div = $('<div></div>').appendTo(room_messages).addClass('message-div');
		$('<img />').attr('src', data.user.profile_thumb_url).appendTo(message_div);
		$('<span></span>').text('(' + data.user.nickname + ') : ').appendTo(message_div);
		$('<span></span>').text(data.message).appendTo(message_div);
		room_messages.scrollTop(room_messages[0].scrollHeight);
	});

	//방에서 나가기
	socket.on('quit_room_complete', function(data){
		change_view('lobby');
	});

	//방에 있는 유저들 정보
	socket.on('room_info', function(data){
		refresh_room_user_list(data.users);
	});

	//잘못된 접근 (uid, key) 인증 실패
	socket.on('auth_fail', function(data){
		alert(data.message);
	});

});


