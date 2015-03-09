//
//  UNMGeneralWebViewController.m
//  unm-ios
//
//  Created by UnivMobile on 2/20/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMGeneralWebViewController.h"
#import "UNMUtilities.h"

@interface UNMGeneralWebViewController ()
@property (strong, nonatomic) UIView *activityIndicatorView;
@end

@implementation UNMGeneralWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initActivityIndicator];
    self.webview.delegate = self;
    if (self.url && self.url.scheme && self.url.host) {
        [self.webview loadRequest:[NSURLRequest requestWithURL:self.url]];
    } else if (self.htmlData) {
        [self.webview loadHTMLString:self.htmlData baseURL:nil];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self removeActivityIndicator];
}

#pragma mark - Activity indicator

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
