//
//  UNMLoginClassicViewController.h
//  unm-ios
//
//  Created by UnivMobile on 2/20/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNMLoginCallbackProtocol.h"

@interface UNMLoginClassicViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) id<UNMLoginCallbackProtocol> delegate;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end
