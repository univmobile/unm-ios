//
//  UNMSearchViewController.h
//  unm-ios
//
//  Created by UnivMobile on 1/20/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNMMapItemBasic.h"

@protocol UNMSearchViewControllerDelegate <NSObject>
- (void)setSelectedMapItem:(UNMMapItemBasic *)mapItem;
- (NSNumber *)getCategoryID;
- (NSNumber *)getUniversityID;
@end

@interface UNMSearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (strong,nonatomic) id<UNMSearchViewControllerDelegate> delegate;
@end
