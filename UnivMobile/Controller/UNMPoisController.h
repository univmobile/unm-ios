//
//  UNMPoisController.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 01/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

@import UIKit;
#import "UNMAppLayered.h"
#import "UNMDetailsController.h"

@interface UNMPoisController : UITableViewController <UNMAppLayered, UNMAppViewCallback>

- (instancetype) initWithAppLayer:(UNMAppLayer*)appLayer
							style:(UITableViewStyle)style
				detailsController:(UNMDetailsController*)detailsController;

@end
