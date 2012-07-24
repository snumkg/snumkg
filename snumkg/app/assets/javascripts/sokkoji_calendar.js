
$(function(){
	var date = new Date();
	var d = date.getDate();
	var m = date.getMonth();
	var y = date.getFullYear();


	var articles = $('#sokkoji_article tbody tr').map(function(i,e){
		var article = $(this);
		return {
			title: article.attr('title'),
			writer: article.attr('writer'),
			start: article.attr('start')
		}
	});


	$('#calendar').fullCalendar({

		header:{
			left: 'title',
			center: '',
			right: 'today prev,next'
		},
		events:[
			{
				title: "haha",
				start: new Date(y,m,d,10,30),
				allDay: false
			}
		]

	});

});


