//
//  UNMProfileController.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 29/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNMAppLayered.h"
#import "UNMAppToken.h"

@interface UNMProfileController : UITableViewController <UNMAppLayered, UNMAppViewCallback, UIActionSheetDelegate>

@property (weak, nonatomic) const UNMAppUser* user;

- (instancetype)initWithAppLayer:(UNMAppLayer*)appLayer;

@end
