//
//  LibraryTableViewCell.h
//  unm-ios
//
//  Created by UnivMobile on 1/22/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNMLibraryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoHeightConst;
@property (weak, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pinIconHeightConst;
@property (weak, nonatomic) IBOutlet UIButton *pinIcon;
- (void)removeLogo;
- (void)centerLabelToPinIcon;
- (void)addLogo;
- (void)removeCenterLabelToPinIcon;
@end
