$(document).on("turbolinks:load", function() {
    // profile tab switch =======
    $("#profile-tab-cards").addClass("active");
    $("#profile-boards").hide();

    $("#profile-tab-boards").on("click", function() {
        $("li#profile-tab-cards").removeClass("active");
        $("#profile-tab-boards").addClass("active");
        $("#profile-cards").hide();
        $("#profile-boards").show();
    });
    $("#profile-tab-cards").on("click", function() {
        $("#profile-tab-boards").removeClass("active");
        $("#profile-tab-cards").addClass("active");
        $("#profile-boards").hide();
        $("#profile-cards").show();
    });
});