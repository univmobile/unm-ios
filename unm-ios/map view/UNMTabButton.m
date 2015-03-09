//
//  UNMTabButton.m
//  unm-ios
//
//  Created by UnivMobile on 1/30/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMTabButton.h"
#import "UIColor+Extension.h"

@interface UNMTabButton ()
@property (nonatomic) UIRectCorner corner;
@property (nonatomic) float cornerRadius;
@end

@implementation UNMTabButton {
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _defaultColor = [UIColor tabGray];
    }
    return self;
}

- (void)awakeFromNib {
    self.backgroundColor = self.defaultColor;
    for (UIView *separator in self.separators) {
        separator.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    BOOL hideSeparators;
    if (selected) {
        hideSeparators = YES;
        if (self.highlightColor) {
            self.backgroundColor = self.highlightColor;
        }
        if (self.selectedIconImage) {
            self.icon.image = self.selectedIconImage;
        }
    } else {
        hideSeparators = NO;
        if (self.defaultColor) {
            self.backgroundColor = self.defaultColor;
        }
        if (self.iconImage) {
            self.icon.image = self.iconImage;
        }
        if (!self.dottedLine.hidden) {
            self.dottedLine.hidden = YES;
        }
    }
    for (UIView *separator in self.separators) {
        separator.hidden = hideSeparators;
    }
}

-(void)roundCorners:(UIRectCorner)corner radius:(float)radius
{
    self.cornerRadius = radius;
    self.corner = corner;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:self.corner cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
}

- (void)setIconImageWithName:(NSString *)imageName {
    self.iconImage = [UIImage imageNamed:imageName];
    self.selectedIconImage = [UIImage imageNamed:[imageName stringByAppendingString:@"Selected"]];
}
@end
