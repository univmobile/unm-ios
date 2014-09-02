//
//  UNMCommentsController.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 01/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UNMAppLayered.h"
//#import "UNMPoiData.h"
#import "UNMDetailsController.h"

@interface UNMCommentsController : UITableViewController <UNMAppLayered, UITabBarControllerDelegate>

//@property (weak, nonatomic) const UNMPoiData* poi;

- (instancetype)initWithAppLayer:(UNMAppLayer*)appLayer
			   detailsController:(UNMDetailsController*)detailsController;

@end
