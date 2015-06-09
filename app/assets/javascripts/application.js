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
    
    $(".div-alc #alc").load( function() {
	$( ".div-alc" ).scrollTop(350);
    } );
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



function set_embed_video_url(url, i){
    $("a#vurl").attr("href", url);
    $(".para span").text("index: " + i.toString());
    var yql = 'http://query.yahooapis.com/v1/public/yql?q=' 
                + encodeURIComponent('select * from html where url="' + url + '"')
                + '&format=xml&callback=?';
    $.getJSON(yql, function(data){
	var html_str = data.results[0];
	var html = $.parseHTML(html_str);
        var a = $(html).find("#linkname_nav a")[i];
	var eurl = $(a).attr("onclick").match(/'(.*)'/)[1];
	$("iframe#video").attr("src", eurl);
	$("a#eurl").attr("href", eurl);
    });
}

function set_scripts(url){
    $("a#surl").attr("href", url);
    var yql = 'http://query.yahooapis.com/v1/public/yql?q=' 
                + encodeURIComponent('select * from html where url="' + url + '"')
                + '&format=xml&callback=?';
    $.getJSON(yql, function(data){
	var html_str = data.results[0];
	var html = $.parseHTML(html_str);
	var scripts = $(html).find("div.scrolling-script-container").html().split("<br>")
	              .map(function(s){
                        return "<span>" + s.replace(/(\r\n|\n|\r)/gm, "").trim() + "</span>";
		      }).join("<br>");
	$(".div-scripts p").html(scripts);
	scriptsLoaded()
    });
}

function update1(){
    var url1 = $("input#tvonline_url").val();
    var i = parseInt($("input#index").val());
    var url2 = $("input#scripts_url").val();

    set_embed_video_url(url1, i);
    set_scripts(url2);
}

function set_embed_video_url2(vtitle, s, e){
    var url = "http://www.tvonline.tw/" + vtitle + "/season-" + s + "-episode-" + e + "/"
    var i = parseInt($("input#index").val());
    if(isNaN(i)){i = 0;}
    set_embed_video_url(url, i);
}

function set_scripts2(stitle, s, e){
    if(s.length == 1){s = "0" + s;}
    if(e.length == 1){e = "0" + e;}
    var url = "http://www.springfieldspringfield.co.uk/view_episode_scripts.php?tv-show="
	      + stitle + "&episode=s" + s + "e" + e
    set_scripts(url);
}

function update2(){
    var vtitle = $("#video_titles").val();
    var stitle = $("#scripts_titles").val();
    var sea = $("input#season").val();
    var epi = $("input#episode").val();

    set_embed_video_url2(vtitle, sea, epi);
    set_scripts2(stitle, sea, epi);
}

var w_apple = "";
var s_apple = "";
function toAppleScript(){ // return the pair of a word (or words) and its whole sentense
    var t = $("select#scripts_titles").val();
    var s = $("input#season").val();
    var e = $("input#episode").val();
    if(t == ""){t = "hoge"}
    if(s == ""){s = "0"}
    if(e == ""){e = "0"}

    if(w_apple.trim() != ""){
	// return [t, s, e, w_apple.trim(), s_apple.trim()];
	$.ajax({
	    url: "/top/record",
	    type: "POST",
	    data: {returns: {title: t,
			     season: s,
			     episode: e,
			     word: w_apple.trim(),
			     sentence: s_apple.trim()}},
	    success: function(events){ console.log("success");},
	    error: function(){ console.log("error");}
	});
    }

}


function scriptsLoaded(){
    var words = "";
    // //// some trick to handle both single <1> and double <2> click events ////
    var DELAY = 200, clicks = 0, timer = null;
    $(".div-scripts p span").on("mouseup", function(e){
        clicks++;
    	var w = window.getSelection().toString().trim();
	var $obj = $(this);
        if(clicks === 1) {
            timer = setTimeout(function() {
    		//// single click hander <1> ////
    		if (w != ""){
		    s_apple = $obj.text();
    		    words = words + " " + w;
    		    var r = new RegExp(w, 'g');
    		    var t = $obj.html().replace(r, "<strong>" + w + "</strong>");
    		    $obj.html(t);
    		}else{
		    if (words != ""){
			w_apple = words;
    			selectWord(words);
    			words = "";
    			$(".div-scripts p span strong").contents().unwrap();
		    }
    		}
    		//// single click hander ////
                clicks = 0;
            }, DELAY);
        } else {
            clearTimeout(timer);
    	    //// double click handler <2> ////
    	    if (w != ""){
    		words = words + " " + w;
		s_apple = $obj.text();
    		var r = new RegExp(w, 'g');
    		var t = $obj.html().replace(r, "<strong>" + w + "</strong>");
    		$obj.html(t);
    	    }
    	    //// double click handler ////
            clicks = 0;
        }
    }).on("dblclick", function(e){
        e.preventDefault();
    });
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

    set_title_springfield_url();
    set_title_tvonline_url();
    $(".div-dictionary").hide();

    $("select#scripts_titles").change(function (){
	set_title_springfield_url();
    });
    $("select#video_titles").change(function (){
	set_title_tvonline_url();
    });
});



// for top/view

function get_titles(){
    $.ajax({
	url: "/top/ajax_titles",
	type: "GET",
	dataType: "xml",
	success: function(xml){
	    $("#select_title").empty();
	    $(xml).find("object").each(function(){
		var i = $(this).find("id").text();
		var t = $(this).find("name").text();
		$("#select_title").append(
		    $("<option>").val(i).append(t));
	    });
	    get_numbers();
	},
	error: function(){ console.log("error");}
    });
}


function get_numbers(){
    t = $("select#select_title").val()
    $.ajax({
	url: "/top/ajax_numbers",
	type: "POST",
	data: {returns: {title: t}},
	dataType: "xml",
	success: function(xml){
	    $("#select_number").empty();
	    $(xml).find("object").each(function(){
		var i = $(this).find("id").text();
		var s = $(this).find("season").text();
		var e = $(this).find("episode").text();
		$("#select_number").append(
		    $("<option>").val(i).append(s + " - " + e));
	    });
	    get_vocabs()
	},
	error: function(){ console.log("error");}
    });
}

function get_vocabs(){
    n = $("select#select_number").val()
    $.ajax({
	url: "/top/ajax_vocabs",
	type: "POST",
	data: {returns: {number: n}},
	dataType: "xml",
	success: function(xml){
	    console.log("success");
	    $(".vocabularies").empty();
	    $(xml).find("object").each(function(){
	    	var i = $(this).find("id").text();
	    	var w = $(this).find("word").text();
	    	var s = $(this).find("sentence").text();
	    	var p = $(this).find("picture").text();
	    	$(".vocabularies").append(
	    	    $("<div>").attr("class", "vocabulary")
			.append($("<span>").attr("class", "word").text(w))
			.append($("<span>").attr("class", "sentence").text(s))
			.append($("<img>").attr("src", "/screenshots/" + p).hide())
		);
	    });
	},
	error: function(){ console.log("error");}
    });
}

$(function (){
    get_titles();
})


////////////////////////
// for lesson/scripts //
////////////////////////

function set_scripts4(url){
    $("a#surl").attr("href", url);
    var yql = 'http://query.yahooapis.com/v1/public/yql?q=' 
                + encodeURIComponent('select * from html where url="' + url + '"')
                + '&format=xml&callback=?';
    $.getJSON(yql, function(data){
	var html_str = data.results[0];
	var html = $.parseHTML(html_str);
	var scripts = $(html).find("div.scrolling-script-container").html().split("<br>")
	              .map(function(s){
                        return "<span>" + s.replace(/(\r\n|\n|\r)/gm, "").trim()
			       + "<button> open! </button>"  + "</span>";
		      }).join("<br>");
	$(".div-blank p").html(scripts);
    });
}

function set_scripts3(stitle, s, e){
    if(s.length == 1){s = "0" + s;}
    if(e.length == 1){e = "0" + e;}
    var url = "http://www.springfieldspringfield.co.uk/view_episode_scripts.php?tv-show="
	      + stitle + "&episode=s" + s + "e" + e
    set_scripts4(url);
}

function update3(){
    var stitle = $("#scripts_titles").val();
    var sea = $("input#season").val();
    var epi = $("input#episode").val();

    set_scripts3(stitle, sea, epi);
}

// http://nlp.naturalparsing.com/documentation/jstutorial
var ignores = ["NNP", "PRP", "DT", ".", ",", ":"];
// function nlp_test(){
//     var s1 = "That is so, Kids, get down here! Mr. Dunphy is smart. You're such a dork. Why are you guys yelling at us, when we're way upstairs, just text me.";
//     var s2 = "Alright, That's not gonna happen, and, wow, you're not wearing that outfit.";
//     nlp.getParse(s1 + "- I'm hungry.",
// 		 function(data){ console.log(JSON.stringify(data, null, 2));
// 				 var ws = data.words;
// 				 ws = _.filter(ws,
// 					       function(w){
// 						   return  _.every(ignores, 
// 								   function(t){ return w.tag != t})
// 					       });
// 				 console.log(ws.map(function(w){return w.value;}));
// 		                 // console.log(data.words[3].value);
// 		                 // console.log(data.words[3].tag);
// 			       });
// }

// tag lists -- http://www.comp.leeds.ac.uk/amalgam/tagsets/upenn.html
// var ignores = ["NNP", "PRP", "DT", ".", ",", ":"];
// var $nlp_obj = $();
// function cbf(data){
//     var ws = data.words;
//     ws = _.filter(ws,
// 		  function(w){
// 		      return  _.every(ignores, 
// 				      function(t){ return w.tag != t;});
// 		  })
//     ws = _.uniq(ws.map(function(w){return w.value;}));
//     // console.log(ws);
//     console.log("nlp_obj:" + $nlp_obj.html());
//     ws.forEach(function(w){
//     	var r = new RegExp(w, 'g');
// 	// console.log($nlp_obj.html());
// 	console.log("here2: replace");
//     	var t = $nlp_obj.html().replace(r, "<ins>" + w + "</ins>");
//     	$nlp_obj.html(t);
//     });
// }

function blanky(){
    $(".div-blank p span").each(function (){
	ws = ($(this).text().match(/(\w|')+/g));
	console.log(ws);
	var rw = [];
	for(var i = 0; i < ws.length; i++){
	    if(i % 3 != 0  && ws[i].length > 2 )
	    { rw.push( ws[i] ); }
	}
	console.log(rw);
	var r = new RegExp(rw.join("|"), 'g');
	console.log(r);
	var t = $(this).html().replace(r, function(w){return "<ins>" + w  + "</ins>";});
	$(this).html(t);
	$(this).find("ins").click(function(){
	    if( $(this).css("color") == "rgb(0, 0, 0)" )
	    {
		$(this).css("color", "rgb(238, 127, 61)");		
	    }else{
		$(this).css("color", "black");
	    }
	});
	var $span = $(this);
	$span.find("button").click(function(){
	    if( $span.find("ins").css("color") == "rgb(0, 0, 0)" )
	    {
		$span.find("ins").css("color", "rgb(238, 127, 61)");
	    }else{
		$span.find("ins").css("color", "rgb(0, 0, 0)");
	    }
	});
    });
    $(".div-blank button").show();
}

function unblanky(){
    $(".div-blank p span ins").contents().unwrap();
    $(".div-blank button").hide();
}


$(function (){
    $("select#scripts_titles").append(
	$("<option>").val("modern-family").text("modern-family"));
    $("input#season").val("1");
    $("input#episode").val("1");
})
