//
//  UNMNewsFeedButton.m
//  
//
//  Created by Andrius Alekna on 27/11/15.
//
//

#import "UNMNewsFeedButton.h"

@implementation UNMNewsFeedButton

- (instancetype)initWithID:(NSNumber *)ID
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:1 green:0.694 blue:0.012 alpha:1];
        self.titleLabel.font = [UIFont fontWithName:@"Exo-Light" size:15];
        _tagId = ID;
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];

    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:1 green:0.694 blue:0.012 alpha:1];
        self.titleLabel.textColor = [UIColor grayColor];
    }
    else {
        self.backgroundColor = [UIColor colorWithRed:0.827 green:0.573 blue:0.008 alpha:1] ;
        self.titleLabel.textColor = [UIColor whiteColor];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2.0f;
    self.layer.masksToBounds = YES;
}


@end
