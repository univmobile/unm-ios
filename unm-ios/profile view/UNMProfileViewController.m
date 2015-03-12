//
//  UNMProfileViewController.m
//  unm-ios
//
//  Created by UnivMobile on 1/23/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMProfileViewController.h"
#import "UNMMediaTableViewCell.h"
#import "UNMLibraryTableViewCell.h"
#import "UNMBookmarksTableViewCell.h"
#import "UNMProfileTBVSectionHeaderView.h"
#import "UNMProfileFooterTableViewCell.h"
#import "UNMUtilities.h"
#import "UIColor+Extension.h"
#import "UNMConstants.h"
#import "UNMUserBasic.h"
#import "UNMBookmarkBasic.h"
#import "UNMMediaItemBasic.h"
#import "UNMUnivLibraryItem.h"
#import "UNMUnivNewsWebViewController.h"
#import "UNMUniversityBasic.h"

@interface UNMProfileViewController ()
@property NSArray *titleArray;
@property NSCache *offscreenCells;
@property NSCache *offscreenCellHeights;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *libraryTBVLeadingConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *libraryTBVHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mediaTBVHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bookmarksTBVHeightConst;
@property (strong, nonatomic) UNMUniversitySelectionViewController *univSelect;
@property (strong, nonatomic) NSLayoutConstraint *univSelectSlideOutHeightConst;
@property (strong, nonatomic) NSLayoutConstraint *univSelectSlideBottomConst;
@property (nonatomic) BOOL slideOutAnimationDone;
@property (nonatomic) BOOL slideOutOpen;
@property (strong, nonatomic) NSArray *bookmarks;
@property (strong, nonatomic) NSArray *mediaItems;
@property (strong, nonatomic) NSArray *libraries;
@property (strong, nonatomic) UIView *activityIndicatorView;
@property (strong, nonatomic) NSURL *webviewURL;
@property (atomic) NSInteger activityIndicatorCount;
@end

@implementation UNMProfileViewController



- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _offscreenCells = [NSCache new];
        _offscreenCellHeights = [NSCache new];
        _titleArray = @[@"1Vivre avec une personne âgée : une coloc' originale pour les étudiants Vivre avec une personne âgée : une coloc' originale pour les étudiants",@"2Vivre avec une personne âgée : une coloc' originale",@"3Vivre avec une personne âgée",@"4Vivre"];
        _slideOutOpen = NO;
        _slideOutAnimationDone = YES;
        _activityIndicatorCount = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self univSelect];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgSideMenu"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UNMProfileTBVSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"sectionHeader"];
    UNMUserBasic *user = [UNMUserBasic getSavedObject];
    if (user) {
        self.nameLabel.text = [user displayName];
    } else {
        self.nameLabel.text = @"";
    }
    UNMUniversityBasic *university = [UNMUniversityBasic getSavedObject];
    if (university) {
        self.universityLabel.text = [university title];
    } else {
        self.universityLabel.text = @"";
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchItems];
}

- (void)fetchItems {
    [self.offscreenCellHeights removeAllObjects];
    [self initActivityIndicator];
    [UNMBookmarkBasic fetchNewestBookmarksWithSuccess:^(NSArray *items) {
        self.bookmarks = items;
        [self.tableView reloadData];
        [self removeActivityIndicator];
    } failure:^{
        [self removeActivityIndicator];
    }];
    [self initActivityIndicator];
    [UNMMediaItemBasic fetchNewestMediaItemsWithSuccess:^(NSArray *items) {
        self.mediaItems = items;
        [self.tableView reloadData];
        [self removeActivityIndicator];
    } failure:^{
        [self removeActivityIndicator];
    }];
    [self initActivityIndicator];
    [UNMUnivLibraryItem fetchNewestLibraryItemsWithSuccess:^(NSArray *items) {
        self.libraries = items;
        [self.tableView reloadData];
        [self removeActivityIndicator];
    } failure:^{
        [self removeActivityIndicator];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            if ([self.mediaItems count] > 0) {
                return [self.mediaItems count]+1;
            } else {
                return 0;
            }
        case 1:
            if ([self.libraries count] > 0) {
                return [self.libraries count]+1;
            } else {
                return 0;
            }
        case 2:
            if ([self.bookmarks count] > 0) {
                return [self.bookmarks count]+1;
            } else {
                return 0;
            }
        default:
            return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *headerReuseIdentifier = @"sectionHeader";
    
    UNMProfileTBVSectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerReuseIdentifier];
    
    switch (section) {
        case 0:
            sectionHeaderView.titleLabel.text = @"Mes Mediathéques";
            sectionHeaderView.backgroundView.backgroundColor = [UIColor profileHeaderRed];
            break;
        case 1:
            sectionHeaderView.titleLabel.text = @"Mes Bibliothéques";
            sectionHeaderView.backgroundView.backgroundColor = [UIColor profileHeaderRed];
            break;
        case 2:
            sectionHeaderView.titleLabel.text = @"Bookmarks";
            sectionHeaderView.backgroundView.backgroundColor = [UIColor navBarPurple];
            break;
        default:
            break;
    }
    
    return sectionHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == [self.mediaItems count]) {
                return 44.0;
            }
            break;
        case 1:
            if (indexPath.row == [self.libraries count]) {
                return 44.0;
            }
            break;
        case 2:
            if (indexPath.row == [self.bookmarks count]) {
                return 44.0;
            }
            break;
        default:
            break;
    }
    switch (indexPath.section) {
        case 0:
            return kMediaCellHeight;
        case 1:
            return [self libraryTBVCellHeightWithIndexPath:indexPath];
        case 2:
            return kBookmarkCellHeight;
        default:
            return 0;
    }
}

- (CGFloat)libraryTBVCellHeightWithIndexPath:(NSIndexPath *)indexPath {
    indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    NSNumber *height = [self.offscreenCellHeights objectForKey:indexPath];
    if (!height) {
        NSString *reuseIdentifier = @"libraryCell";
        UNMLibraryTableViewCell *cell = [self.offscreenCells objectForKey:reuseIdentifier];
        if (!cell) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"libraryCell"];
            [self.offscreenCells setObject:cell forKey:reuseIdentifier];
        }
        UNMUnivLibraryItem *item;
        if (indexPath.row < [self.libraries count]) {
            item = self.libraries[indexPath.row];
            cell.titleLabel.text = item.poiName;
        } else {
            cell.titleLabel.text = @"";
        }
        
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        
        cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(cell.bounds));
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        height = [NSNumber numberWithFloat:cell.titleTopConst.constant + cell.titleLabel.frame.size.height + kTitleLabelBottomPadding];
        if (item && item.ruedesfacs) {
            height = [NSNumber numberWithFloat:[height floatValue] + cell.logoTopConst.constant + cell.logoHeightConst.constant];
        }
        if ([height floatValue] < cell.pinIconHeightConst.constant + kPinIconVerticalPadding*2) {
            height = [NSNumber numberWithFloat:cell.pinIconHeightConst.constant + kPinIconVerticalPadding*2];
        }
        
        height = [NSNumber numberWithFloat:[height floatValue]+1.0f];
        
        [self.offscreenCellHeights setObject:height forKey:indexPath];
    }
    
    return [height floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 0 && indexPath.row == [self.mediaItems count]) ||
        (indexPath.section == 1 && indexPath.row == [self.libraries count]) ||
        (indexPath.section == 2 && indexPath.row == [self.bookmarks count])) {
        UNMProfileFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"footerCell" forIndexPath:indexPath];
        
        switch (indexPath.section) {
            case 0: {
                cell.titleLabel.text = @"OUVRIR MA MÉDIATHÈQUE";
                break;
            case 1:
                cell.titleLabel.text = @"VOIR TOUTES LES BIBLIOTHÈQUES";
                break;
            case 2:
                cell.titleLabel.text = @"VOIR TOUT MES BOOKMARKS";
                break;
            default:
                break;
            }
        }
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    switch (indexPath.section) {
        case 0: {
            UNMMediaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mediaCell" forIndexPath:indexPath];
            if (indexPath.row < [self.mediaItems count]) {
                UNMMediaItemBasic *item = self.mediaItems[indexPath.row];
                cell.titleLabel.text = item.label;
            } else {
                cell.titleLabel.text = @"";
            }
            cell.contentView.backgroundColor = [UIColor whiteColor];
            return cell;
        }
        case 1: {
            UNMLibraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"libraryCell" forIndexPath:indexPath];
            if (indexPath.row < [self.libraries count]) {
                UNMUnivLibraryItem *item = self.libraries[indexPath.row];
                cell.titleLabel.text = item.poiName;
                if (!item.ruedesfacs) {
                    [cell removeLogo];
                    [cell centerLabelToPinIcon];
                } else {
                    [cell addLogo];
                    [cell removeCenterLabelToPinIcon];
                }
            } else {
                cell.titleLabel.text = @"";
                [cell removeLogo];
                [cell centerLabelToPinIcon];
            }
            cell.contentView.backgroundColor = [UIColor whiteColor];
            return cell;
        }
        case 2: {
            UNMBookmarksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookmarkCell" forIndexPath:indexPath];
            if (indexPath.row < [self.bookmarks count]) {
                UNMBookmarkBasic *item = self.bookmarks[indexPath.row];
                cell.titleLabel.text = item.poiName;
            }
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        }
        default:
            return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0://media
            if (indexPath.row == [self.mediaItems count]) {
                [UNMUtilities setCenterControllerWithViewControllerIdentifier:@"media"];
            } else if (indexPath.row < [self.mediaItems count]) {
                UNMMediaItemBasic *item = self.mediaItems[indexPath.row];
                self.webviewURL = [NSURL URLWithString:item.urlStr];
                [self performSegueWithIdentifier:@"webview" sender:self];
            }
            break;
        case 1://library
            if (indexPath.row == [self.libraries count]) {
                [UNMUtilities setCenterControllerWithViewControllerIdentifier:@"library"];
            } else if (indexPath.row < [self.libraries count]) {
                UNMUnivLibraryItem *item = self.libraries[indexPath.row];
                [self initActivityIndicator];
                [UNMMapItemBasic fetchMarkerWithMap:nil withUrl:[NSString stringWithFormat:@"pois/%d",[item.poiID intValue]] success:^(UNMMapItemBasic *mapItem) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UNMUtilities setCenterControllerToMapWithSingleItem:mapItem andTabSelected:MapTabLeft];
                        [self removeActivityIndicator];
                    });
                } failure:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                    [self removeActivityIndicator];
                    });
                }];
            }
            break;
        case 2://bookmarks
            if (indexPath.row == [self.bookmarks count]) {
                [UNMUtilities setCenterControllerWithViewControllerIdentifier:@"bookmarks"];
            } else if (indexPath.row < [self.bookmarks count]) {
                UNMBookmarkBasic *item = self.bookmarks[indexPath.row];
                [self initActivityIndicator];
                [UNMMapItemBasic fetchMarkerWithMap:nil withUrl:item.poiUrlStr success:^(UNMMapItemBasic *mapItem) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UNMUtilities setCenterControllerToMapWithSingleItem:mapItem andTabSelected:item.tab];
                        [self removeActivityIndicator];
                    });
                } failure:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self removeActivityIndicator];
                    });
                }];
                
            }
            break;
        default:
            break;
    }
}

#pragma mark - slideout

- (UNMUniversitySelectionViewController *)univSelect {
    if (_univSelect == nil) {
        _univSelect = [self.storyboard instantiateViewControllerWithIdentifier:@"univSelect"];
        _univSelect.delegate = self;
        [self addChildViewController:_univSelect];
        _univSelect.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_univSelect.view];
        [_univSelect didMoveToParentViewController:self];
        
        CGFloat viewHeight = self.view.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height;
        
        viewHeight *= 0.95;
        
        self.univSelectSlideOutHeightConst = [NSLayoutConstraint constraintWithItem:_univSelect.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:viewHeight];
        self.univSelectSlideBottomConst = [NSLayoutConstraint constraintWithItem:_univSelect.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:viewHeight];
        
        NSArray *constraint_Horz = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[slideout]-0-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"slideout":_univSelect.view}];
        
        [self.view addConstraints:constraint_Horz];
        [_univSelect.view addConstraint:self.univSelectSlideOutHeightConst];
        [self.view addConstraint:self.univSelectSlideBottomConst];
    }
    return _univSelect;
}

- (void)setSlideOutOpen:(BOOL)open animated:(BOOL)animated {
    if (self.slideOutAnimationDone) {
        void (^animation)(void);
        void (^completion)(BOOL);
        if (open) {
            animation = ^void(){
                self.univSelectSlideBottomConst.constant = 0;
                [self.view layoutIfNeeded];
            };
            completion = ^void(BOOL finished) {
                self.slideOutAnimationDone = YES;
            };
        } else {
            animation = ^void(){
                self.slideOutAnimationDone = NO;
                CGFloat viewHeight = self.view.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height;
                if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
                    viewHeight += 44;
                }
                viewHeight *= 0.95;
                self.univSelectSlideBottomConst.constant = viewHeight;
                [self.view layoutIfNeeded];
            };
            completion = ^void(BOOL finished) {
                self.slideOutAnimationDone = YES;
            };
        }
        if (animated) {
            [UIView animateWithDuration:0.5 animations:animation completion:completion];
        } else {
            animation();
            completion(YES);
        }
    }
}

- (IBAction)changeUniversity:(id)sender {
    [self setSlideOutOpen:YES animated:YES];
}

- (void)closeUnivSelect {
    [self setSlideOutOpen:NO animated:YES];
}

- (void)setSelectedUniversityString:(NSString *)university {
    if (university) {
        [self setUniversityTitleWithName:university];
        self.universityLabel.text = university;
        [self fetchItems];
    }
}

- (void)updateNavBarWithUser:(UNMUserBasic *)user {
    if (user) {
        [super setLoginButtonTitleWithName:user.username];
        self.nameLabel.text = user.displayName;
        [self fetchItems];
    }
}

#pragma mark - Activity indicator

- (void)initActivityIndicator {
    if (self.activityIndicatorView == nil) {
        self.activityIndicatorView = [UNMUtilities initActivityIndicatorContainerWithParentView:self.view aboveSubview:self.tableView];
    } else {
        [self.view addSubview:self.activityIndicatorView];
    }
    self.activityIndicatorCount++;
}

- (void)removeActivityIndicator {
    if (self.activityIndicatorView) {
        if (self.activityIndicatorCount == 1) {
            [self.activityIndicatorView removeFromSuperview];
            self.activityIndicatorView = nil;
            self.activityIndicatorCount = 0;
        } else {
            self.activityIndicatorCount--;
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
