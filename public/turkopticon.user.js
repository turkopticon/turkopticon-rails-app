// ==UserScript==
// @name          Turkopticon
// @namespace     http://www.ics.uci.edu/~lirani/
// @description	  Report skeezy requesters on Amazon MTurk.
// @author        Lilly Irani and Six Silberman
// @homepage      http://www.ics.uci.edu/~lirani/
// @include       http://*.mturk.com/*
// @include       http://*.factorialthree.org/*
// ==/UserScript==

var TURKOPTICON = "http://turkopticon.differenceengines.com/";

function insertStylesheetTag() {
    var stylesheet_tag = "<link href=\"http://turkopticon.differenceengines.com/stylesheets/widgets.css\" media=\"screen\" rel=\"stylesheet\" type=\"text/css\" />";
    var head = document.getElementsByTagName("head")[0];
    head.innerHTML = stylesheet_tag + head.innerHTML;
}

function insert(n, numReports, numUsers, requesterID, requesterName, hitID) {
    var parent = n.parentNode;
//    var stuff = numReports + ", " + numUsers + " <a href=\"" + requesterID + "\">foo</a>";
    var stuff = "<ul class=\"infoButton\"><li>&#9660;";  // added <label> because .infoButton:hover CSS doesn't work on just span, for some reason
    stuff += "<ul class=\"dropmenu\">";
    stuff += "<li class=\"menuItem\">" + numReports + " reports from " + numUsers + " Turkers</li>";
    stuff += "<li class=\"menuItem\"><a href=\"" + TURKOPTICON + "report?report[hit_id]=" + hitID + "&requester[amzn_name]=" + requesterName + "&requester[amzn_id]=" + requesterID + "\">Report this requester &raquo;</a>";
    stuff += "</li></ul></ul>";
    parent.innerHTML = stuff + parent.innerHTML;
}

function getReqId(n) {
    var href = n.getAttribute('href');
    var first = href.split("=");
    return first[1].split("&")[0];
}

function getReqName(n) {
    var href = n.getAttribute('href');
    return href.split("=")[2].split("&")[0];
}

function getHitId(n) {
    var href = n.getAttribute('href');
    return href.split("HIT+")[1];
}

function parseAndInsert(n) {
    var requesterID = getReqId(n);
    var requesterName = getReqName(n);
    var hitID = getHitId(n);
    var numReports;
    var numUsers;
    GM_xmlhttpRequest({method: 'GET', url: TURKOPTICON + 'requester_stats/' + requesterID,
        onload: function(results, numReports, numUsers) {
                r = results.responseText;
                if (r != "null") {
                    numReports = r.split(",")[0].split(":")[1];
                    numUsers = r.split(",")[1].split(":")[1];
                } else {
                    numReports = "0";
                    numUsers = "0";
                }
                insert(n, numReports, numUsers, requesterID, requesterName, hitID);
            }
        });
}

//==============================

insertStylesheetTag();

var anchors = document.getElementsByTagName("a");
var requesterAnchors = new Array;
for (var i = 0; i < anchors.length; i++) {
    if (anchors[i].getAttribute('title') == "Contact this Requester") {
        requesterAnchors.push(anchors[i]);
    }
}

for (var j = 0; j < requesterAnchors.length; j++) {
    parseAndInsert(requesterAnchors[j]);
}