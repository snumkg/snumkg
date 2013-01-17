
 $(function(){
	 $('.redactor_content').redactor({
      lang: 'ko',
			imageUpload: '/pictures?type=article',
			imageUploadCallback : function(obj, json){
				console.log("obj!");
				console.log(obj);
				console.log("json!");
				console.log(json);
			},
			fileUpload: '/file_upload.php'
  });
 });
