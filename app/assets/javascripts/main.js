var ready = function() {
    $("#add-snippet-file-btn").click(function() {
        var files = $("#new_snippet > .files");
        files.append($("#snippet_file_template").html());
        $(document).scrollTop(files.find(".file").last().offset().top - 100);
    });
}

// fix for turbo-links preventing .ready() from working correctly. replaces .ready()
$(document).on('page:change', ready);

$(document).on('click', '.close', function(){ 
   	var parent = $(this).parent();
   	parent.remove();
});