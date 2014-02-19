// ==UserScript==
// @name          Turkopticon X
// @version       20100226
// @namespace     http://turkopticon.differenceengines.com/
// @description	  Report skeezy requesters on Amazon MTurk.
// @author        Lilly Irani and Six Silberman
// @homepage      http://turkopticon.differenceengines.com/info
// @include       http://*.mturk.com/*
// @include       https://*.mturk.com/*
// ==/UserScript==

var TURKOPTICON = "http://turkopticon.differenceengines.com/";
var WARN_THRESHOLD = 3;
var SCORE_THRESHOLD = 3;

function insertStylesheetTag() {
    var stylesheet_tag = "<link href=\"" + TURKOPTICON + "stylesheets/widgets2.css\" media=\"screen\" rel=\"stylesheet\" type=\"text/css\" />";
    var head = document.getElementsByTagName("head")[0];
    head.innerHTML = stylesheet_tag + head.innerHTML;
}

function insertAttrsHTML(n, numReports, avgScore, attrVisHTML, requesterID, requesterName, hitID) {
    var parent = n.parentNode;
    var stuff = "<ul class=\"infoButton";
    if (numReports >= WARN_THRESHOLD) {// stuff += " warnButton";  // warnButton is deprecated
	    if (avgScore >= SCORE_THRESHOLD) {
	    	stuff += " goodScore";
	    	stuff += "\"><li>&#9660;";
	    } else {
	    	stuff += " badScore";
	    	stuff += "\"><li><img src=\"" + TURKOPTICON + "warning.png\" />";
	    }
    } else {
		//stuff += "\"><li>&#9660;";
		stuff += "\"><li><strong>?</strong>";
    }
    stuff += "<ul class=\"dropmenu\">";
    stuff += "<li><a href=\"" + TURKOPTICON + "main/x#icons\" id=\"helplink\">What do the icons mean?</a></li>"
    if (numReports != "0") {
        stuff += "<li class=\"menuItem attrs\">" + attrVisHTML + "</li>";
        stuff += "<li class=\"menuItem\"><a href=\"" + TURKOPTICON + "main/help#attr\" id=\"helplink\">What do these scores mean?</a></li>";
        stuff += "<a href=" + TURKOPTICON + requesterID + ">";
    }
    stuff += "<br/>";
    stuff += "<li class=\"menuItem\">Scores based on " + numReports + " reviews</li>";
    if (numReports != "0") stuff += "</a>";
    stuff += "<li class=\"menuItem\"><a href=\"" + TURKOPTICON + "report?report[hit_id]=" + hitID + "&requester[amzn_name]=" + requesterName + "&requester[amzn_id]=" + requesterID;
    stuff += "&url=" + window.location.toString();
    stuff += "\">Report your experience with this requester &raquo;</a>";
    stuff += "</li></ul></ul>";
    var pie = document.getElementById("pie");
    pie.parentNode.removeChild(pie);
    parent.innerHTML = stuff + parent.innerHTML;
}

function getReqId(n) {
    var href = n.getAttribute('href');
	if (href==null) return "";
	var splitArr = href.split("requesterId="); 
	if (splitArr.length == 1) return "";
	return splitArr[1].split("&")[0];
}

function getReqName(n) {
    var href = n.getAttribute('href');
	if (href==null) return "";
	var splitArr = href.split("requesterName="); 
	if (splitArr.length == 1) {
	   return n.innerHTML;
	} else {
        return splitArr[1].split("&")[0];
	}
}

function getHitId(n) {
    var href = n.getAttribute('href');
    return href.split("HIT+")[1];
}

function insertPie(n) {
    var parent = n.parentNode;
    var pie = "<img src=\"http://turkopticon.differenceengines.com/pie.gif\" alt=\"Loading...\" id=\"pie\" />";
    parent.innerHTML = pie + parent.innerHTML;
}

function parseAndInsert(n) {
    var requesterID = getReqId(n);
    var requesterName = getReqName(n);
    var hitID = getHitId(n);
    var numReports;
    var attrVisHTML;
    var avgScore;
//    GM_xmlhttpRequest({method: 'GET', url: TURKOPTICON + 'attrs/' + requesterID,
    GM_xmlhttpRequest({method: 'GET', url: TURKOPTICON + 'main/requester_attrs_2/' + requesterID,
        onload: function(results, numReports, numUsers) {
                r = results.responseText;
                if (r != "null") {
                    numReports = r.split("numReports:")[1];
                    attrVisHTML = r.split("numReports:")[0].split("#")[1]
                    avgScore = r.split("avg:")[1].split("<br/>")[0];
                } else {
                    numReports = "0";
                    attrVisHTML = "";
                    avgScore = "0";
                }
                insertAttrsHTML(n, numReports, avgScore, attrVisHTML, requesterID, requesterName, hitID);
            }
        });
}

function getRequesterAnchors() {
    var anchors = document.getElementsByTagName("a");
    var requesterAnchors = new Array;
    for (var i = 0; i < anchors.length; i++) {
        if (getReqId(anchors[i]) != "") {
            requesterAnchors.push(anchors[i]);
        }
    }
    return requesterAnchors;
}

function getFirstRequesterAnchor(str) {  // returns node corresponding to first anchor linking to requesterID str
    var ra = getRequesterAnchors();
    for (var i = 0; i < ra.length; i++) {
        if (ra[i].href.match(str)) {
            return ra[i];
        }
    }
    return null;
}

function insertNotice() {
    var location = window.location.toString();
    if (location.match("&updated=")) {
        // expect URL of the form https://www.mturk.com/mturk/findhits?match=false&updated=A1HN60FBRYG4JS
        var n = getFirstRequesterAnchor(location.split("&updated=")[1]);
        if (n != null) {
            var td = n.parentNode;
            td.innerHTML = td.innerHTML + "<span class=\"mturk_feedback\">Review saved.</span>";
        }
    }
}

//==============================

insertNotice();

insertStylesheetTag();

var requesterAnchors = getRequesterAnchors();

for (var i = 0; i < requesterAnchors.length; i++) {
    insertPie(requesterAnchors[i]);
}

var requesterAnchors = getRequesterAnchors();

for (var k = 0; k < requesterAnchors.length; k++) {
    parseAndInsert(requesterAnchors[k]);
}