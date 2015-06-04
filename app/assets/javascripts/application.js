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
    
});

function selectWord(voc) {
    var div_name = ".div-dictionary-wrap";
    // var voc = window.getSelection().toString().trim();
    var req_url = "http://www.dictionaryapi.com/api/v1/references/collegiate/xml/"
                  + encodeURIComponent(voc) + "?key=c4c815db-b3ae-4d2f-8e31-2e556ec300bd";
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

    // alc iframe
    var l = "http://eow.alc.co.jp/search?q=" + voc;
    $(".div-alc #alc").attr("src", l);
}

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
	set_title_tvonline_url();
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
	set_title_springfield_url();
    });
}

function set_title_springfield_url(){
    var l = "http://www.springfieldspringfield.co.uk/episode_scripts.php?tv-show="
	    + $("select#scripts_titles").val();
    $("#para_title_springfield").attr({"href": l});
}

function set_title_tvonline_url(){
    var l = "http://www.tvonline.tw/" + $("select#video_titles").val() + "/";
    $("#para_title_tvonline").attr({"href": l});
}

function toggleShowHideMenu(){
    $(".div-form").toggle();
}



$(function (){ // short for document.ready
    $(".div-scripts").draggable({ handle: "#nwgrip-drag" });
    $(".div-scripts").resizable({
	handles: {
            'se': '.div-scripts #segrip',
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
            'se': '.div-dictionary #segrip',
	},
	helper: "ui-resizable-helper",
	stop: function(){
            var h = $(".div-dictionary").css("height");
            $(".div-dictionary-wrap").css("height", h);
	}
    });
    // $(".div-form").sidebar();

    set_title_springfield_url();
    set_title_tvonline_url();
    $(".div-dictionary").hide();

    var words = "";

    $(".div-scripts p, .div-dictionary").dblclick(function (){
	var w = window.getSelection().toString().trim();
	words = words + " " + w;
	selectWord(words);
	words = "";
	$(".div-scripts p span strong").contents().unwrap();
    });

    $(".div-scripts p span").mouseup(function (evt){
	
	var b = evt.altKey;
	var w = window.getSelection().toString().trim();
	words = words + " " + w;
	if (w != ""){
	    if (b){
		var r = new RegExp(w, 'g');
		var t = $(this).text().replace(r, "<strong>" + w + "</strong>")
		$(this).html(t);
	    }else{
		selectWord(words);
		words = "";
		$(".div-scripts p span strong").contents().unwrap();
	    }
	}
    });

    $("select#scripts_titles").change(function (){
	set_title_springfield_url();
    });
    $("select#video_titles").change(function (){
	set_title_tvonline_url();
    });
});
