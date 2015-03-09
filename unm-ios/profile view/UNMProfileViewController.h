//
//  UNMProfileViewController.h
//  unm-ios
//
//  Created by UnivMobile on 1/23/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNMBaseViewController+univLabel.h"
#import "UNMUniversitySelectionViewController.h"

@interface UNMProfileViewController : UNMBaseViewController<UITableViewDelegate,UITableViewDataSource,UNMUniversitySelectionViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *universityLabel;

@end
