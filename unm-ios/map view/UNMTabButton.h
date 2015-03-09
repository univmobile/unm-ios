//
//  UNMTabButton.h
//  unm-ios
//
//  Created by UnivMobile on 1/30/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNMTabButton : UIControl
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *separators;
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UIImageView *dottedLine;
@property (strong, nonatomic) UIColor *highlightColor;
@property (strong, nonatomic) UIColor *defaultColor;
@property (strong, nonatomic) UIImage *iconImage;
@property (strong, nonatomic) UIImage *selectedIconImage;
- (void)roundCorners:(UIRectCorner)corner radius:(float)radius;
- (void)setIconImageWithName:(NSString *)imageName;
@end
