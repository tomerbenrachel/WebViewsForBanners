//
//  ViewController.m
//  WebViews
//
//  Created by Tomer Ben-Rachel on 25/03/2018.
//  Copyright © 2018 Tomer Ben-Rachel. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    secondWebView = nil;
    isSecondWebViewExpanded = NO;
    isBannerShown = NO;
    
    //Code to allow listening to messages from webview
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *controller = [[WKUserContentController alloc] init];
    [controller addScriptMessageHandler:self name:@"observe"]; //observe is used as an identifier in the webview to send messages to
    configuration.userContentController = controller;
    webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];

    webView.navigationDelegate = self; //IMPORTANT in order to listen in on events
    [self.view addSubview:webView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

}

- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:message.body[@"props"] options:NSJSONWritingSortedKeys error:&error];
    
    if(!jsonData) {
        NSLog(@"JSON ERROR");
        return;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if ([message.body[@"name"] isEqualToString:@"openBanner"]) {
        NSLog(@"userContentController openBanner");
        isBannerShown = YES;
        if(secondWebView == nil) {
            [self prepareSecondWebViewForPresentation:jsonString];
        } else {
            [self destroyBannerWebView];
            [self prepareSecondWebViewForPresentation:jsonString];
        }
    } else if([message.body[@"name"] isEqualToString:@"closeBanner"]) {
         NSLog(@"userContentController closeBanner");
        isBannerShown = NO;
        [self destroyBannerWebView];
    } else if([message.body[@"name"] isEqualToString:@"bannerClicked"]) {
        NSLog(@"Banner was clicked");
        [self handleBannerClick];
    }
}

- (void)prepareSecondWebViewForPresentation:(NSString*)data {
    
    NSError *error = nil;
    NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if(error != nil) {
        NSLog(@"prepareSecondWebViewForPresentation JSON Error %@", [error localizedDescription]);
        return;
    }
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *controller = [[WKUserContentController alloc] init];
    [controller addScriptMessageHandler:self name:@"receive"]; //receive is used as an identifier in the webview to send messages to
    configuration.userContentController = controller;
    
    CGSize viewCtrlDimensions = [[UIScreen mainScreen] bounds].size;
    frameForBanner = CGRectMake(0, viewCtrlDimensions.height - [[json valueForKey:@"height"] floatValue],
                                        [[UIScreen mainScreen] bounds].size.width, [[json valueForKey:@"height"] floatValue]);
    secondWebView = [[WKWebView alloc] initWithFrame:frameForBanner configuration:configuration];
    secondWebView.contentMode = UIViewContentModeScaleAspectFit;
    secondWebView.scrollView.scrollEnabled = NO;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index2" ofType:@"html"];
    NSURL *urlForSecondWebView = [NSURL fileURLWithPath:path];
    [secondWebView loadRequest:[NSURLRequest requestWithURL:urlForSecondWebView]];
    
    [self.view addSubview:secondWebView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError : %@", [error localizedDescription]);
}


- (void)willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [webView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    if(isBannerShown) {
        NSLog(@"willAnimateRotationToInterfaceOrientation isBannerShown");
        [secondWebView setFrame:CGRectMake(0, webView.frame.size.height - secondWebView.frame.size.height, webView.frame.size.width, secondWebView.frame.size.height)];
    }
}

- (void)destroyBannerWebView {
    [secondWebView removeFromSuperview];
    secondWebView = nil;
}

//secondWebView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);

- (void)handleBannerClick {
    isSecondWebViewExpanded = !isSecondWebViewExpanded;
    if(isSecondWebViewExpanded) {
        NSURL *videoURL = [NSURL URLWithString:@"https://v.ssacdn.com/auto/XJNBxzAztk_0.mp4"];
        NSURLRequest *request = [NSURLRequest requestWithURL:videoURL];
        [secondWebView loadRequest:request];
    } else {
        [self destroyBannerWebView];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"TOMER connectionDidFinishLoading");
    
}

@end
