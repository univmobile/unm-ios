//
//  UNMMediaTableViewCell.m
//  unm-ios
//
//  Created by UnivMobile on 1/23/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMMediaTableViewCell.h"
#import "UIColor+Extension.h"

@implementation UNMMediaTableViewCell

- (void)awakeFromNib {
    self.separatorBottom.backgroundColor = [UIColor descTabOrange];
    self.separatorLeft.backgroundColor = [UIColor descTabOrange];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.separatorBottom.backgroundColor = [UIColor descTabOrange];
        self.separatorLeft.backgroundColor = [UIColor descTabOrange];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.separatorBottom.backgroundColor = [UIColor descTabOrange];
        self.separatorLeft.backgroundColor = [UIColor descTabOrange];
    }
}

@end
