//
//  UNMGeneralWebViewController.h
//  unm-ios
//
//  Created by UnivMobile on 2/20/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNMBaseViewController.h"

@interface UNMGeneralWebViewController : UNMBaseViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSString *htmlData;
@end
