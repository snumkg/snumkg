
$(function(){
	var date = new Date();
	var d = date.getDate();
	var m = date.getMonth();
	var y = date.getFullYear();

	
	function parseDay(string){
		arr = string.split("년");
		year = arr[0];
		arr = arr[1].split("월");
		month = arr[0];
		arr = arr[1].split("일");
		day = arr[0];
		arr = arr[1].trim().split("시");
		hour = arr[0];
		arr = arr[1].split("분");
		minute = arr[0];

		return year+"-"+month+"-"+day+" "+hour+":"+minute+":00";

	}

	var c = 10;
	
/*	
	 // 왜 안될까 ?????????????????????????
	var e = $('#sokkoji_article tbody tr').map(function(i,e){
	
		return {
			title: $(this).attr('title'),
			start: parseDay($(this).attr('day')),
			allDay: false
		};


	});
	console.log(e);
	
*/
	
	var articles = $('#sokkoji_article tbody tr');

	var c = [];
	articles.each(function(){
		var d = {
			title: $(this).attr('title'),
			start: parseDay($(this).attr('day')),
			url: $(this).attr('url'),
			allDay: false
		}
		//console.log(d);
		c.push(d);
		
	});

/*
	var a = [{
			title: "하하하하",
			start: "2012-07-25 12:30:00",
			allDay: false
		
		}];
*/
	$('#calendar').fullCalendar({

		header:{
			left: 'title',
			center: '',
			right: 'today prev,next'
		},
		events: c,
		timeFormat: 'TTh:mm'
	
	});

});


