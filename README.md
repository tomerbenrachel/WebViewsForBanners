# WebViewsForBanners
Research communication between multiple web views


## Conclusions
- Setting a configuration for each WKWebView using WKWebViewConfiguration and WKUserController
- userContentController method to receive messages from JS to native
- window.webkit.messageHandlers.*LISTENER_NAME*.postMessage(*DATA*)

### LISTENER_NAME
Is the name set natively using the *[controller addScriptMessageHandler]* method

### DATA
Is an object that contains information passed from JS to Native

