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

        let tagsSelect2s = document.getElementsByClassName('tags_select2');
        for (tagsSelect2 of tagsSelect2s) {
            let $tagsSelect2 = $(tagsSelect2);
            $tagsSelect2.val(JSON.parse(tagsSelect2.dataset.value));
            $tagsSelect2.select2({
                tags: true,
            });

        }


    }
    // Swal Alert

    $(".btn-delete").click(function(e) {
        e.preventDefault();
        e.stopPropagation()
        Swal.fire({
            title: 'Are you sure?',
            text: "You won't be able to revert this!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, delete it!'
        }).then((result) => {
            if (result.value) {
                Swal.fire(
                    'Deleted!',
                    'Your file has been deleted.',
                    'success'
                )
                $(this).unbind('click').click().click();
            }

        })
    });

});