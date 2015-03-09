//
//  UNMCommentCreationTableViewCell.m
//  unm-ios
//
//  Created by UnivMobile on 2/3/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMCommentCreationTableViewCell.h"

@implementation UNMCommentCreationTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        if (self.bgColorHighlighted) {
            self.backgroundColor = self.bgColorHighlighted;
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted) {
        if (self.bgColorHighlighted) {
            self.backgroundColor = self.bgColorHighlighted;
        }
    }
}

@end
