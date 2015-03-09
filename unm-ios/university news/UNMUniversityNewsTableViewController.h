//
//  UNMUniversityNewsTableViewController.h
//  unm-ios
//
//  Created by UnivMobile on 1/22/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNMBaseViewController.h"
#import "UNMNewsTableViewCell.h"

@interface UNMUniversityNewsTableViewController : UNMBaseViewController<UITableViewDataSource,UITableViewDelegate,UNMNewsTableViewCellDelegate>

@end
