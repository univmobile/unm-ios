//
//  UNMHomeController.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 03/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

@import UIKit;
#import "UNMAppLayered.h"
#import "UNMRegionsController.h"
#import "UNMUniversitiesController.h"

@interface UNMHomeController : UIViewController <UNMAppLayered, UNMAppViewCallback>

- (instancetype) initWithAppLayer:(UNMAppLayer*)appLayer
				   loginNavView:(UIView*)loginNavView
			  loginClassicNavView:(UIView*)loginClassicNavView
			  profileNavView:(UIView*)profileNavView
						  regionsNavView:(UIView*)regionsNavView
					  poisNavView:(UIView*)poisNavView;

@end
