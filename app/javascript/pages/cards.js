$(document).on("turbolinks:load", function() {

    $("#btn-show-hints").click(function() {
        $("#section-hints .hint.hidden").first().removeClass("hidden");
    });

    $("#btn-add-test-code").click(function() {
        addInput = `<input name="card[test_code][]">`
        $("#section-test-code").append(addInput);
    });
    $("#btn-add-hints").click(function() {
        addInput = `<input name="card[hints][]">`
        $("#section-hints").append(addInput);
    });

    let editorDoms = document.getElementsByClassName('editor');
    for (editorDom of editorDoms) {

        let aceEditor = ace.edit(editorDom);


        let input = document.getElementById(editorDom.dataset.target);



        aceEditor.setTheme("ace/theme/tomorrow");
        aceEditor.getSession().setMode("ace/mode/ruby");
        aceEditor.getSession().setTabSize(2);
        aceEditor.setValue(input.value, 1);
        aceEditor.setAutoScrollEditorIntoView(true);
        aceEditor.setOption("maxLines", 100);

        aceEditor.focus();

        aceEditor.setOptions({
            fontSize: ".95rem",
            //  showGutter: false, // 摺疊功能
            showLineNumbers: true, // 行數+摺疊
            vScrollBarAlwaysVisible: true,
            autoScrollEditorIntoView: true,
            // maxLines: 8 // 最多行數
        });
        aceEditor.setShowPrintMargin(false);
        aceEditor.setBehavioursEnabled(false);

        aceEditor.getSession().on("change", function() {
            let newValue = aceEditor.getValue();
            input.value = newValue;
        });

        if (editorDom.classList.contains("readonly")) {
            aceEditor.setReadOnly(true); //不可編輯

        }

    }

    $(".form-control").select2({
        tags: true,
    })

});