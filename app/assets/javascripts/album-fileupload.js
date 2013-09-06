$(document).ready( function () {

$(function () {
    // Initialize the jQuery File Upload widget:
    $('#fileupload').fileupload({
        autoUpload: false,
        acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
        maxFileSize: 5000000,
        progress: function (e, data) {
            if (data.context) {
                var progress = Math.floor(data.loaded / data.total * 100);
                data.context.find('.progress')
                    .attr('aria-valuenow', progress)
                    .find('.bar').css(
                        'width',
                        progress + '%'
                    );
                console.debug(progress);
                if (progress == 100) {
                  data.context.find('.progress-note')
                    .html("<i class='icon-loading-green-circle'></i> Validating and processing thumbnails...")
                }
            }
        }
    });
});

});