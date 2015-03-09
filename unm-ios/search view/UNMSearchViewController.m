//
//  UNMSearchViewController.m
//  unm-ios
//
//  Created by UnivMobile on 1/20/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMSearchViewController.h"
#import "UIColor+Extension.h"
#import "UNMUniversityBasic.h"
#import "UNMUtilities.h"

@interface UNMSearchViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConst;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) NSArray *mapItems;
@property (strong, nonatomic) UNMUniversityBasic *university;
@property (strong, nonatomic) UIView *activityIndicatorView;
@end

@implementation UNMSearchViewController {
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _mapItems = [NSArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorColor = [self.view backgroundColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if ([self.searchTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor lightGrayColor];
        UIFont *font = [UIFont fontWithName:@"Exo-Medium" size:16.0];
        self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Tapez votre recherche" attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: font}];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (IBAction)backSelected:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)removeSelected:(id)sender {
    self.searchTextField.text = @"";
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey ] CGRectValue].size.height;
    self.tableViewBottomConst.constant = height;
    [UIView animateWithDuration:0.5f animations:^{
        [self.tableView layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.tableViewBottomConst.constant = 20;
    [UIView animateWithDuration:0.5f animations:^{
        [self.tableView layoutIfNeeded];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *query = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([query length] > 0) {
        [self initActivityIndicator];
        NSNumber *catID;
        if ([self.delegate respondsToSelector:@selector(getCategoryID)]) {
            catID = [self.delegate getCategoryID];
        }
        NSNumber *univID;
        if ([self.delegate respondsToSelector:@selector(getUniversityID)]) {
            univID = [self.delegate getUniversityID];
        }
        [[UNMUtilities mapManager].operationQueue cancelAllOperations];
        [UNMMapItemBasic fetchMarkersWithUniversityID:univID andCategoryID:catID andSearchString:query success:^(NSArray *items) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.mapItems = items;
                [self.tableView reloadData];
                [self removeActivityIndicator];
            });
        } failure:^{
            [self removeActivityIndicator];
        }];
    }
    return YES;
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


#pragma mark - Table View Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount = [self.mapItems count];
    if (rowCount == 0) {
        if ([self.headerLabel.text isEqualToString:@"Résultats"]) {
            self.headerLabel.text = @"Pas de résultat";
        }
    } else {
        if ([self.headerLabel.text isEqualToString:@"Pas de résultat"]) {
            self.headerLabel.text = @"Résultats";
        }
    }
    return rowCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    if (indexPath.row < [self.mapItems count]) {
        UNMMapItemBasic *item = self.mapItems[indexPath.row];
        cell.textLabel.text = item.name;
    } else {
        cell.textLabel.text = @"";
    }
    cell.contentView.backgroundColor = [UIColor middleTabPurple];
    return cell;
}

#pragma mark - Table View Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(setSelectedMapItem:)]) {
        if (indexPath.row < [self.mapItems count]) {
            UNMMapItemBasic *item = self.mapItems[indexPath.row];
            [self.delegate setSelectedMapItem:item];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
