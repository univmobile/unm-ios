//
//  UNMNewsTableViewCell.h
//  unm-ios
//
//  Created by UnivMobile on 1/22/15.
//  Copyright (c) 2015 univmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UNMNewsTableViewCell;
@protocol UNMNewsTableViewCellDelegate <NSObject>
- (void)moreSelectedFromCell:(UNMNewsTableViewCell *)cell;
@end

@interface UNMNewsTableViewCell : UITableViewCell
@property (weak, nonatomic) id<UNMNewsTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *disclosureButton;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *unexpandedContainer;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disclosureTrailingConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBottomConst;
- (void)rotateDisclosureRight;
- (void)rotateDisclosureDown;
@end
