//
//  UNMLoginShibbolethController.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 07/10/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNMAppLayered.h"

@interface UNMLoginShibbolethController : UIViewController <UNMAppLayered, UNMAppViewCallback>

// @property (strong, nonatomic) UIControl* view;

- (instancetype)initWithAppLayer:(UNMAppLayer*)appLayer;

@end

