//
//  UNMBookmarksTableViewCell.m
//  unm-ios
//
//  Created by UnivMobile on 1/23/15.
//  Copyright (c) 2015 univmobile. All rights reserved.
//

#import "UNMBookmarksTableViewCell.h"

@implementation UNMBookmarksTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.containerView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.containerView.backgroundColor = [UIColor whiteColor];
    }
}

@end
