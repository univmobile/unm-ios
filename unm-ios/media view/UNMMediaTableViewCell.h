//
//  UNMMediaTableViewCell.h
//  unm-ios
//
//  Created by UnivMobile on 1/23/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNMMediaTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *separatorBottom;
@property (weak, nonatomic) IBOutlet UIView *separatorLeft;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
