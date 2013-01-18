$(function(){
	 $('.redactor_content').redactor({
      lang: 'ko',
			imageUpload: '/pictures?type=article',
			fileUpload: '/file_upload.php'
  });

});

//업로드된 파일 목록을 담는 전역 변수
var uploaded_files = [];

$.fn.plupload = function(){
	$(this).pluploadQueue({
		// General settings
		runtimes : 'flash,html5',
		url : '/pictures?type=article',
		max_file_size : '10mb',
		unique_names : true,

		// Specify what files to browse for
		filters : [
			{title : "Image files", extensions : "jpg,gif,png,bmp,JPG,GIF,PNG,BMP"},
			{title : "Zip files", extensions : "zip"}
		],

		// Flash settings
		flash_swf_url : '/assets/plupload/plupload.flash.swf',
	});
	var uploader = $(this).pluploadQueue();
	uploader.bind('FileUploaded', function(up, file, obj) {
		var result = $.parseJSON(obj.response);
		uploaded_files.push(result);
	});

	return $(this);
};
