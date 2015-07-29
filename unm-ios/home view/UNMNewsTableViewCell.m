//
//  UNMNewsTableViewCell.m
//  unm-ios
//
//  Created by UnivMobile on 1/22/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMNewsTableViewCell.h"
#import "UIColor+Extension.h"

@interface UNMNewsTableViewCell()
@property (nonatomic) BOOL rotatedDown;
@end

@implementation UNMNewsTableViewCell

- (void)awakeFromNib {
    self.rotatedDown = NO;
    self.showMoreButton = YES;
}

- (void)prepareForReuse {
    self.rotatedDown = NO;
    self.showMoreButton = YES;
}

- (IBAction)moreSelected:(id)sender {
    if ([self.delegate respondsToSelector:@selector(moreSelectedFromCell:)]) {
        [self.delegate moreSelectedFromCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.separator.backgroundColor = [UIColor newsCellOrange];
        self.unexpandedContainer.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.separator.backgroundColor = [UIColor newsCellOrange];
        self.unexpandedContainer.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)rotateDisclosureDown {
    if (!self.rotatedDown) {
        self.rotatedDown = YES;
        self.detailLabel.hidden = NO;
        self.moreButton.hidden = NO;
        [UIView transitionWithView:self.disclosureButton
                          duration:0.3
                           options:UIViewAnimationOptionAllowAnimatedContent
                        animations:^{
                            self.disclosureButton.transform = CGAffineTransformMakeRotation(M_PI / 2);
                        }
                        completion:^(BOOL finished){
                            
                        }];
    }
}

- (void)rotateDisclosureRight {
    if (self.rotatedDown) {
        self.rotatedDown = NO;
        [UIView transitionWithView:self.disclosureButton
                          duration:0.3
                           options:UIViewAnimationOptionAllowAnimatedContent
                        animations:^{
                            self.disclosureButton.transform = CGAffineTransformMakeRotation(0);
                        }
                        completion:^(BOOL finished){
                            self.detailLabel.hidden = YES;
                            self.moreButton.hidden = YES;
                        }];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.moreButton.hidden = !self.showMoreButton;
}

@end
