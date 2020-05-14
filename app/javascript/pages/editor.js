// ACE Editor theme :

$(document).ready(function() {
    let editorDoms = document.getElementsByClassName('editor');
    for (editorDom of editorDoms) {
        console.log(editorDom)
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





    // function setupEditorRubyTest() {
    //     window.editorRubyTest = ace.edit("editorRubyTest");
    //     editorRubyTest.setTheme("ace/theme/solarized_light");
    //     editorRubyTest.getSession().setMode("ace/mode/ruby");
    //     editorRubyTest.getSession().setTabSize(2);
    //     editorRubyTest.setValue(``, 1); //1 = moves cursor to end


    //     editorRubyTest.focus();
    //     editorRubyTest.setOptions({
    //         fontSize: ".95rem",
    //         showLineNumbers: true,
    //         showGutter: false,
    //         vScrollBarAlwaysVisible: true,
    //         enableBasicAutocompletion: false,
    //         enableLiveAutocompletion: false
    //     });
    //     editorRubyTest.setShowPrintMargin(false);
    //     editorRubyTest.setBehavioursEnabled(false);
    // }

    // function setupEditorRubyDefult() {
    //     window.editorRubyDefult = ace.edit("editorRubyDefult");
    //     editorRubyDefult.setTheme("ace/theme/solarized_light");
    //     editorRubyDefult.getSession().setMode("ace/mode/ruby");
    //     editorRubyDefult.getSession().setTabSize(2);
    //     editorRubyDefult.setValue(``, 1); //1 = moves cursor to end

    //     editorRubyDefult.focus();
    //     editorRubyDefult.setOptions({
    //         fontSize: ".95rem",
    //         showLineNumbers: true,
    //         showGutter: false,
    //         vScrollBarAlwaysVisible: true,
    //         enableBasicAutocompletion: false,
    //         enableLiveAutocompletion: false
    //     });
    //     editorRubyDefult.setShowPrintMargin(false);
    //     editorRubyDefult.setBehavioursEnabled(false);
    // }

    // function setupEditorRubyAnswer() {
    //     window.editorRubyAnswer = ace.edit("editorRubyAnswer");
    //     editorRubyAnswer.setTheme("ace/theme/solarized_light");
    //     editorRubyAnswer.getSession().setMode("ace/mode/ruby");
    //     editorRubyAnswer.getSession().setTabSize(2);
    //     editorRubyAnswer.setValue(``, 1); //1 = moves cursor to end

    //     editorRubyAnswer.focus();
    //     editorRubyAnswer.setOptions({
    //         fontSize: ".95rem",
    //         showLineNumbers: true,
    //         showGutter: false,
    //         vScrollBarAlwaysVisible: true,
    //         enableBasicAutocompletion: false,
    //         enableLiveAutocompletion: false
    //     });
    //     editorRubyAnswer.setShowPrintMargin(false);
    //     editorRubyAnswer.setBehavioursEnabled(false);
    // }

    // setupEditorRubyTest();
    // setupEditorRubyDefult();
    // setupEditorRubyAnswer();

});