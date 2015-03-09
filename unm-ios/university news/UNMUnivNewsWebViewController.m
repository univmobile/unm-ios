//
//  UNMUnivNewsWebViewController.m
//  unm-ios
//
//  Created by UnivMobile on 2/19/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMUnivNewsWebViewController.h"
#import "UNMUtilities.h"

@interface UNMUnivNewsWebViewController ()
@property (strong, nonatomic) UIView *activityIndicatorView;
@end

@implementation UNMUnivNewsWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webview.delegate = self;
    if (self.articleURL) {
        [self initActivityIndicator];
        [self.webview loadRequest:[NSURLRequest requestWithURL:self.articleURL]];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self removeActivityIndicator];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self removeActivityIndicator];
    [UNMUtilities showErrorWithTitle:@"Impossible de charger la page" andMessage:[error localizedDescription] andDelegate:nil];
}

- (void)initActivityIndicator {
    if (self.activityIndicatorView == nil) {
        self.activityIndicatorView = [UNMUtilities initActivityIndicatorContainerWithParentView:self.view aboveSubview:self.webview];
    } else {
        [self.view addSubview:self.activityIndicatorView];
    }
}

- (void)removeActivityIndicator {
    if (self.activityIndicatorView) {
        [self.activityIndicatorView removeFromSuperview];
        self.activityIndicatorView = nil;
    }
}

@end
