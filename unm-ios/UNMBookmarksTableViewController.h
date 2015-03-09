//
//  UNMBookmarksTableViewController.h
//  unm-ios
//
//  Created by UnivMobile on 1/27/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNMBaseViewController.h"

@interface UNMBookmarksTableViewController : UNMBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
