function cookie_update(){
    Cookies.set('ok','ok');

    Cookies.set('1', $("#video_titles    " ).val());
    Cookies.set('2', $("#scripts_titles  " ).val());
    Cookies.set('3', $("#season          " ).val());
    Cookies.set('4', $("#episode         " ).val());
    Cookies.set('5', $("#tvonline_url    " ).val());
    Cookies.set('6', $("#index           " ).val());
    Cookies.set('7', $("#scripts_url     " ).val());
}

function set_from_cookie(){
    $("#video_titles").append(
	$("<option>").val(Cookies.get('1')).append(Cookies.get('1')));
    $("#scripts_titles").append(
	$("<option>").val(Cookies.get('2')).append(Cookies.get('2')));
    $("#season		").val(Cookies.get('3')); 
    $("#episode		").val(Cookies.get('4')); 
    $("#tvonline_url	").val(Cookies.get('5')); 
    $("#index		").val(Cookies.get('6')); 
    $("#scripts_url	").val(Cookies.get('7')); 
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
    $("#tvonline_url").val(url);
    set_embed_video_url(url, i);
}

function set_scripts2(stitle, s, e){
    if(s.length == 1){s = "0" + s;}
    if(e.length == 1){e = "0" + e;}
    var url = "http://www.springfieldspringfield.co.uk/view_episode_scripts.php?tv-show="
	      + stitle + "&episode=s" + s + "e" + e
    $("#scripts_url").val(url);
    set_scripts(url);
}

function update2(){
    var vtitle = $("#video_titles").val();
    var stitle = $("#scripts_titles").val();
    var sea = $("input#season").val().trim();
    var epi = $("input#episode").val().trim();

    set_embed_video_url2(vtitle, sea, epi);
    set_scripts2(stitle, sea, epi);
    cookie_update();
}


function toggleShowHideMenu(){
    $(".div-form").toggle();
}

$(function (){
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

    $("select#scripts_titles").change(function (){
	set_title_springfield_url();
    });
    $("select#video_titles").change(function (){
	set_title_tvonline_url();
    });

    $("body").css("background-color", "rgb(50, 92, 48)");



    if(Cookies.get('ok')){
	set_from_cookie();
    }else{
	$("#title_inquiry").val("game of thrones");
	searchTitles();
	$("#season").val("1");
	$("#episode").val("1");
	$("#index").val("0");
    }
});
