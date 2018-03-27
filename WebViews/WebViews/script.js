
var iosSDKInterface = require('iosSDKInterface');
var currentHTML = location.href.split("/").slice(-1);   //Returns the name of the html file (I.E. index.html)

function passMsg(msg, props) {
    window.location = "tomer://stuff";
    var message = {
        name:msg,
        props: props
    };
    
    window.webkit.messageHandlers.observe.postMessage(message);
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
    var message = {
        name:"bannerClicked",
        props: {}
    };
    window.webkit.messageHandlers.receive.postMessage(message);
}

