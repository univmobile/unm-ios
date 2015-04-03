//
//  UITableView+HeaderResize.m
//  unm-ios
//
//  Created by UnivMobile on 24/03/15.
//  Copyright (c) 2015 univmobile. All rights reserved.
//

#import "UITableView+HeaderResize.h"

@implementation UITableView (HeaderResize)

- (void) sizeHeaderToFit {
    UIView *headerView = self.tableHeaderView;
    
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    CGFloat height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    headerView.frame = ({
        CGRect headerFrame = headerView.frame;
        headerFrame.size.height = height;
        headerFrame;
    });
    
    self.tableHeaderView = headerView;
}

@end
