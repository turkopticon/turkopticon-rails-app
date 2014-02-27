// ==UserScript==
// @name           turkopticon
// @version        devel-2014.01.28.1207
// @description    Review requesters on Amazon Mechanical Turk
// @author         Lilly Irani and Six Silberman
// @homepage       http://turkopticon-devel.differenceengines.com
// @include        http://*.mturk.com/*
// @include        https://*.mturk.com/*
// ==/UserScript==

var TURKOPTICON_BASE = "http://turkopticon.ucsd.edu/";
var API_BASE = "http://turkopticon.ucsd.edu/api/";
var API_MULTI_ATTRS_URL = API_BASE + "multi-attrs.php?ids=";

function getRequesterAnchorsAndIds(a) {
    //a is a list of anchor DOM elements derived in the previous function
        var rai = {};
	var re = new RegExp(/requesterId/);
	var rf = new RegExp(/contact/);
        var isContactLink = new RegExp(/Contact/);
	var isImgButton = new RegExp(/img/);
	var requestersHere = false; 

	for(var i = 0; i < a.length; i++) {
		var href = a[i].getAttribute('href');
		if (re.test(href) /*&& !rf.test(href)*/) {
                    var innards = a[i].innerHTML;
		    if (!isContactLink.test(innards) && !isImgButton.test(innards)) {
			var id = a[i].href.split('requesterId=')[1].split('&')[0]
			if (!rai.hasOwnProperty(id)) {
				rai[id] = []; }
			rai[id].push(a[i]);
			requestersHere = true;
		    } 
		}
	}

	rai = (requestersHere)? rai : null; 
	return rai; 
}

function buildXhrUrl(rai) {
	var url = API_MULTI_ATTRS_URL;
	var ri = Object.keys(rai);
	for(var i = 0; i < ri.length; i++) {
		url += ri[i];
		if (i < ri.length - 1) { url += ","; } }
	return url; }

function makeXhrQuery(url) {
	var xhr = new XMLHttpRequest();
	xhr.open('GET', url, false);
	xhr.send(null);
	var resp = JSON.parse(xhr.response);
	return resp; }

function ul(cl, inner) {
	return "<ul class='" + cl + "'>" + inner + "</ul>"; }

function li(cl, inner) {
	return "<li class='" + cl + "'>" + inner + "</li>"; }

function span(cl, inner) {
	return "<span class='" + cl + "'>" + inner + "</span>"; }

function strmul(str, num) {
	return Array(num + 1).join(str); }

function pad(word, space) {
	if (word.length >= space) { return word; }
	else { return word + strmul("&nbsp;", space - word.length); } }

function long_word(word) {
	switch(word) {
		case "comm": return "communicativity"; break;
		case "pay" : return "generosity"; break;
		case "fair": return "fairness"; break;
		case "fast": return "promptness"; break; } }

function visualize(i, max, size) {
	var color;
	if (i / max <= 2 / 5) { color = 'red'; }
	else if (i / max <= 3 / 5) { color = 'yellow'; }
	else { color = 'green'; }
	var filled = Math.round((i / max) * size);
	var unfilled = size - filled;
	var bar = span("bar", span(color, strmul("&nbsp;", filled)) + span("unf", strmul("&nbsp;", unfilled)));
	return bar; }

function attr_html(n, i) {
	return pad(long_word(n), 15) + ": " + visualize(i, 5, 30) + "&nbsp;" + i + " / 5"; }

function ro_html(ro) {
	var rohtml = "";
	if (typeof ro.attrs != 'undefined') {
		var keys = Object.keys(ro.attrs);
		for (var i = 0; i < keys.length; i++) {
			rohtml += li("attr", attr_html(keys[i], ro.attrs[keys[i]])); } }
	return rohtml; }

function what(ro) {
	var str = "";
	if (typeof ro.attrs != 'undefined') {
		str =  li("gray_link", "<a href='" + TURKOPTICON_BASE + "help#attr'>What do these scores mean?</a>"); }
	return str; }

function nrs(rid, nrevs) {
	var str = "";
	if (typeof nrevs === 'undefined') {
		str = "<li>No reviews for this requester</li>"; }
	else { str = "<li>Scores based on <a href='" + TURKOPTICON_BASE + rid + "'>" + nrevs + " reviews</a></li>"; }
	return str; }

function tos(tosflags) {
	var str = "<li>Terms of Service violation flags: " + tosflags + "</li>";
	return str; }

function rl(rid, name) {
	var rl = "<li><a href='" + TURKOPTICON_BASE + "report?requester[amzn_id]=" + rid;
       	rl    += "&requester[amzn_name]=" + name + "'>";
	rl    += "Report your experience with this requester &raquo;</a></li>";
	return rl; }

function dropDown(ro, rid) {
	var n = ro.name;
	var arrcls = "";
	if (typeof ro.attrs != 'undefined') { arrcls = "toc"; }
	var dd = ul("tob", li(arrcls, "&#9660;") + ul("tom", ro_html(ro) + what(ro) + nrs(rid, ro.reviews) + tos(ro.tos_flags) + rl(rid, n)));
	return dd; }

function insertInlineCss() {
	var css = "<style type='text/css'>\n";
	   css += ".tob, .tom { list-style-type: none; padding-left: 0; }\n";
	   css += ".tob { float: left; margin-right: 5px; }\n";
	   css += ".tob > .tom { display: none; position: absolute; background-color: #ebe5ff; border: 1px solid #aaa; padding: 5px; }\n";
	   css += ".tob:hover > .tom { display: block; }\n";
	   css += ".tob > li { border: 1px solid #9db9d1; background-color: #ebe5ff; color: #00c; padding: 3px 3px 1px 3px; }\n";
	   css += ".tob > li.toc { color: #f33; }\n";
	   css += "@media screen and (-webkit-min-device-pixel-ratio:0) { \n .tob { margin-top: -5px; } \n}\n"
	   css += ".attr { font-family: Monaco, Courier, monospace; color: #333; }\n";
	   css += ".bar { font-size: 0.6em; }\n";
	   css += ".unf { background-color: #ddd; }\n";
	   css += ".red { background-color: #f00; }\n";
	   css += ".yellow { background-color: #f90; }\n";
	   css += ".green { background-color: #6c6; }\n";
	   css += ".gray_link { margin-bottom: 15px; }\n";
	   css += ".gray_link a { color: #666; }\n";
	   css += "</style>";
	var head = document.getElementsByTagName("head")[0];
	head.innerHTML = css + head.innerHTML;
}

function getNamesForEmptyResponses(rai, resp) {
	for(var rid in rai) {
		if (rai.hasOwnProperty(rid) && resp[rid] == "") {
			resp[rid] = JSON.parse('{"name": "' + rai[rid][0].innerHTML + '"}'); } }
	return resp; }

function insertDropDowns(rai, resp) {
	for(var rid in rai) {
		if (rai.hasOwnProperty(rid)) {
			for(var i = 0; i < rai[rid].length; i++) {
				var td = rai[rid][i].parentNode;
				td.innerHTML = dropDown(resp[rid], rid) + " "  + td.innerHTML; } } } }

insertInlineCss();
var a  = document.getElementsByTagName('a');
var reqAnchors = getRequesterAnchorsAndIds(a);
if (reqAnchors) {
    var url = buildXhrUrl(reqAnchors);
    var resp = makeXhrQuery(url);
    resp = getNamesForEmptyResponses(reqAnchors, resp);
    insertDropDowns(reqAnchors, resp);
}