//= require rails-ujs
//= require codemirror/lib/codemirror
//= require codemirror/lib/autorefresh
//= require codemirror/mode/clike/clike
//= require codemirror/mode/python/python
//= require codemirror/mode/css/css
//= require codemirror/mode/javascript/javascript
//= require codemirror/mode/sql/sql
//= require codemirror/mode/xml/xml
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

navExpands = function () {
  $('button.lines-button.x').addClass('close');
  $('nav#sidebar-menu').show();
  $('#navbarNavDropdown').show();
  $('nav.navbar').addClass('open');
  $('body').addClass('no-scroll');
}
navCollapses = function () {
  $('button.lines-button.x').removeClass('close');
  $('nav#sidebar-menu').hide();
  $('#navbarNavDropdown').hide();
  $('nav.navbar').removeClass('open');
  $('body').removeClass('no-scroll');
}


$(document).ready(function(){
  // FAQ Toggles
  $('a.toggle-trigger').click(function() {
    $(this).next('.toggle-content').slideToggle(250);
    $(this).parent().toggleClass('open');
    return false;
  });

  // Sidebar Toggle
  $('a.sidebar-toggle').click(function() {
    $('#sidebar-menu, .corner, a.sidebar-toggle').toggleClass('go-hide');
    $(this).toggleClass('reverse');
    $('main').toggleClass('expand');
    return false;
  });

  // Animated Hamburger Icon  
  $('body').on('click', 'button.lines-button.x', function (){
    if ( !$('button.lines-button').hasClass('close') ) {
      navExpands();  
    } else {
      navCollapses();
    }      
    return false;
  });

});
