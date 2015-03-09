//
//  UNMScrollIndicatorHelper.m
//  unm-ios
//
//  Created by UnivMobile on 2/6/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMScrollIndicatorHelper.h"
#import "UIScrollView+ScrollIndicator.h"

@interface UNMScrollIndicatorHelper ()
@property (nonatomic) BOOL customScrollIndicatorSet;
@end

@implementation UNMScrollIndicatorHelper

- (void)setUpScrollIndicatorWithScrollView:(UIScrollView *)scroll andColor:(UIColor *)color {
    if (!self.customScrollIndicatorSet) {
        [scroll enableCustomScrollIndicatorsWithScrollIndicatorType:JMOScrollIndicatorTypeClassic positions:JMOVerticalScrollIndicatorPositionRight color:color];
        self.customScrollIndicatorSet = YES;
    }
}

@end
