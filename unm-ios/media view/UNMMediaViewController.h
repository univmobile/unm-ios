//
//  UNMMediaViewController.h
//  unm-ios
//
//  Created by UnivMobile on 1/23/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNMBaseViewController.h"

@interface UNMMediaViewController : UNMBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tableViewHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;

@end
