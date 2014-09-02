//
//  UNMDetailsController.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 01/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UNMAppLayered.h"
#import "UNMPoiData.h"

@interface UNMDetailsController : UITableViewController <UNMAppLayered>

@property (weak, nonatomic) const UNMPoiData* poi;

- (instancetype)initWithAppLayer:(UNMAppLayer*)appLayer;

@end
