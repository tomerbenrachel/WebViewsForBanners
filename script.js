
var iosSDKInterface = require('iosSDKInterface');
var currentHTML = location.href.split("/").slice(-1);   //Returns the name of the html file (I.E. index.html)

function passMsgToJSFromiOS(msg) {
    console.log("Message to pass is " + msg);
    var result = "";
    switch(msg) {
        case "navigate":
            window.location.href="https://www.google.com";
            result = "second";
        break;
        default:
            break;
    }
    
    return result;
}

function passMsg(msg,props) {
    window.location = "tomer://stuff";
    var message = {
        name:msg,
        props: pros
    };
    if (msg === "first") {
        window.webkit.messageHandlers.observe.postMessage(message);
//    } else if (msg === "second") {
//        window.webkit.messageHandlers.observe2.postMessage(message);
//    } else if (msg === "replace") {
//        window.webkit.messageHandlers.observe3.postMessage(message);
//    } else if (msg === "banner") {
//        message.props = props;
//        window.webkit.messageHandlers.banner.postMessage(message);
//    }
}

function calledFromIOS(text) {
    var header = document.querySelector("h3");
    header.innerHTML = text;
}

function loadBanner(imgSrc, props) {
    var data = JSON.parse(props);
    var bannerImg = document.querySelector("img");
    bannerImg.src = imgSrc;
    bannerImg,width = data.width;
    bannerImg.height = data.height;
}

function sendClickToIOS() {
    
}

