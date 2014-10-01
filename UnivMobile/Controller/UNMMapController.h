//
//  UNMMapController.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 01/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

@import UIKit;
#import "UNMAppLayered.h"
#import <GoogleMaps/GoogleMaps.h>
#import "UNMPoisController.h"

@interface UNMMapController : UIViewController
<UNMAppLayered, UNMAppViewCallback, UITabBarControllerDelegate>

- (instancetype) initWithAppLayer:(UNMAppLayer*)appLayer
				poisController:(UNMPoisController*)poisController;

@end
