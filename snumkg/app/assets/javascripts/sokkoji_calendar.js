
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
	var articles = $('#sokkoji_article tbody tr').map(function(i,e){
		var article = $(this);
		
		var day = article.attr('day');

		return {
			title: article.attr('title'),
			start: parseDay(day),
			allDay: false
		}
	});


	console.log(articles);
	


	$('#calendar').fullCalendar({

		header:{
			left: 'title',
			center: '',
			right: 'today prev,next'
		},
		events: articles
	
	});

});


