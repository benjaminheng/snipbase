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

    // Initializes all tooltips
    $(function () {
      $('[data-toggle="tooltip"]').tooltip()
    })

    // Dismisses notifications popover when user clicks outside it
    $('html').on('click', function(e) {
        if (typeof $(e.target).data('original-title') === 'undefined' &&
            !$(e.target).parents().is('.popover.in')) {
            $('[data-original-title]').popover('hide');
        }
    });

    // Subtle highlight for in-focus panel (focus in)
    $('.panel-custom').on('focus', 'input', function() {
        $(this).closest('.panel-custom').addClass('focused');
    });

    // Subtle highlight for in-focus panel (focus out)
    $('.panel-custom').on('focusout', 'input', function() {
        $(this).closest('.panel-custom').removeClass('focused');
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
    $(".editable-snippet .files").on("click", ".file-metadata button.close", function() { 
        var file = $(this).closest('.file');
        var nextFileFocus = file.next();
        if (file.is(':last-child')) {
            nextFileFocus = file.prev();
        }
        file.remove();
        toggleDeleteButton();
        nextFileFocus.find('.ace_text-input').focus();
    });

    // toggle display of snippet files
    $('#snippet-list').on('click', '.minimizable > .snippet-header', function(e) {
        if (e.target.nodeName === 'A') {
            return;
        }
        if (e.target.classList.contains('snippet-control')) {
            return;
        }
        var container = $(this).closest('.view-snippet');
        var files = container.find('.files');
        if (container.hasClass('minimized')) {
            files.slideDown(300);
        } else {
            files.slideUp(300);
        }
        container.toggleClass('minimized');
    });

    // Removes the snippet client-side after a successful delete
    $('#snippet-list .snippet-delete-link').on('ajax:success', function() {
        $(this).closest('.view-snippet').remove();
    });

    // initializes all editors defined on the page at time of page load
    $(".snippet-editor").each(function(index, item) {
        initSnippetEditor(item);
    });

    // Group selector for snippet groups
    $('#snippet_group_ids').selectize({
        plugins: ['remove_button'],
        delimiter: ',',
        placeholder: 'Groups',
        valueField: 'value',
        labelField: 'name',
        searchField: ['name']
    });

    // User selector for inviting users to groups
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

    $('#languages').selectize({
        persist: false,
        maxItems: null,
        valueField: 'name',
        labelField: 'caption',
        searchField: ['name', 'email'],
        options: modelist.modes,
        render: {
            item: function(item, escape) {
                return '<div>' +
                    (item.caption ? '<span class="list-caption">' + escape(item.caption) + '</span>' : '') +
                '</div>';
            },
            option: function(item, escape) {
                var caption = item.caption;
                return '<div>' +
                    (caption ? '<span class="caption">' + escape(caption) + '</span>' : '') +
                '</div>';
            }
        },
        create: false
    });


    // Toggles dropdown params for search
    $(".btn-search-minimize").click(function(){
        $(this).toggleClass('glyphicon-chevron-up');
        $(this).toggleClass('glyphicon-chevron-down');
        $(".search-params").slideToggle();       
    });

    //Add Keyboard shortcuts here
    Mousetrap.bind('g n', function() {
        var element = $("#add_snippet_link");
        if (element.length) {
            element[0].click();
        }
    });

    Mousetrap.bind('g g', function() {
        var element = $("#groups_link");
        if (element.length) {
            element[0].click();
        }
    });

    Mousetrap.bind('g u', function() {
        var element = $("#user_profile_link");
        if (element.length) {
            element[0].click();
        }
    });

    // initializes delete buttons for snippet files at page load if applicable.
    toggleDeleteButton();
}

function initSnippetEditor(container) {
    var modeList = ace.require("ace/ext/modelist");
    var currentSnippet = $(container).parent();
    var mode = modeList.modesByName[currentSnippet.find(".snippet-language").val()];

    currentSnippet.find(".snippet-language-caption").text(mode.caption);

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
    aceEditor.setTheme('ace/theme/custom_github');

    aceEditor.getSession().setMode("ace/mode/"+mode.name);

    var allCommands = aceEditor.commands.byName;

    //Change focus to next Snippet File
    aceEditor.commands.bindKey("Ctrl-Down", function(){
        var next = $(':focus').closest('.file').next().find('.ace_text-input');
        next.focus();
    });

    //Change focus to previous Snippet File
    aceEditor.commands.bindKey("Ctrl-Up", function(){
        var previous = $(':focus').closest('.file').prev().find('.ace_text-input');
        previous.focus();
    });

    //Adds a new Snippet File
    aceEditor.commands.bindKey("Alt-N", function() {
        $("#add-snippet-file-btn").click();
        $('.ace_text-input').last().focus();
    });

    //Change focus to filename of current Snippet File
    aceEditor.commands.bindKey("Alt-F", function() {
        $(':focus').closest('.file').find('.file-name').focus();
    });

    //Removes current Snippet File
    aceEditor.commands.bindKey("Alt-D", function() {
        if ($(".file").length > 1) {
            var file = $(':focus').closest('.file').find('.close');
            file.click();
        }
    });

    if (container.data("submit") == true) {
        textarea.closest('form').submit(function() {
            textarea.val(aceEditor.getValue());
        });
    }

    $(".file-name").on('change', function() {
        var currentSnippet = $(this).closest('.file');

        var fileName = $(this).val();   
        var mode = modeList.getModeForPath(fileName);
        if (mode.name == "text") {
            return;
        }
        currentSnippet.find(".snippet-language").val(mode.name);
        currentSnippet.find(".snippet-language-caption").text(mode.caption);
        aceEditor.getSession().setMode("ace/mode/"+mode.name);
    });

    $(".snippet-language-option").on('click', function() {
        var currentSnippet = $(this).closest('.file');
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
    var buttons = $(".editable-snippet .files .file-metadata button.close");
    if ($(".file").length <= 1) {
        buttons.hide();
    } else {
        buttons.show();
    }
}

// fix for turbo-links preventing .ready() from working correctly. replaces .ready()
$(document).ready(ready);
$(document).on('page:load', ready);
