// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$( function() {
    $(".div-scripts").draggable({ handle: "#nwgrip-drag" });
    $(".div-scripts").resizable({
	handles: {
            'ne': '#negrip',
            'se': '#segrip',
            'sw': '#swgrip',
            // 'nw': '#nwgrip'
	},
	helper: "ui-resizable-helper",
	stop: function(){
            var h = $(".div-scripts").css("height");
            $(".div-scripts-wrap").css("height", h);
	}
    });

    $(".div-dictionary").draggable({ handle: "#nwgrip-drag" });
    $(".div-dictionary").resizable({
	handles: {
            'se': '#segrip',
	},
	helper: "ui-resizable-helper",
	stop: function(){
            var h = $(".div-dictionary").css("height");
            $(".div-dictionary-wrap").css("height", h);
	}
    });
    
    // $(".div-form").sidebar();
});



function selectWord() {
    var div_name = ".div-dictionary-wrap";
    $(div_name).empty();

    var voc = window.getSelection().toString();
    var req_url = "http://www.dictionaryapi.com/api/v1/references/collegiate/xml/"
                  + voc + "?key=c4c815db-b3ae-4d2f-8e31-2e556ec300bd";
    var yql = 'http://query.yahooapis.com/v1/public/yql?q=' + encodeURIComponent('select * from xml where url="' + req_url + '"') + '&format=xml&callback=?';    

    $.getJSON(yql, function(data){

	// xml parser - https://api.jquery.com/jQuery.parseXML/
	var xml_str = data.results[0];
	var xml = $.parseXML(xml_str);

	// listing of possible definitions of a input word
	$(div_name).append("<ul>");
	$(xml).find("dt").each(function(){
	    $(div_name).append("<li>" + $(this).text() + "</li>");
	});
	$(div_name).append("</ul>");
    });
}

$(document).ready(function (){
   $(".div-scripts p").click(function (){
       selectWord();
   })
});
