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
#import "UNMMapViewController.h"

@interface UNMHomeViewController : UNMBaseViewController<UNMNewsTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *newsTableViewHeightConst;
-(UNMMapViewController *) loadStaticMapImage;
@end
