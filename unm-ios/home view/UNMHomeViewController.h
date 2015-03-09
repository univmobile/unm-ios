//
//  UNMHomeViewController.h
//  unm-ios
//
//  Created by UnivMobile on 1/13/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "UNMBaseViewController.h"
#import "UNMNewsTableViewCell.h"

@interface UNMHomeViewController : UNMBaseViewController<UNMNewsTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleBodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *geoCampusLabel;
@property (weak, nonatomic) IBOutlet UILabel *geoCampusBodyLabel;
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *newsTableViewHeightConst;
@property (weak, nonatomic) IBOutlet UIImageView *triangleIcon;
@property (weak, nonatomic) IBOutlet UIView *mapPlaceholder;

@end
