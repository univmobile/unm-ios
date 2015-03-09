//
//  SideMenuCustomTableViewCell.m
//  unm-ios
//
//  Created by UnivMobile on 1/13/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMSideMenuCustomTableViewCell.h"
#import "UNMSimpleTableViewCell.h"
#import "UNMMenuItemBasic.h"

@implementation UNMSideMenuCustomTableViewCell

- (void)awakeFromNib {
    [self.tableView registerNib:[UINib nibWithNibName:@"simpleTableViewCell" bundle:nil] forCellReuseIdentifier:@"simpleCell"];
    self.opened = false;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)setUpWithDelegate:(id<UNMSideMenuCustomTableViewCellDelegate>)delegate {
    self.delegate = delegate;
    [self reloadCell];
}

- (void)reloadCell {
    self.menuItems = [self.delegate itemsForCell:self withIndexPath:self.cellIndexPath].copy;
    [self.tableView reloadData];
}

#pragma mark - Tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UNMSimpleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"simpleCell" forIndexPath:indexPath];
    
    if (indexPath.row < [self.menuItems count]) {
        UNMMenuItemBasic *item = self.menuItems[indexPath.row];
        cell.titleLabel.text = item.name;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.menuItems count]) {
        [self.delegate cell:self selectedIndex:indexPath.row withMenuItem:self.menuItems[indexPath.row]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)heightWithoutTableView {
    CGFloat height;
    height = self.iconTopPaddingHeight.constant + self.iconHeight.constant + self.separatorHeight.constant;
    return height;
}

@end
