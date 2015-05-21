var ready = function() {
    $("#add-snippet-file-btn").click(function() {
        var element = document.createElement("div");
        $(element).addClass("file");
        element.innerHTML = '<input type="textbox" placeholder="File name" name="snippet_files[][filename]"> <div>Content</div> <textarea name="snippet_files[][content]" value ="duckcontent"></textarea> <input type="hidden" name = "snippet_files[][language]" value="text">'
        $("#new_snippet > .files").append(element);
    });
}

// fix for turbo-links preventing .ready() from working correctly. replaces .ready()
$(document).on('page:change', ready);
