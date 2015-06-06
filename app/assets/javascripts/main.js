var ready = function() {
    var modelist = ace.require('ace/ext/modelist');

    // Toggles notifications popover
    $("#notifications-toggle").popover({
        html: true,
        content: function() {
            return $("#notifications-container").html();
        }
    });
    // Dismisses notifications popover when user clicks outside it
    $('html').on('click', function(e) {
        if (typeof $(e.target).data('original-title') === 'undefined' &&
            !$(e.target).parents().is('.popover.in')) {
            $('[data-original-title]').popover('hide');
        }
    });

    // adds new snippet file
    $("#add-snippet-file-btn").click(function() {
        var files = $(".files");
        files.append($("#snippet_file_template").html());
        var newFile = files.find(".file").last();
        $(document).scrollTop(newFile.offset().top - 100);
        toggleDeleteButton();

        var container = newFile.find(".snippet-editor");
        initSnippetEditor(container);
    });

    // removes snippet files
    $(".editable-snippet .files").on("click", ".file > button.close", function() { 
        var parent = $(this).parent();
        parent.remove();
        toggleDeleteButton();
    });

    // toggle display of snippet files
    $('.minimizable > .snippet-header').click(function(e) {
        if (e.target.nodeName === 'A') {
            return;
        }
        var container = $(this).closest('.view-snippet');
        var files = container.find('.files');
        container.toggleClass('selected-snippet');
        files.toggle();
    });

    // Removes the snippet after a successful delete
    $('.snippet-delete-link').on('ajax:success', function() {
        $(this).closest('.view-snippet').remove();
    });

    // initializes all editors defined on the page at time of page load
    $(".snippet-editor").each(function(index, item) {
        initSnippetEditor(item);
    });

    $("#invitees").selectize({
        plugins: ['remove_button'],
        delimiter: ',',
        maxOptions: 50,
        valueField: 'username',
        labelField: 'username',
        searchField: ['username', 'name'],
        render: {
            option: function(item, escape) {
                return "<div>" + escape(item.username) + "</div>";
            }
        },
        load: function(query, callback) {
            if (!query.length) return callback(); 
            $.ajax({
                url: '/api/users',
                type: 'POST',
                data: {'query': query},
                beforeSend: function() {
                    $('.selectize-input').addClass("loading");
                },
                error: function() {
                    callback();
                },
                success: function(res) {
                    $('.selectize-input').removeClass("loading");
                    callback(res);
                }
            });
        }
    });

    // initializes delete buttons for snippet files at page load if applicable.
    toggleDeleteButton();
}

function initSnippetEditor(container) {
    container = $(container);
    var textarea = container.find("textarea.snippet-textarea");
    var aceEditorDiv = $('<div>', {
        "class": "snippet-ace-editor"
    }).insertBefore(textarea);

    var aceEditor = ace.edit(aceEditorDiv[0]);
    aceEditor.setReadOnly(container.data("readonly") === true ? true : false);
    aceEditor.setValue(textarea.val());
    aceEditor.clearSelection();
    if (container.data("submit") == true) {
        textarea.closest('form').submit(function() {
            textarea.val(aceEditor.getValue());
        });
    }
}

function toggleDeleteButton(){
    var buttons = $(".editable-snippet .files .file > .close");
    if ($(".file").length <= 1) {
        buttons.hide();
    } else {
        buttons.show();
    }
}

// fix for turbo-links preventing .ready() from working correctly. replaces .ready()
$(document).ready(ready);
$(document).on('page:load', ready);

