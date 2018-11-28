// Adapted from Spark project:
// https://github.com/apache/spark-website/blob/asf-site/js/lang-tabs.js

function changeLanguage(lang) {
    return function(e) {
        e.preventDefault();
        var scrollOffset = $(this).offset().top - $(document).scrollTop();
        $(".tab-pane").removeClass("active");
        $(".tab-pane-" + lang).addClass("active");
        $(".lang-tab").removeClass("active");
        $(".lang-tab-" + lang).addClass("active");
        $(document).scrollTop($(this).offset().top - scrollOffset);
    };
}

$(function() {
    var languages = ["macaulay2", "matlab", "julia"];
    for (var i = 0; i < languages.length; i++) {
        var lang = languages[i];
        $(".lang-tab-" + lang).click(changeLanguage(lang));
    }
});
