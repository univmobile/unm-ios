//
//  HomePageNewsHeader.h
//  unm-ios
//
//  Created by Arnas Dundulis on 24/07/15.
//  Copyright (c) 2015 univmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNMHomePageNewsHeader : UIView
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleBodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *triangleIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImageHeight;
@end
