
$(function(){
	var date = new Date();
	var d = date.getDate();
	var m = date.getMonth();
	var y = date.getFullYear();

	
	/*
	function parseDay(string){
		if( string === "" || (typeof string != 'string'))
			return;
		arr = string.split("-");
		year = arr[0];
		month = arr[1];
		arr = arr[2].split(" ");
		day = arr[0];
		arr = arr[1].split(":");
		hour = arr[0];
		minute = arr[1];

		return year+"-"+month+"-"+day+" "+hour+":"+minute+":00";
	}
	*/

	var c = 10;
	var articles = $('#article_list tbody tr');

	var c = [];
	articles.each(function(){
		var d = {
			title: $(this).attr('title'),
			start: $(this).attr('day'),
			url: $(this).attr('url'),
			allDay: false
		}
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


