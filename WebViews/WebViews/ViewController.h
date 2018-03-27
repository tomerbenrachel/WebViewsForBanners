//
//  ViewController.h
//  WebViews
//
//  Created by Tomer Ben-Rachel on 25/03/2018.
//  Copyright © 2018 Tomer Ben-Rachel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ViewController : UIViewController <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, NSURLConnectionDelegate> {
    WKWebView *webView;
    WKWebView *secondWebView;
    BOOL isSecondWebViewExpanded;
    BOOL isBannerShown;
    CGRect frameForBanner;
}

@end

