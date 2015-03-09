//
//  UNMUniversitySelectionViewController.h
//  unm-ios
//
//  Created by UnivMobile on 2/20/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UNMUniversitySelectionViewControllerDelegate <NSObject>
- (void)closeUnivSelect;
- (void)setSelectedUniversityString:(NSString *)university;
@end

@interface UNMUniversitySelectionViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) id<UNMUniversitySelectionViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
