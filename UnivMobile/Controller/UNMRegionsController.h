//
//  UNMRegionsController.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 03/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNMUniversitiesController.h"
#import "UNMHomeCallback.h"

@interface UNMRegionsController : UITableViewController

@property (weak, nonatomic) NSObject<UNMHomeCallback>* callback;
@property (strong, nonatomic) UNMUniversitiesController* universitiesController;

@property (copy, nonatomic) NSString* selectedRegionId;
@property (copy, nonatomic) NSString* selectedUniversityId;

- (id) initWithStyle:(UITableViewStyle)style universitiesController:(UNMUniversitiesController*)universitiesController;

- (UNMRegionData*)getRegionDataById:(NSString*)regionId;

- (UNMUniversityData*)getUniversityDataById:(NSString*)universityId;

@end
