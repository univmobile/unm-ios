
//
//  LibraryTableViewCell.m
//  unm-ios
//
//  Created by UnivMobile on 1/22/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMLibraryTableViewCell.h"
#import "UIColor+Extension.h"

@interface UNMLibraryTableViewCell()
@property CGFloat logoHeight;
@property CGFloat logoTop;
@property NSLayoutConstraint *centerLabelConst;
@end

@implementation UNMLibraryTableViewCell

- (void)awakeFromNib {
    self.logoHeight = self.logoHeightConst.constant;
    self.logoTop = self.logoTopConst.constant;
}

- (void)removeLogo {
    self.logoHeightConst.constant = 0;
    self.logoTopConst.constant = 0;
    [self updateConstraints];
}

- (void)addLogo {
    self.logoHeightConst.constant = self.logoHeight;
    self.logoTopConst.constant = self.logoTop;
    [self updateConstraints];
}

- (void)centerLabelToPinIcon {
    if (self.centerLabelConst == nil) {
        self.centerLabelConst = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.pinIcon attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [self addConstraint:self.centerLabelConst];
        [self updateConstraints];
    }
}
- (void)removeCenterLabelToPinIcon {
    if (self.centerLabelConst != nil) {
        [self removeConstraint:self.centerLabelConst];
        [self updateConstraints];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.separator.backgroundColor = [UIColor descTabOrange];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.separator.backgroundColor = [UIColor descTabOrange];
    }
}

@end
