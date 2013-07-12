$(document).ready( function () {

$(function () {
    // Initialize the jQuery File Upload widget:
    $('#fileupload').fileupload({
        autoUpload: false,
        acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
        maxFileSize: 3500000,
        progress: function(e, data) {
          console.debug(data)
          if (data._progress.loaded == data._progress.total) {

          }
        }
    });
});

});