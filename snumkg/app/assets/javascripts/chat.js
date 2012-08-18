//GLOBAL VARIABLES
var socket;

function refresh_room_list(rooms)
{
	console.log(rooms);
}

$(function(){
	//방만들기 버튼
	$('#create_room_button').click(function(){
		$('#create_room_dialog').modal('show');
	});

	//방만들기 확인 버튼
	$('#create_room_submit_button').click(function(){
		$('#room_title').focus();
		var title = $('#room_title').val();

		socket.emit('create_room', {
			master_uid: uid,
			title: title
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
		console.log('connected!');
	});
	//방 목록 정보
	socket.on('room_list', function(data){
		refresh_room_list(data.rooms);
	});
	//접속중인 유저 정보
	socket.on('online_users', function(data){
		console.log(data);	
	});

	//방만들기 완료
	socket.on('create_room_complete', function(data){
		socket.emit('enter_room', {
			uid: uid,
			rid: data.rid
		});
	});

});


