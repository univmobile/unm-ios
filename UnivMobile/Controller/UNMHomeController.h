//
//  UNMHomeController.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 03/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNMRegionsController.h"
#import "UNMHomeCallback.h"

@interface UNMHomeController : UIViewController <UNMHomeCallback>

- (id) initWithNav:(UIView*) navView regionsController:(UNMRegionsController*)regionsController;

@end