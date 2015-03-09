//
//  UNMCommentCreationTableViewCell.h
//  unm-ios
//
//  Created by UnivMobile on 2/3/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNMCommentCreationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) UIColor *bgColorHighlighted;
@end
