/* globals require, module, jQuery */
function iOSSDKInterface(ud) { //TODO - wtf?! supposed to take two parameters

    //var jQuery = controller.jQuery(); //TODO: is there a better way to get jQuery
    var callSdk = function(prefix, eventName, parameters){
        var ssa = prefix + "://" + eventName + "?";
        var fullCall;

        jQuery.each(parameters, function(k, v){
            if (typeof v === 'object') {
                parameters[k] = JSON.stringify(v);
            }
        });

        fullCall = ssa + jQuery.param(parameters);
        queueSDKCalls(fullCall);
    };

    var fireEvent = function(eventUrl)
    {
        var iframe = document.createElement("IFRAME");
        iframe.setAttribute("src", eventUrl);
        document.documentElement.appendChild(iframe);
        iframe.parentNode.removeChild(iframe);
        iframe = null;
    };

    var queueSDKCalls = function(fullCall){
        //first call is invoked immediately. The others go to the queue for later invocation
        if (queue.length === 0) {
            queue.push("1");//Push dummy data in order to fill the queue
            fireEvent(fullCall);
        }
        else{
            queue.push(fullCall);
        }
    };

    var callbacks = {
        "postMessage": function(prefix, eventName, parameters) {
            //TODO: add authentication
            callSdk(prefix, eventName, parameters);
        }

    };

    //a Queue holding iOS SDK calls
    var queue = [];

    var ret =  {
        postMessage : function(message) {
            if (typeof message.eventName !== ud && typeof message.prefix !== ud && typeof message.parameters !== ud) {
                if (typeof callbacks[message.eventName] === "function") {
                    callbacks[message.eventName](message.parameters);
                } else {
                    callbacks.postMessage(message.prefix, message.eventName, message.parameters);
                }
            }
        },
        acknowledgeMessage : function(/*a*/){
            //TODO: handle a?
            if ( queue.length === 0 ) {
                return;
            }

            //take next call in the queue
            var nextCall = queue.shift();

            //if this was the first call (with dummy data) - look for next call
            if ( nextCall === "1" && queue.length !== 0 ) {
                nextCall = queue.shift();
            }

            //apply call
            if (nextCall !== undefined && nextCall !== "1") {
                //firedEvent.attr('src', nextCall);
                fireEvent(nextCall);
            }
        }
    };

    /* jshint ignore:start */
    if(TEST_FLAG){
        ret.test = function() {
            var re = /(\(\))$/,
                args = [].slice.call(arguments),
                name = args.shift(),
                is_method = re.test(name),
                target;

            name = name.replace(re, '');
            target = eval(name);
            return is_method ? target.apply(this, args) : target;
        };
    }
    /* jshint ignore:end */

    return ret;

}

/* jshint ignore:start */
if(TEST_FLAG) {
    window.Ios = iOSSDKInterface;
}
/* jshint ignore:end */

module.exports = iOSSDKInterface;