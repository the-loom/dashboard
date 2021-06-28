//= require rails-ujs
//= require codemirror/lib/codemirror
//= require codemirror/lib/autorefresh
//= require codemirror/mode/clike/clike
//= require codemirror/mode/python/python
//= require radarChart
//= require moment/moment
//= require moment/locale/es
//= require helpers

function equalizeHeights(selector) {
    var maxHeight = 0;
    $(selector).height('auto');
    $(selector).each(function () {
        var thisH = $(this).height();
        if (thisH > maxHeight) {
            maxHeight = thisH;
        }
    });
    $(selector).height(maxHeight);
}
