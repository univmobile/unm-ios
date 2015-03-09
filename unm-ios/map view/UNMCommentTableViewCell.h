//
//  UNMCommentTableViewCell.h
//  unm-ios
//
//  Created by UnivMobile on 2/3/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNMCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTopConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameBottomConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentBottomConst;
@end
