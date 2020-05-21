$(document).on("turbolinks:load", function() {
    let editorDoms = document.getElementsByClassName('editor');
    for (editorDom of editorDoms) {

        let aceEditor = ace.edit(editorDom);
        let input = document.getElementById(editorDom.dataset.target);
        aceEditor.setTheme("ace/theme/gruvbox");
        aceEditor.getSession().setMode("ace/mode/ruby");
        aceEditor.getSession().setTabSize(2);
        aceEditor.setValue(input.value, 1);

        aceEditor.focus();
        aceEditor.setOptions({
            fontSize: ".95rem",
            showLineNumbers: true,
            showGutter: false,
            vScrollBarAlwaysVisible: true,
        });
        aceEditor.setShowPrintMargin(false);
        aceEditor.setBehavioursEnabled(false);

        aceEditor.getSession().on("change", function() {
            let newValue = aceEditor.getValue();
            input.value = newValue;
        });
    }
    let tagsSelect2s = document.getElementsByClassName('tags_select2');
    for (tagsSelect2 of tagsSelect2s) {
        let $tagsSelect2 = $(tagsSelect2);
        $tagsSelect2.val(JSON.parse(tagsSelect2.dataset.value));
        $tagsSelect2.select2({
          tags: true,
        });
        
    } 
    // $(".form-control").select2({
    //     tags: true,
    // })

    // document.getElementById("btn-add-test-code").addEventListener("click", function() {
    $("#btn-add-test-code").click(function() {
        addInput = `<input name="card[test_code][]">`
        $("#section-test-code").append(addInput);
    });
    $("#btn-add-hints").click(function() {
        // document.getElementById("btn-add-hints").addEventListener("click", function() {
        addInput = `<input name="card[hints][]">`
        $("#section-hints").append(addInput);
    });
});