//
//  SideMenuCustomTableViewCell.h
//  unm-ios
//
//  Created by UnivMobile on 1/13/15.
//  Copyright (c) 2015 univmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UNMSideMenuCustomTableViewCell,UNMMenuItemBasic;
@protocol UNMSideMenuCustomTableViewCellDelegate
- (NSArray *)itemsForCell:(UNMSideMenuCustomTableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath;
- (void)cell:(UNMSideMenuCustomTableViewCell *)cell selectedIndex:(NSInteger)index withMenuItem:(UNMMenuItemBasic *)menuItem;
@end
@interface UNMSideMenuCustomTableViewCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property (weak) id <UNMSideMenuCustomTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *menuItems;
@property (strong, nonatomic) NSIndexPath *cellIndexPath;
@property BOOL opened;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTopPaddingHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorHeight;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
- (void)setUpWithDelegate:(id<UNMSideMenuCustomTableViewCellDelegate>)delegate;
-(CGFloat)heightWithoutTableView;
- (void)reloadCell;
@end
