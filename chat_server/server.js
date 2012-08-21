//DEFINE ARRAY FUNCTIONALITIES
Array.prototype.remove = function(ele){
	var index = this.indexOf(ele);
	if (index != -1)
		this.splice(index, 1);
	return index;
}
Array.prototype.removeIndex = function(index){
	if (index >= 0 && index < this.length){
		this.splice(index, 1);
		return true;
	}
	return false;
}
Array.prototype.find = function(ele){
	var index = this.indexOf(ele);
	if (index == -1)
		return null;
	return ele;
}

var io = require('socket.io').listen(4000);
var utils = require('./utils.js');

//GLOBAL VARIABLES
var users = [];
var rooms = [];

//MODEL DEFINITION
function Room(options){
	options = options || {};
	this.rid = utils.SHA1(String(Math.random()));
	this.title = options['title'] || "";
	this.master_uid = options['master_uid'];
	this.capacity = options['capacity'] || 10;
	this.users = [];

	this.toHash = function(){
		var master = get_user_by_uid(this.master_uid);
		if (master) master = master.toHash();
		var users = [];
		for (var i=0;i<this.users.length;i++){
			var user = this.users[i];
			users.push(user.toHash());
		}
		return {
			rid: this.rid,
			title: this.title,
			capacity: this.capacity,
			master: master,
			users: users
		}
	};

	this.broadcastRoomMessage = function(params){
		var room_users = this.users;
		for (var i=0;i<room_users.length;i++){
			var user = room_users[i];
			user.socket.emit('room_message_complete', params);
		}
	};

	this.broadcastRoomInfo = function(){
		for (var i=0;i<this.users.length;i++){
			this.users[i].socket.emit('room_info', this.toHash());
		}
	};

	this.quitUser = function(user){
		if (this.users.remove(user) != -1){
			//room remove!
			if (this.users.length == 0)
				rooms.remove(this);
			//change master
			else if (!this.users.find(user)){
				this.master_uid = this.users[0].uid;
			}
		}
	}
}

function User(options){
	options = options || {};
	this.socket = options['socket'];
	this.uid = options['uid'];
	this.key = utils.SHA1(String(Math.random())); //랜덤한 값. 유저 인증을 확인하기 위해 사용
	this.user_id = options['user_id'];
	this.nickname = options['nickname'];
	this.profile_thumb_url = options['profile_thumb_url'];
	this.where = "0"; //0 : lobby, else :rid

	this.toHash = function(){
		return {
			uid: this.uid,
			user_id: this.user_id,
			nickname: this.nickname,
			profile_thumb_url: this.profile_thumb_url,
			where: this.where
		};
	};

	this.sendRoomList = function(){
		this.socket.emit('room_list', {
			rooms: rooms.map(function(room){return room.toHash(); })
		});
	};

	this.sendOnlineUsers = function(){
		this.socket.emit('online_users', {
			users: users.map(function(user){ return user.toHash(); })
		});
	};

	this.enterRoom = function(room){
		if (this.where == '0'){
			this.where = room.rid;
			room.users.push(this);
			this.socket.emit('enter_room_complete', {
				room: room.toHash()
			});
			room.broadcastRoomInfo();
			broadcast_room_list();
		}
	}

	this.quitRoom = function(){
		console.log('USER.QUIT_ROOM');
		var room = get_room_by_rid(this.where);
		if (room)	room.quitUser(this);
		this.where = "0";
		this.socket.emit('quit_room_complete', {message:"OK"}); //Room to lobby
		this.sendRoomList();
		room.broadcastRoomInfo();
		broadcast_room_list();

		return room;
	}
}

function get_room_by_rid(rid)
{
	for (var i=0;i<rooms.length;i++){
		if (rooms[i].rid == rid)
			return rooms[i];
	}
	return null;
}

function get_user_by_uid(uid)
{
	for (var i=0;i<users.length;i++){
		if (users[i].uid == uid)
			return users[i];
	}
	return null;
}

function broadcast_room_list()
{
	for (var i=0;i<users.length;i++){
		var user = users[i];
		//로비에 있는 유저에게만 방 리스트 정보를 갱신시킴
		if (user.where == '0'){
			user.sendRoomList();
		}
	}
}

function broadcast_online_users()
{
	for (var i=0;i<users.length;i++){
		var user = users[i];
		user.sendOnlineUsers();
	}
}

function clean_users()
{
	var deleted = false;
	var flag;
	do {
		flag = false;
		for (var i=0;i<users.length;i++){
			if (users[i].socket.disconnected){
				if (users[i].where != "0"){
					var room = users[i].quitRoom();
					if (room && !room.users.find(users[i]))
						users.removeIndex(i);
				}
				else {
					users.removeIndex(i);
				}
				flag = true;
				deleted = true;
			}
		}
	}while(flag);

	if (deleted){
		broadcast_online_users();
		broadcast_room_list();
	}
}

function auth_user(uid, key)
{
	for (var i=0;i<users.length;i++){
		if (users[i].uid == uid && users[i].key == key)
			return users[i];
	}
	return null;
}

setInterval(clean_users, 1000);

io.sockets.on('connection', function (socket) {
	socket.on('connect', function(data){
		var uid = data.uid;
		var user_id = data.user_id;
		var nickname = data.nickname;
		var profile_thumb_url = data.profile_thumb_url;
		//유저가 접속함
		var user = new User({
			socket: socket,
			uid: uid,
			user_id: user_id,
			nickname: nickname,
			profile_thumb_url: profile_thumb_url
		})
		users.push(user);
		socket.emit('init_client', {
			key: user.key
		});
		//broadcast
		broadcast_room_list();
		broadcast_online_users();
	});

	//DISCONNECT
	socket.on('disconnect', function(){
		console.log("USER DISCONNECT");
		clean_users();
	});

	//방만들기
	socket.on('create_room', function(data){
		data = data || {};
		if (auth_user(data.master_uid, data.key)){
			console.log(data);
			var room = new Room({
				title:data.title,
				master_uid: data.master_uid
			});
			rooms.push(room);
			socket.emit('create_room_complete', {room: room.toHash()});
			broadcast_room_list();
		}
		else {
			socket.emit('auth_fail', {message: "잘못된 접근입니다(create_room)"});
		}
	});

	//방 입장하기
	socket.on('enter_room', function(data){
		data = data || {};
		if (auth_user(data.uid, data.key)){
			var room = get_room_by_rid(data.rid);
			var user = get_user_by_uid(data.uid);
			if (room && user){
				if (room.users.length < room.capacity){
					user.enterRoom(room);
				}
				else {
					socket.emit('enter_room_fail', {message: "방이 가득찼습니다."});
				}
			}
			else {
				console.log(data);
				socket.emit('enter_room_fail', {message: "방 입장 오류"});
			}
		}
		else {
			socket.emit('auth_fail', {message: "잘못된 접근입니다(enter_room)"});
		}
	});

	//메시지 보내기
	socket.on('room_message', function(data){
		data = data || {};
		if (auth_user(data.uid, data.key)){
			var room = get_room_by_rid(data.rid);
			var user = get_user_by_uid(data.uid);
			if (room && user){
				room.broadcastRoomMessage({
					user: user.toHash(),
					message: data.message
				});
			}
			else {
				socket.emit('room_message_fail', {message: "메시지 보내기 오류"});
			}
		}
		else {
			socket.emit('auth_fail', {message: "잘못된 접근입니다(room_message)"});
		}
	});

	//방에서 나가기
	socket.on('quit_room', function(data){
		data = data || {};
		if (auth_user(data.uid, data.key)){
			var user = get_user_by_uid(data.uid);
			user.quitRoom();
		}
		else {
			socket.emit('auth_fail', {message: "잘못된 접근입니다(quit_room)"});
		}
	});
});

