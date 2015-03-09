//
//  UNMLoginViewController.h
//  unm-ios
//
//  Created by UnivMobile on 1/13/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNMLoginCallbackProtocol.h"

@interface UNMLoginViewController : UIViewController<UIWebViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) id<UNMLoginCallbackProtocol> delegate;
@end
