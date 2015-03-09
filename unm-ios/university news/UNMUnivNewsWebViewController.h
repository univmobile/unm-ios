//
//  UNMUnivNewsWebViewController.h
//  unm-ios
//
//  Created by UnivMobile on 2/19/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNMUnivNewsWebViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) NSURL *articleURL;
@end
