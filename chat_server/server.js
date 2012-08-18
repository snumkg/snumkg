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
}

function User(options){
	options = options || {};
	this.socket = options['socket'];
	this.uid = options['uid'];
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
			rooms: rooms
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
		}
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

io.sockets.on('connection', function (socket) {
	socket.on('connect', function(data){
		var uid = data.uid;
		var user_id = data.user_id;
		var nickname = data.nickname;
		var profile_thumb_url = data.profile_thumb_url;
		//유저가 접속함
		users.push(new User({
			socket: socket,
			uid: uid,
			user_id: user_id,
			nickname: nickname,
			profile_thumb_url: profile_thumb_url
		}));
		socket.emit('init_client', {
			hello: "world"
		});
		//broadcast
		broadcast_room_list();
		broadcast_online_users();
	});

	//방만들기
	socket.on('create_room', function(data){
		console.log(data);
		var room = new Room({
			title:data.title,
			master_uid:data.master_uid
		});
		rooms.push(room);
		socket.emit('create_room_complete', {rid:room.rid});
		broadcast_room_list();
	});
});

