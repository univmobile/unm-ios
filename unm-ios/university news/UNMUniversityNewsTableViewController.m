//
//  UNMUniversityNewsTableViewController.m
//  unm-ios
//
//  Created by UnivMobile on 1/22/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMUniversityNewsTableViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "UNMUtilities.h"
#import "UNMUniversityBasic.h"
#import "UNMNewsBasic.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+notificationDate.h"
#import "UNMUnivNewsWebViewController.h"

@interface UNMUniversityNewsTableViewController ()
@property (strong, nonatomic) NSIndexPath *selectedCell;
@property (strong, nonatomic) NSNumber *cellHeightClosed;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *newsItems;
@property (strong, nonatomic) UIView *activityIndicatorView;
@property (strong, nonatomic) NSCache *offscreenCells;
@property (strong, nonatomic) NSCache *offscreenCellHeights;
@property (strong, nonatomic) NSURL *webviewURL;
@end

@implementation UNMUniversityNewsTableViewController {
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _newsItems = [NSArray new];
        _offscreenCellHeights = [NSCache new];
        _offscreenCells = [NSCache new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationItem setHidesBackButton:YES];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initActivityIndicator];
    [UNMNewsBasic fetchNewsWithSuccess:^(NSArray *items) {
        self.newsItems = items;
        [self.tableView reloadData];
        [self removeActivityIndicator];
    } failure:^{
        [self removeActivityIndicator];
    }];
}

#pragma mark - Activity indicator

- (void)initActivityIndicator {
    if (self.activityIndicatorView == nil) {
        self.activityIndicatorView = [UNMUtilities initActivityIndicatorContainerWithParentView:self.view aboveSubview:self.tableView];
    } else {
        [self.view addSubview:self.activityIndicatorView];
    }
}

- (void)removeActivityIndicator {
    if (self.activityIndicatorView) {
        [self.activityIndicatorView removeFromSuperview];
        self.activityIndicatorView = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.newsItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UNMNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
    if (indexPath.row < [self.newsItems count]) {
        UNMNewsBasic *item = self.newsItems[indexPath.row];
        cell.titleLabel.text = item.name;
        cell.detailLabel.text = item.desc;
        cell.dateLabel.text = [NSString stringWithFormat:@"Nom du flux %@",[item.date newsCellDateString]];
        if (item.thumbURLStr && [item.thumbURLStr class] != [NSNull class]) {
            NSURL *thumbURL = [NSURL URLWithString:item.thumbURLStr];
            if (thumbURL && thumbURL.scheme && thumbURL.host) {
                [cell.thumbnailImageView setImageWithURL:thumbURL];
            }
        }
    }
    cell.clipsToBounds = YES;
    if (self.selectedCell != nil && [self.selectedCell isEqual:indexPath]) {
        cell.detailLabel.hidden = NO;
        cell.moreButton.hidden = NO;
        [cell rotateDisclosureDown];
    } else {
        cell.detailLabel.hidden = YES;
        cell.moreButton.hidden = YES;
        [cell rotateDisclosureRight];
    }
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    if (self.selectedCell != nil && [self.selectedCell isEqual:indexPath]) {
        NSString *reuseIdentifier = @"newsCell";
        NSNumber *height;
        indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        height = [self.offscreenCellHeights objectForKey:indexPath];
        if (!height) {
            
            UITableViewCell *cell = [self.offscreenCells objectForKey:reuseIdentifier];
            if (!cell) {
                cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
                [self.offscreenCells setObject:cell forKey:reuseIdentifier];
            }
            
            UNMNewsTableViewCell *newsCell = (UNMNewsTableViewCell *)cell;
            if (indexPath.row < [self.newsItems count]) {
                UNMNewsBasic *newsItem = self.newsItems[indexPath.row];
                newsCell.titleLabel.text = [newsItem name];
                NSDate *date = [newsItem date];
                newsCell.dateLabel.text = [NSString stringWithFormat:@"Nom du flux %@",[date newsCellDateString]];
                newsCell.detailLabel.text = [newsItem desc];
            } else {
                newsCell.titleLabel.text    = @"name";
                newsCell.dateLabel.text    = @"Nom du flux /1/1/2015";
                newsCell.detailLabel.text = @"text text text text text text text text text text";
            }
            newsCell.detailLabel.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds);
            newsCell.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds) - CGRectGetWidth(newsCell.thumbnailImageView.frame);
            newsCell.dateLabel.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds) - CGRectGetWidth(newsCell.thumbnailImageView.frame);
            
            [cell setNeedsUpdateConstraints];
            [cell updateConstraintsIfNeeded];
            
            cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(cell.bounds));
            
            [cell setNeedsLayout];
            [cell layoutIfNeeded];
            
            CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            height = [NSNumber numberWithFloat:size.height];
            
            height = [NSNumber numberWithFloat:[height floatValue]+1.0f];
            if (indexPath.row < [self.newsItems count]) {
                [self.offscreenCellHeights setObject:height forKey:indexPath];
            }
        }
        return [height floatValue];
    } else {
        return 106;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UNMNewsTableViewCell *cell = (UNMNewsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UNMNewsTableViewCell *oldCell;
    [tableView beginUpdates];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectedCell != nil && [self.selectedCell isEqual:indexPath]) { //same cell selected, close it
        self.selectedCell = nil;
        [cell rotateDisclosureRight];
    } else { 
        if (self.selectedCell != nil) {
            oldCell = (UNMNewsTableViewCell *)[tableView cellForRowAtIndexPath:self.selectedCell];
            [oldCell rotateDisclosureRight];
        }
        self.selectedCell = indexPath;
        [cell rotateDisclosureDown];
    }
    [tableView endUpdates];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [cell layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                     }];
}

- (void)moreSelectedFromCell:(UNMNewsTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row < [self.newsItems count]) {
        UNMNewsBasic *item = self.newsItems[indexPath.row];
        NSURL *articleURL = [NSURL URLWithString:item.articeURLStr];
        if (articleURL && articleURL.scheme && articleURL.host) {
            self.webviewURL = articleURL;
            [self performSegueWithIdentifier:@"webview" sender:self];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"webview"]) {
        UNMUnivNewsWebViewController *vc = [segue destinationViewController];
        if (self.webviewURL) {
            vc.articleURL = self.webviewURL;
        }
    }
}
@end