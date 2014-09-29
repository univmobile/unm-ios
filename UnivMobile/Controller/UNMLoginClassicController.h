//
//  UNMLoginClassicController.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 29/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNMAppLayered.h"

@interface UNMLoginClassicController : UIViewController <UNMAppLayered, UNMAppViewCallback, UITextFieldDelegate>

@property (strong, nonatomic) UIControl* view;

- (instancetype)initWithAppLayer:(UNMAppLayer*)appLayer;

@end
