//
//  UNMLoginController.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 29/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNMAppLayered.h"
#import "UNMLoginClassicController.h"

@interface UNMLoginController : UIViewController <UNMAppLayered>

//@property (strong, nonatomic, readonly) UNMLoginClassicController* loginClassicController;

- (instancetype)initWithAppLayer:(UNMAppLayer*)appLayer;
//		  loginClassicController:(UNMLoginClassicController*)loginClassicController;

@end
