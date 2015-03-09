//
//  UNMScrollIndicatorHelper.h
//  unm-ios
//
//  Created by UnivMobile on 2/6/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNMScrollIndicatorHelper : NSObject<UIScrollViewDelegate>
- (void)setUpScrollIndicatorWithScrollView:(UIScrollView *)scroll andColor:(UIColor *)color;
@end
