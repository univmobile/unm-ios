//
//  UNMDescriptionCellTableViewCell.h
//  unm-ios
//
//  Created by UnivMobile on 2/3/15.
//  Copyright (c) 2015 univmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@interface UNMDescriptionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *descriptionLabel;
@end
