// ACE Editor theme :

$(document).ready(function() {

    let editorDoms = document.getElementsByClassName('editor');
    for (editorDom of editorDoms) {

        let aceEditor = ace.edit(editorDom);
        let input = document.getElementById(editorDom.dataset.target);

        aceEditor.setTheme("ace/theme/solarized_light");
        aceEditor.getSession().setMode("ace/mode/ruby");
        aceEditor.getSession().setTabSize(2);
        aceEditor.setValue(input.value, 1); //1 = moves cursor to end

        aceEditor.focus();
        aceEditor.setOptions({
            fontSize: ".95rem",
            showLineNumbers: true,
            showGutter: false,
            vScrollBarAlwaysVisible: true,
            // enableBasicAutocompletion: false,
            // enableLiveAutocompletion: false
        });
        aceEditor.setShowPrintMargin(false);
        aceEditor.setBehavioursEnabled(false);

        aceEditor.getSession().on("change", function() {
            let newValue = aceEditor.getValue();
            input.value = newValue;
        });
    }

    document.getElementById("btn-add-test-code").addEventListener("click", function() {
        addInput = `<input name="card[test_code][]" class="border">`
        console.log('test')
        $("#section-test-code").append(addInput);
    });
});