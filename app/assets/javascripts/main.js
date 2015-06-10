var ready = function() {
    ace.config.set("basePath", "/assets/ace");
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
    $(".editable-snippet .files").on("click", ".file-header button.close", function() { 
        var file = $(this).closest('.file');
        file.remove();
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
        placeholder: 'Invite users',
        maxOptions: 50,
        valueField: 'username',
        labelField: 'username',
        searchField: ['username', 'name'],
        render: {
            option: function(item, escape) {
                return "<div><span class='username'>" + escape(item.username) +
                       "</span><span class='name'> (" + escape(item.name) + 
                       ")</span></div>";
            }
        },
        load: function(query, callback) {
            if (!query.length) return callback(); 
            $.ajax({
                url: '/api/users',
                type: 'POST',
                data: {'query': query},
                beforeSend: function() {
                    $('.selectize-control').addClass("loading");
                },
                error: function() {
                    callback();
                },
                success: function(res) {
                    $('.selectize-control').removeClass("loading");
                    callback(res);
                }
            });
        }
    });

    // initializes delete buttons for snippet files at page load if applicable.
    toggleDeleteButton();
}

function initSnippetEditor(container) {
    var modeList = ace.require("ace/ext/modelist");
    var currentSnippet = $(container).parent();
    var mode = modeList.modesByName[currentSnippet.find(".snippet-language").val()];

    if (typeof mode != "undefined") {
        currentSnippet.find(".snippet-language-caption").text(mode.caption);
    }

    if(isMobile.any()) {
       return;
    }
    
    container = $(container);
    var textarea = container.find("textarea.snippet-textarea");
    var aceEditorDiv = $('<div>', {
        "class": "snippet-ace-editor"
    }).insertBefore(textarea);
    textarea.hide();

    var aceEditor = ace.edit(aceEditorDiv[0]);
    aceEditor.setReadOnly(container.data("readonly") === true ? true : false);
    aceEditor.setValue(textarea.val());
    aceEditor.clearSelection();
    
    if (typeof mode != "undefined") {
        aceEditor.getSession().setMode("ace/mode/"+mode.name);
    }

    if (container.data("submit") == true) {
        textarea.closest('form').submit(function() {
            textarea.val(aceEditor.getValue());
        });
    }

    $(".file-name").on('change', function() {
        var currentSnippet = $(this).parent().parent();

        var fileName = $(this).val();   
        var mode = modeList.getModeForPath(fileName);
        if (mode.name == "text") {
            return;
        }
        currentSnippet.find(".snippet-language").val(mode.name);
        if (mode.name == "c_cpp") {
            if (fileName.substr(-4) == ".cpp") {
                currentSnippet.find(".snippet-language-caption").text("C++");    
            } else {
                currentSnippet.find(".snippet-language-caption").text("C");
            }
        } else {
            currentSnippet.find(".snippet-language-caption").text(mode.caption);
        }
        aceEditor.getSession().setMode("ace/mode/"+mode.name);
    });

    $(".snippet-language-option").on('click', function() {
        var currentSnippet = $(this).parent().parent();
        var lang = $(this).data("value");
        var caption = $(this).children().text();

        aceEditor.getSession().setMode("ace/mode/"+lang);
        currentSnippet.find(".snippet-language").val(lang);
        currentSnippet.find(".snippet-language-caption").text(caption);
    });

    $('.snippet-delete-link').on('ajax:success', function() {
        $(this).closest('.view-snippet').remove();
    });
}

var isMobile = {
    Android: function() {
        return navigator.userAgent.match(/Android/i);
    },
    BlackBerry: function() {
        return navigator.userAgent.match(/BlackBerry/i);
    },
    iOS: function() {
        return navigator.userAgent.match(/iPhone|iPad|iPod/i);
    },
    Opera: function() {
        return navigator.userAgent.match(/Opera Mini/i);
    },
    Windows: function() {
        return navigator.userAgent.match(/IEMobile/i);
    },
    any: function() {
        return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
    }
};

function toggleDeleteButton(){
    var buttons = $(".editable-snippet .files .file-header button.close");
    if ($(".file").length <= 1) {
        buttons.hide();
    } else {
        buttons.show();
    }
}

// fix for turbo-links preventing .ready() from working correctly. replaces .ready()
$(document).ready(ready);
$(document).on('page:load', ready);

