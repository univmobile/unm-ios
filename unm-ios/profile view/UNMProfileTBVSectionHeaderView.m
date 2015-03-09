//
//  UNMProfileTBVSectionHeaderView.m
//  unm-ios
//
//  Created by UnivMobile on 1/26/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMProfileTBVSectionHeaderView.h"
#import "UIColor+Extension.h"

@implementation UNMProfileTBVSectionHeaderView

- (void)setup {
    UIView *bgColorView = [[UIView alloc]initWithFrame:self.bounds];
    bgColorView.backgroundColor = [UIColor profileHeaderRed];
    self.backgroundView = bgColorView;
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.minimumScaleFactor = 0.5;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.titleLabel];

    NSDictionary *viewsDictionary = @{@"label":self.titleLabel};

    NSArray *constraint_Vert = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[label]-8-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:viewsDictionary];

    NSArray *constraint_Horz = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[label]-8-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:viewsDictionary];
    [self addConstraints:constraint_Vert];
    [self addConstraints:constraint_Horz];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    [self setup];
    return self;
}

@end
