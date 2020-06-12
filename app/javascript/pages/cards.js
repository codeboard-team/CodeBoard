$(document).on("turbolinks:load", function() {
    // card:comment  =======
    $('#comment').val()
    var comments = $('#comment').val()
    $('#comment').prepend(`<p>${comments}</p>`)

    $('#submit-msg-card').click(function() {
        // $( "#submit" ).click(`<div>${comments}</div>`)

        var data = $('#comment_content').val()
        $('#comment').prepend(`<p>${data}</p>`)
    });
    // card:test-code =======

    $("#btn-add-test-code").click(function() {
        let numTestCode = $(".test-item").length
        addInput = `<p class="test-item flex">
                        <span class="numTestCode">${numTestCode + 1}</span>
                        <input name="card[test_code][]" class="w-full">
                        <span id="btn-del-test-code">
                            <i class="fa fa-minus-circle hover:text-red-700 text-red-500 rounded-full text-2xl"></i>
                        </span>
                    </p>`
        $("#section-test-code").append($(addInput));
    });

    $("#section-test-code").on("click", "#btn-del-test-code", function() {
        let numTestCode = 1
        $(this).parent("p").remove()
        $(".numTestCode").each(function() {
            $(this).text(numTestCode);
            numTestCode = numTestCode + 1
        });
    })

    // card:hint =======

    $("#btn-add-hints").click(function() {
        let numHint = $(".hint-item").length
        addInput = `<p class="hint-item">
                        <span class="numHint">${numHint + 1}</span>
                        <input name="card[hints][]">
                        <span id="btn-del-hint">
                            <i class="fa fa-minus-circle hover:text-red-700 text-red-500 rounded-full text-2xl"></i>
                        </span>
                    </p>`
        $("#section-hints").append(addInput);
    });

    $("#section-hints").on("click", "#btn-del-hint", function() {
        let numHint = 1

        $(this).parent("p").remove()
        $(".numHint").each(function() {
            $(this).text(numHint);
            numHint = numHint + 1
        });
    })

    // card:show hints =======

    $("#btn-show-hints").click(function() {
        $("li.hint.hidden").first().removeClass("hidden");
    });

    // Ace Editor-readonly

    let editorRoDoms = document.getElementsByClassName('editor-readonly');
    for (editorRoDom of editorRoDoms) {

        let aceEditorRo = ace.edit(editorRoDom);

        aceEditorRo.getSession().setMode($("#board-lang").text());
        aceEditorRo.setTheme("ace/theme/tomorrow");
        aceEditorRo.getSession().setTabSize(2);

        aceEditorRo.setAutoScrollEditorIntoView(true);
        aceEditorRo.setOption("maxLines", 30);

        aceEditorRo.focus();
        aceEditorRo.setReadOnly(true); //不可編輯

        aceEditorRo.setOptions({
            fontSize: ".95rem",
            vScrollBarAlwaysVisible: true,
            autoScrollEditorIntoView: true,
            minLines: 8,
            showLineNumbers: true // 行數+摺疊
                //  showGutter: false, // 摺疊功能
        });
        aceEditorRo.setShowPrintMargin(false);
        aceEditorRo.setBehavioursEnabled(false);


    }

    // Ace Editor

    let editorDoms = document.getElementsByClassName('editor');
    for (editorDom of editorDoms) {

        let aceEditor = ace.edit(editorDom);
        let input = document.getElementById(editorDom.dataset.target);

        aceEditor.getSession().setMode($("#board-lang").text());
        aceEditor.setTheme("ace/theme/tomorrow");
        aceEditor.getSession().setTabSize(2);
        aceEditor.setValue(input.value, 1);

        aceEditor.setAutoScrollEditorIntoView(true);
        aceEditor.setOption("maxLines", 100);

        aceEditor.focus();

        aceEditor.setOptions({
            fontSize: ".95rem",
            vScrollBarAlwaysVisible: true,
            autoScrollEditorIntoView: true,
            minLines: 8,
            showLineNumbers: true // 行數+摺疊
                //  showGutter: false, // 摺疊功能
        });
        aceEditor.setShowPrintMargin(false);
        aceEditor.setBehavioursEnabled(false);

        if (editorDom.classList.contains("readonly")) {
            aceEditor.setReadOnly(true); //不可編輯
        }

        aceEditor.getSession().on("change", function() {
            let newValue = aceEditor.getValue();
            input.value = newValue;
        });

    }
    // card:select2 =======

    let tagsSelect2s = document.getElementsByClassName('tags_select2');
    for (tagsSelect2 of tagsSelect2s) {
        let $tagsSelect2 = $(tagsSelect2);
        $tagsSelect2.val(JSON.parse(tagsSelect2.dataset.value));
        $tagsSelect2.select2({
            tags: false,
            placeholder: "Select Tags",
        });
    }

});