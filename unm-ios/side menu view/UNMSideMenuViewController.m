//
//  UNMSideMenuViewController.m
//  unm-ios
//
//  Created by UnivMobile on 1/13/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMSideMenuViewController.h"
#import "MFSideMenu.h"
#import "UNMAppDelegate.h"
#import "UNMUtilities.h"
#import "UNMMapViewController.h"
#import "UIColor+Extension.h"
#import "UNMMenuItemBasic.h"
#import "UNMUniversityBasic.h"
#import "UNMRegionBasic.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UNMConstants.h"
#import "UNMHomeViewController.h"

@interface UNMSideMenuViewController ()
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (strong, nonatomic) NSIndexPath *selectedCell;
@property (strong, nonatomic) NSMutableDictionary *cellHeights;
@property (strong, nonatomic) NSArray *cellTitles;
@property (nonatomic) NSInteger parentCellCount;
@property (strong, nonatomic) NSMutableArray *groups;
@property (strong, nonatomic) UNMUniversityBasic *fetchedUniv;
@property (strong, nonatomic) UIView *activityIndicatorView;
@end

@implementation UNMSideMenuViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _cellHeights = [NSMutableDictionary new];
        _selectedCell = nil;
        _cellTitles =  @[ @"Mes services", @"Act'universitaire", @"Tou'trouver", @"Ma vie U"];
        _parentCellCount = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"sideMenuCustomCell" bundle:nil] forCellReuseIdentifier:@"sideMenuCustomCell"];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgSideMenuGray"]];
    UITapGestureRecognizer *logoTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(universityLogoTapped:)];
    logoTapRecognizer.numberOfTapsRequired = 1;
    logoTapRecognizer.numberOfTouchesRequired = 1;
    [self.logo addGestureRecognizer:logoTapRecognizer];
    [self fetchMenuItems];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuStateEventOccurred:)
                                                 name:MFSideMenuStateNotificationEvent
                                               object:nil];
}


- (void)menuStateEventOccurred:(NSNotification *)notification {
    MFSideMenuStateEvent event = [[[notification userInfo] objectForKey:@"eventType"] intValue];
    if (event == MFSideMenuStateEventMenuWillOpen) {
        [self fetchMenuItems];
    }
}
- (void)fetchMenuItems {
    UNMUniversityBasic *univ = [UNMUniversityBasic getSavedObject];
    if (univ && ![self.fetchedUniv isEqual:univ]) {
        [self.cellHeights removeAllObjects];
        self.selectedCell = nil;
        [self initActivityIndicator];
        if ([univ.logoUrl class] != [NSNull class]) {
            self.logo.hidden = NO;
            [self.logo setImageWithURL:[NSURL URLWithString:[kUniversityLogoDomainStr stringByAppendingString:univ.logoUrl]]];
            self.homeButton.hidden = YES;
        } else {
            self.homeButton.hidden = NO;
            self.logo.hidden = YES;
        }
        [UNMMenuItemBasic fetchMenuItemsWithSuccess:^(NSArray *items) {
            self.menuItems = items;
            self.groups = [NSMutableArray new];
            NSArray *order = @[@"MS",@"AU",@"TT",@"MU"];
            for (NSString *group in order) {
                for (UNMMenuItemBasic *item in items) {
                    if ([item.grouping isEqualToString:group]) {
                        [self.groups addObject:item.grouping];
                        break;
                    }
                }
            }
            self.parentCellCount = [self.groups count];
            [self.tableView reloadData];
            [self removeActivityIndicator];
            self.fetchedUniv = univ;
        } failure:^{
            [self removeActivityIndicator];
        }];
    }
}


#pragma mark - Tableview

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]; 
    if(self.selectedCell != nil && [self.selectedCell compare:indexPath] == NSOrderedSame) {
        NSNumber *height = [self.cellHeights objectForKey:indexPath];
        if ([height floatValue] < 110) {
            return 110;
        }
        else {
            return [height floatValue];
        }
    } else {
        return 110;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.parentCellCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UNMSideMenuCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sideMenuCustomCell" forIndexPath:indexPath];
    if (indexPath.row < [self.groups count]) {
        NSString *group = self.groups[indexPath.row];
        if ([group isEqualToString:@"MS"]) {
            cell.iconImageView.image = [UIImage imageNamed:@"servicesIcon"];
            cell.separatorView.backgroundColor = [UIColor descTabOrange];
            cell.titleLabel.text = self.cellTitles[0];
        }
        if ([group isEqualToString:@"AU"]) {
            cell.iconImageView.image = [UIImage imageNamed:@"universityIcon"];
            cell.separatorView.backgroundColor = [UIColor clearColor];
            cell.titleLabel.text = self.cellTitles[1];
        }
        if ([group isEqualToString:@"TT"]) {
            cell.iconImageView.image = [UIImage imageNamed:@"trouIcon"];
            cell.separatorView.backgroundColor = [UIColor sideMenuGreen];
            cell.titleLabel.text = self.cellTitles[2];
        }
        if ([group isEqualToString:@"MU"]) {
            cell.iconImageView.image = [UIImage imageNamed:@"vieuIcon"];
            cell.separatorView.backgroundColor = [UIColor sideMenuBlue];
            cell.titleLabel.text = self.cellTitles[3];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.cellIndexPath = indexPath;
    
    cell.backgroundColor = [UIColor clearColor];
    
    [cell setUpWithDelegate:self];
    if (self.selectedCell != nil) {
        if ([self.selectedCell isEqual:indexPath]) {
            cell.separatorView.hidden = NO;
        } else {
            cell.separatorView.hidden = YES;
        }
    } else {
        cell.separatorView.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UNMSideMenuCustomTableViewCell *currentCell = (UNMSideMenuCustomTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UNMSideMenuCustomTableViewCell *lastCell = (UNMSideMenuCustomTableViewCell *)[tableView cellForRowAtIndexPath:self.selectedCell];
    if (indexPath.row < [self.groups count]) {
        NSString *group = self.groups[indexPath.row];
        if ([group isEqualToString:@"AU"]) {
            [UNMUtilities setCenterControllerWithNavControllerIdentifier:@"universityNews"];
            return;
        }
    }
    if (self.selectedCell != nil && [self.selectedCell compare:indexPath] == NSOrderedSame) {
        self.selectedCell = nil;
    } else {
        self.selectedCell = indexPath;
    }
    [self toggleSeparatorOnLastSelectedCell:lastCell andCurrentCell:currentCell];
    [tableView beginUpdates];
    [tableView endUpdates];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)toggleSeparatorOnLastSelectedCell:(UNMSideMenuCustomTableViewCell *)lastCell andCurrentCell:(UNMSideMenuCustomTableViewCell *)currentCell {
    if (lastCell == currentCell) {
        currentCell.separatorView.hidden = YES;
    } else {
        lastCell.separatorView.hidden = YES;
        currentCell.separatorView.hidden = NO;
    }
}

- (NSArray *)itemsForCell:(UNMSideMenuCustomTableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *retValue = [NSMutableArray new];
    if (indexPath.row < [self.groups count]) {
        NSString *group = self.groups[indexPath.row];
        if (group) {
            for (UNMMenuItemBasic *item in self.menuItems) {
                if ([item.grouping isEqualToString:group]) {
                    [retValue addObject:item];
                }
            }
        }
    }
    if (retValue) {
        NSNumber *height = [self.cellHeights objectForKey:indexPath];
        if (height == nil) {
            [self.cellHeights setObject:[NSNumber numberWithFloat:retValue.count * 44.0 + cell.heightWithoutTableView] forKey:indexPath];
        }
    }
    return retValue;
}

-(void)cell:(UNMSideMenuCustomTableViewCell *)cell selectedIndex:(NSInteger)index withMenuItem:(UNMMenuItemBasic *)item {
    if (item) {
        if ([item.name isEqualToString:@"Mon profil"]) {
            [UNMUtilities setCenterControllerWithViewControllerIdentifier:@"profile"];
        } else if ([item.name isEqualToString:@"Mes bibliothèques"]) {
            [UNMUtilities setCenterControllerWithViewControllerIdentifier:@"library"];
        } else if ([item.name isEqualToString:@"Ma médiathèque"]) {
            [UNMUtilities setCenterControllerWithViewControllerIdentifier:@"media"];
        } else if ([item.name isEqualToString:@"GéoCampus"]) {
            [UNMUtilities setCenterControllerToMapWithTabSelected:1];
        } else if ([item.name isEqualToString:@"Que faire à Paris"]) {
            [UNMUtilities setCenterControllerToMapWithTabSelected:2];
        } else if ([item.name isEqualToString:@"Les bons plans"]) {
            [UNMUtilities setCenterControllerToMapWithTabSelected:3];
        } else {
            [UNMUtilities setCenterControllerToWebViewWithURL:item.urlStr andContent:item.dataStr];
        }
    }
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

#pragma mark - UIButton delegate 

- (IBAction)universityLogoTapped:(id)sender {
    [UNMUtilities setCenterControllerWithViewControllerIdentifier:@"home"];
}

@end
