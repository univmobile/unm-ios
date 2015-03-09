//
//  UNMBonPlanViewWithUnclippedButton.m
//  unm-ios
//
//  Created by UnivMobile on 2/4/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMViewWithUnclippedButton.h"

@implementation UNMViewWithUnclippedButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if ( CGRectContainsPoint(self.button.frame, point) ) {
        if (!self.hidden && [self isPointInCircleWithCenter:self.button.center radius:CGRectGetHeight(self.button.frame)/2 touch:point]) {
            return YES;
        } else {
            return NO;
        }
    }
    else if (CGRectContainsPoint(self.bounds, point)){
        return YES;
    } else {
        return [super pointInside:point withEvent:event];
    }
}

- (BOOL) isPointInCircleWithCenter:(CGPoint)center radius:(CGFloat)radius touch:(CGPoint)touch {
    if(CGRectContainsPoint(self.button.frame, touch))
    {
        CGFloat dx = center.x - touch.x;
        CGFloat dy = center.y - touch.y;
        dx *= dx;
        dy *= dy;
        CGFloat distanceSquared = dx + dy;
        CGFloat radiusSquared = radius * radius;
        return distanceSquared <= radiusSquared;
    }
    return NO;
}


@end
