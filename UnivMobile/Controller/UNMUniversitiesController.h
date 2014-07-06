//
//  UNMUniversitiesController.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 04/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNMRegionData.h"
#import "UNMAppLayered.h"

@interface UNMUniversitiesController : UITableViewController <UNMAppLayered>

@property (weak, nonatomic) const UNMRegionData* regionData;

@property (copy, nonatomic) NSString* selectedUniversityId;

- (id)initWithAppLayer:(UNMAppLayer*)appLayer
				 style:(UITableViewStyle)style;

@end
