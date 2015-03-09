//
//  UNMNotificationTableViewCell.h
//  unm-ios
//
//  Created by UnivMobile on 1/16/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNMNotificationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *notificationDescription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notifTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notifTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notifLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateTrailing;

@end
