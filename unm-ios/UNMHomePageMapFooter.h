//
//  HomePageMapFooter.h
//  unm-ios
//
//  Created by Arnas Dundulis on 24/07/15.
//  Copyright (c) 2015 univmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNMHomePageMapFooter : UIView
@property (weak, nonatomic) IBOutlet UIView *mapPlaceholder;
@property (weak, nonatomic) IBOutlet UIControl *leftTab;
@property (weak, nonatomic) IBOutlet UIControl *middleTab;
@property (weak, nonatomic) IBOutlet UIControl *rightTab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapHeight;

@end
