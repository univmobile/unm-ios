//
//  UNMRegionsController.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 03/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNMUniversitiesController.h"
#import "UNMAppLayered.h"

@interface UNMRegionsController : UITableViewController <UNMAppLayered, UNMAppViewCallback>

@property (strong, nonatomic) UNMUniversitiesController* universitiesController;

@property (copy, nonatomic) NSString* selectedRegionId;

- (instancetype) initWithAppLayer:(UNMAppLayer*)appLayer
							style:(UITableViewStyle)style
		   universitiesController:(UNMUniversitiesController*)universitiesController;

@end
