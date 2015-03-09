//
//  UNMCommentTableViewCell.m
//  unm-ios
//
//  Created by UnivMobile on 2/3/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMCommentTableViewCell.h"

@implementation UNMCommentTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.backgroundColor = [UIColor whiteColor];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.backgroundColor = [UIColor whiteColor];
    }
}
@end
