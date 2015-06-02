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
    var voc = window.getSelection().toString();
    var req_url = "http://www.dictionaryapi.com/api/v1/references/collegiate/xml/"
                  + voc + "?key=c4c815db-b3ae-4d2f-8e31-2e556ec300bd";
    var yql = 'http://query.yahooapis.com/v1/public/yql?q=' 
               + encodeURIComponent('select * from xml where url="' + req_url + '"')
               + '&format=xml&callback=?';    

    $.getJSON(yql, function(data){

	// xml parser - https://api.jquery.com/jQuery.parseXML/
	var xml_str = data.results[0];
	var xml = $.parseXML(xml_str);

	$(div_name).empty();
	if( $(xml).find("dt").size() != 0 ){

	    // listing of possible definitions of a input word
	    $(div_name).append( $("<p>").append("[meanings - " + voc + "]") );
	    $(div_name).append("<ul>");
	    $(xml).find("dt").each(function(){
		$(div_name).append("<li>" + $(this).text() + "</li>");
	    });
	    $(div_name).append("</ul>");

	}else{

	    // if the word doesn't match, return suggestions
	    $(div_name).append( $("<p>").append("[suggestions - " + voc + "]") );
	    $(div_name).append("<ul>");
	    $(xml).find("suggestion").each(function(){
		$(div_name).append("<li>" + $(this).text() + "</li>");		
	    });
	    $(div_name).append("</ul>");
	}
    });
}

$(document).ready(function (){
   $(".div-scripts p, .div-dictionary").dblclick(function (){
       selectWord();
   })
});

function searchTitles() {
    var inq = $("#title_inquiry").val();

    // search in tvonline
    var req_url = "http://www.tvonline.tw/search.php?key=" + encodeURIComponent(inq);
    var yql = 'http://query.yahooapis.com/v1/public/yql?q=' 
                + encodeURIComponent('select * from html where url="' + req_url + '"')
                + '&format=xml&callback=?';    
    $.getJSON(yql, function(data){
	var html_str = data.results[0];
	var html = $.parseHTML(html_str);
        $("#video_titles").empty();
        $(html).find(".found a").each(function(){
	    var l = $(this).attr("href").match(/(.*)\//)[1];
	    $("#video_titles").append(
		$("<option>").val(l).append(l));
	});
    });

    // search in springfield
    var req_url ="http://www.springfieldspringfield.co.uk/tv_show_episode_scripts.php?search="
                  + encodeURIComponent(inq);
    var yql = 'http://query.yahooapis.com/v1/public/yql?q=' 
                + encodeURIComponent('select * from html where url="' + req_url + '"')
                + '&format=xml&callback=?';    
    $.getJSON(yql, function(data){
	var html_str = data.results[0];
	var html = $.parseHTML(html_str);
        $("#scripts_titles").empty();
        $(html).find(".script-list-item").each(function(){
	    var l = $(this).attr("href").match(/.*tv-show=(.*)/)[1];
	    $("#scripts_titles").append(
		$("<option>").val(l).append(l));
	});
    });
}
