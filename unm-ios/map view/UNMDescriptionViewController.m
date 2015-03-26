//
//  UNMDescriptionViewController.m
//  unm-ios
//
//  Created by UnivMobile on 2/2/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMDescriptionViewController.h"
#import "UNMCommentCreationTableViewCell.h"
#import "UNMCommentTableViewCell.h"
#import "CPAnimationSequence.h"
#import "CPAnimationProgram.h"
#import "UNMScrollIndicatorHelper.h"
#import "UIScrollView+ScrollIndicator.h"
#import "UNMUtilities.h"
#import "UNMCommentBasic.h"
#import "UNMDescriptionTableViewCell.h"
#import "NSDate+notificationDate.h"
#import "UIColor+Extension.h"
#import "UNMRestoMenuItem.h"
#import "UNMDescriptionWebViewTBViewCell.h"
#import "UNMConstants.h"
#import "UNMCategoryIcons.h"
#import "UNMBookmarkBasic.h"
#import "UITableView+HeaderResize.h"

typedef NS_ENUM(NSInteger, UNMDescriptionDisplayMode) {
    comment     = 1,
    description = 2,
    restoMenu   = 3
};
@interface UNMDescriptionViewController ()
@property (strong, nonatomic) NSCache *offscreenCells;
@property (strong, nonatomic) NSCache *offscreenCellHeights;
@property (nonatomic) CGFloat commentFieldH;
@property (nonatomic) BOOL customScrollIndicatorSet;
@property (weak, nonatomic) IBOutlet UITextView *addressLabel;
@property (weak, nonatomic) IBOutlet UITextView *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextView *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomButtonLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomButtonValidateLabel;
@property (weak, nonatomic) IBOutlet UIControl *bookmarkButton;
@property (weak, nonatomic) IBOutlet UIImageView *bottomButtonIcon;
@property (weak, nonatomic) IBOutlet UIImageView *bookmarkCheckmarkIcon;
@property (weak, nonatomic) IBOutlet UIImageView *bookmarkRemoveIcon;
@property (weak, nonatomic) IBOutlet UIControl *bottomButton;
@property (strong, nonatomic) UNMScrollIndicatorHelper *scrollHelper;
@property (strong, nonatomic) NSMutableArray *comments;
@property (nonatomic) UNMDescriptionDisplayMode displayMode;
@property (strong, nonatomic) NSArray *restoItems;
@property (strong, nonatomic) NSString *htmlStr;
@property (nonatomic) BOOL bookmarkUnlocked;
@property (strong, nonatomic) UNMUserBasic *user;
@property (strong, nonatomic) NSCache *catIcons;
@property (weak, nonatomic) IBOutlet UIImageView *addressIcon;
@property (weak, nonatomic) IBOutlet UIImageView *phoneIcon;
@property (weak, nonatomic) IBOutlet UIImageView *emailIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressIconHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneIconHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailIconHeight;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@end

@implementation UNMDescriptionViewController {
    
}

@synthesize viewColor = _viewColor;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _isLayouting    = NO;
        _isImageMapDesc = NO;
        _offscreenCells = [NSCache new];
        _offscreenCellHeights = [NSCache new];
        _customScrollIndicatorSet = NO;
        _scrollHelper = [UNMScrollIndicatorHelper new];
        _comments = [NSMutableArray new];
        _displayMode = description;
        _bookmarkUnlocked = YES;
        _catIcons = [NSCache new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topBar.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    [self.commentTab roundCorners:UIRectCornerTopRight radius:8.0];
    [self.infoTab roundCorners:UIRectCornerTopLeft radius:8.0];
    [self.menuTab roundCorners:UIRectCornerTopLeft radius:8.0];
    [self setTabColor:[UIColor descTabOrange] SelectedColor:[UIColor whiteColor]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.infoTab setIconImageWithName:@"poiInfoIcon"];
    [self.commentTab setIconImageWithName:@"poiCommentIcon"];
    [self.menuTab setIconImageWithName:@"menuTab"];
    [self setSelectedTab:0];
    if (self.isImageMapDesc) {
        self.bottomButton.backgroundColor = [UIColor descTabOrange];
        self.bottomButtonLabel.text = @"RETOUR À GÉO'CAMPUS";
    }
    if (self.viewColor) {
        [self setBackgroundColors];
    }
    self.bookmarkButton.layer.cornerRadius = 5.0;
}

- (void)setBackgroundColors {
    self.tableView.backgroundColor = self.viewColor;
    self.view.backgroundColor = self.viewColor;
    self.bottomSeparator.backgroundColor = self.viewColor;
    self.tableView.tableHeaderView.backgroundColor = self.viewColor;
    [self.tableView setIndicatorColor:self.viewColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.scrollHelper  setUpScrollIndicatorWithScrollView:self.tableView andColor:self.viewColor];
}

- (void)removeAddressElements {
    self.addressIconHeight.constant = 0;
    self.addressLabel.hidden = YES;
    [self.addressIcon setNeedsLayout];
}

- (void)removePhoneElements {
    self.phoneIconHeight.constant = 0;
    self.phoneLabel.hidden = YES;
    [self.phoneIcon setNeedsLayout];
}

- (void)removeEmailElements {
    self.emailIconHeight.constant = 0;
    self.emailLabel.hidden= YES;
    [self.emailIcon setNeedsLayout];
}

- (void)addAddressElements {
    self.addressIconHeight.constant = 24;
    self.addressLabel.hidden = NO;
    [self.addressIcon setNeedsLayout];
}

- (void)addPhoneElements {
    self.phoneIconHeight.constant = 27;
    self.phoneLabel.hidden = NO;
    [self.phoneIcon setNeedsLayout];
}

- (void)addEmailElements {
    self.emailIconHeight.constant = 15;
    self.emailLabel.hidden = NO;
    [self.emailIcon setNeedsLayout];
}

- (void)removeEmptyElements {
    if ([self.addressLabel.text length] == 0) {
        [self removeAddressElements];
    }
    else {
        [self addAddressElements];
    }
    if ([self.phoneLabel.text length] == 0) {
        [self removePhoneElements];
    }
    else {
        [self addPhoneElements];
    }
    if ([self.emailLabel.text length] == 0) {
        [self removeEmailElements];
    }
    else {
        [self addEmailElements];
    }
    [self.tableView sizeHeaderToFit];
}


- (CPAnimationStep *)stepsForkeyboardWillShow:(NSNotification *)notification {
    CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey ] CGRectValue].size.height;
    
    return [CPAnimationSequence sequenceWithSteps:
    [CPAnimationStep for:0.1 animate:^{
        self.isLayouting = YES;
        self.topBarHeightConst.constant = 0;
        self.tableViewTop.constant = 0;
        self.topBar.clipsToBounds = YES;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0,keyboardHeight-self.bottomButtonHeightConst.constant-self.separatorHeightConst.constant, 0);
        [self.view layoutIfNeeded];
    }],
    [CPAnimationStep for:0.1 animate:^{
        CGFloat viewHeight = self.view.window.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
        NSIndexPath *indexPath = [self commentEntryIndexPath];
        [self.offscreenCellHeights setObject:[NSNumber numberWithFloat:viewHeight - keyboardHeight] forKey:indexPath];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }],
    [CPAnimationStep for:0.1 animate:^{
        [self.tableView scrollToRowAtIndexPath:[self commentEntryIndexPath] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }],
    nil];
}

- (NSIndexPath *)commentEntryIndexPath {
    NSInteger rowCount = [self tableView:self.tableView numberOfRowsInSection:0];
    return [NSIndexPath indexPathForRow:rowCount-1 inSection:0];
}

- (CPAnimationStep *)stepsForKeyboardWillHide:(NSNotification *)notification {
    return [CPAnimationSequence sequenceWithSteps:
            [CPAnimationStep for:0.1 animate:^{
        self.topBarHeightConst.constant = 78;
        self.tableViewTop.constant = 0;
        self.topBar.clipsToBounds = NO;
        self.tableView.contentInset = UIEdgeInsetsZero;
        [self.offscreenCellHeights removeObjectForKey:[self commentEntryIndexPath]];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        [self.view layoutIfNeeded];
    }],[CPAnimationStep for:0.1 animate:^{
        
    }],nil];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.isLayouting) {
        self.isLayouting = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.tableView == (UITableView *)scrollView) {
        if (!self.isLayouting && self.commentField.isFirstResponder) {
            [self.commentField resignFirstResponder];
        }
    }
    [scrollView refreshCustomScrollIndicatorsWithAlpha:1.0];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.25 animations:^{
        [scrollView refreshCustomScrollIndicatorsWithAlpha:0.0];
    }];
}

- (void)checkIfBookmarked {
    if ([self.delegate respondsToSelector:@selector(itemBookmarked:)]) {
        if ([self.delegate itemBookmarked:self.mapItem]) {
            [self setBookmarkIconChecked:NO];
        } else {
            [self setBookmarkIconChecked:YES];
        }
    }
}

- (void)fetchComments {
    if (self.mapItem && !self.commentTab.hidden) {
        NSString *path = [NSString stringWithFormat:@"comments/search/findByPoiOrderByCreatedOnDesc?poiId=%d",[[[self mapItem] ID] intValue]];
        [UNMUtilities fetchFromApiAuthenticatedWithPath:path success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.comments removeAllObjects];
            NSDictionary *embedded = responseObject[@"_embedded"];
            if (embedded != nil) {
                NSArray *objects = embedded[@"comments"];
                if (objects != nil) {
                    for (NSDictionary *object in objects) {
                        NSString *name = object[@"author"];
                        NSString *commentString = object[@"message"];
                        BOOL active = [[object objectForKey:@"active"] boolValue];
                        NSDate *date = [NSDate getDateFromISOString:object[@"postedOn"]];
                        if (active && name != nil && commentString != nil && date != nil) {
                            UNMCommentBasic *comment = [[UNMCommentBasic alloc] initWithName:name andDate:date andComment:commentString];
                            [self.comments addObject:comment];
                        }
                    }
                }
            }
            [self.offscreenCellHeights removeAllObjects];
            if (self.displayMode == comment) {
                [self.tableView reloadData];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            [UNMUtilities showErrorWithTitle:@"Impossible d'accéder aux informations" andMessage:@"Merci de vérifier que vous êtes connecté à internet" andDelegate:nil];
        }];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.displayMode == comment) {
        return [self.comments count]+1;
    } else { //description or resto menu
        return 1;
    }
}

- (void)stringWithTitle:(NSString *)title andBody:(NSString *)body appendTo:(NSMutableAttributedString *)attrStr {
    NSAttributedString *newLine = [[NSAttributedString alloc]initWithString:@"\n"];
    if ([attrStr length] > 0) {
        [attrStr appendAttributedString:newLine];
    }
    UIFont *font = [UIFont fontWithName:@"Exo-Bold" size:13.0];
    NSDictionary * attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    NSAttributedString * subString = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    [attrStr appendAttributedString:subString];
    [attrStr appendAttributedString:newLine];
    font = [UIFont fontWithName:@"Exo-Regular" size:16.0];
    attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    subString = [[NSAttributedString alloc] initWithString:body attributes:attributes];
    [attrStr appendAttributedString:subString];
}

- (NSRange)linkWithTitle:(NSString *)title andBody:(NSString *)body appendTo:(NSMutableAttributedString *)attrStr {
    NSAttributedString *newLine = [[NSAttributedString alloc]initWithString:@"\n"];
    if ([attrStr length] > 0) {
        [attrStr appendAttributedString:newLine];
    }
    UIFont *font = [UIFont fontWithName:@"Exo-Bold" size:13.0];
    NSDictionary * attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    NSAttributedString * subString = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    [attrStr appendAttributedString:subString];
    [attrStr appendAttributedString:newLine];
    font = [UIFont fontWithName:@"Exo-Regular" size:16.0];
    attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    subString = [[NSAttributedString alloc] initWithString:body attributes:attributes];
    NSRange linkRange = NSMakeRange(attrStr.length, subString.length);
    [attrStr appendAttributedString:subString];
    return linkRange;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.displayMode == comment) {
        if ([self tableView:self.tableView numberOfRowsInSection:0]-1 == indexPath.row) {
            UNMCommentCreationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentEntryField" forIndexPath:indexPath];
            
            self.commentField = cell.commentTextView;
            
            cell.contentView.backgroundColor = self.viewColor;
            cell.bgColorHighlighted = self.viewColor;
            
            return cell;
        } else {
            UNMCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
            
            if ([self.comments count] > indexPath.row) {
                UNMCommentBasic *comment = [self.comments objectAtIndex:indexPath.row];
                cell.nameLabel.text = [comment name];
                cell.nameLabel.textColor = self.viewColor;
                cell.commentLabel.text = [comment comment];
                NSDate *commentDate = [comment date];
                cell.dateLabel.text = [commentDate getTimeSinceString];
            } else {
                cell.nameLabel.text = @"";
                cell.commentLabel.text = @"";
                cell.dateLabel.text = @"";
            }
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            return cell;
        }
    } else if(self.displayMode == description) {
        UNMDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descriptionCell" forIndexPath:indexPath];
        NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithString:@""];
        NSURL *link;
        NSRange linkRange;
        if (self.mapItem) {
            if (self.mapItem.desc && [self.mapItem.desc class] != [NSNull class] && [self.mapItem.desc length] > 0) {
                [self stringWithTitle:@"Description:" andBody:self.mapItem.desc appendTo:labelString];
            }
            if (self.mapItem.website && [self.mapItem.website class] != [NSNull class] && [self.mapItem.website length] > 0) {
                linkRange = [self linkWithTitle:@"Site web:" andBody:self.mapItem.website appendTo:labelString];
                link = [NSURL URLWithString:self.mapItem.website];
            }
            if (self.mapItem.welcome && [self.mapItem.welcome class] != [NSNull class] && [self.mapItem.welcome length] > 0) {
                [self stringWithTitle:@"Publics accueillis:" andBody:self.mapItem.welcome appendTo:labelString];
            }
            if (self.mapItem.disciplines && [self.mapItem.disciplines class] != [NSNull class] && [self.mapItem.disciplines length] > 0) {
                [self stringWithTitle:@"Disciplines:" andBody:self.mapItem.disciplines appendTo:labelString];
            }
            if (self.mapItem.openingHours && [self.mapItem.openingHours class] != [NSNull class] && [self.mapItem.openingHours length] > 0) {
                [self stringWithTitle:@"Horaires et jours d'ouverture:" andBody:self.mapItem.openingHours appendTo:labelString];
            }
            if (self.mapItem.closingHours && [self.mapItem.closingHours class] != [NSNull class] && [self.mapItem.closingHours length] > 0) {
                [self stringWithTitle:@"Horaires et jours de fermeture:" andBody:self.mapItem.closingHours appendTo:labelString];
            }
            if (self.mapItem.floor && [self.mapItem.floor class] != [NSNull class] && [self.mapItem.floor length] > 0) {
                [self stringWithTitle:@"Emplacement:" andBody:self.mapItem.floor appendTo:labelString];
            }
            if (self.mapItem.itinerary && [self.mapItem.itinerary class] != [NSNull class] && [self.mapItem.itinerary length] > 0) {
                [self stringWithTitle:@"Accès:" andBody:self.mapItem.itinerary appendTo:labelString];
            }
        }
        [cell.descriptionLabel setText:labelString];
        if (link) {
            cell.descriptionLabel.linkAttributes = @{ (id)kCTForegroundColorAttributeName: [UIColor blueColor],
                                                      (id)kCTUnderlineStyleAttributeName : [NSNumber numberWithInt:NSUnderlineStyleNone] };
            [cell.descriptionLabel addLinkToURL:link withRange:linkRange];
        }

        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;

    } else {
        UNMDescriptionWebViewTBViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"webviewCell" forIndexPath:indexPath];
        
        if (self.htmlStr) {
            [cell.webview loadHTMLString:self.htmlStr baseURL:nil];
        }
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        return cell;
    }
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier;
    NSNumber *height;
    if (self.displayMode == comment) {
        if ([self tableView:self.tableView numberOfRowsInSection:0]-1 == indexPath.row) {
            reuseIdentifier = @"commentEntryField";
        } else {
            reuseIdentifier = @"commentCell";
        }
        indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        height = [self.offscreenCellHeights objectForKey:indexPath];
        if (!height) {
            
            UITableViewCell *cell = [self.offscreenCells objectForKey:reuseIdentifier];
            if (!cell) {
                cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
                [self.offscreenCells setObject:cell forKey:reuseIdentifier];
            }
            
            if ([reuseIdentifier isEqualToString:@"commentEntryField"]) {

            } else if([reuseIdentifier isEqualToString:@"commentCell"]) {
                UNMCommentTableViewCell *commCell = (UNMCommentTableViewCell *)cell;
                if ([self.comments count] > indexPath.row) {
                    UNMCommentBasic *comment = [self.comments objectAtIndex:indexPath.row];
                    commCell.nameLabel.text    = comment.name;
                    commCell.nameLabel.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds)/2;
                    commCell.dateLabel.text    = [comment.date getTimeSinceString];
                    commCell.dateLabel.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds)/2;
                    commCell.commentLabel.text = comment.comment;
                    commCell.commentLabel.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds);
                } else {
                    commCell.nameLabel.text = @"";
                    commCell.commentLabel.text = @"";
                    commCell.dateLabel.text = @"";
                }
            }
            
            [cell setNeedsUpdateConstraints];
            [cell updateConstraintsIfNeeded];
            
            cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(cell.bounds));
            [cell setNeedsLayout];
            [cell layoutIfNeeded];
            
            if ([reuseIdentifier isEqualToString:@"commentEntryField"]) {
                CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
                height = [NSNumber numberWithFloat:size.height];
            } else if([reuseIdentifier isEqualToString:@"commentCell"]) {

                UNMCommentTableViewCell *commCell = (UNMCommentTableViewCell *)cell;
                CGSize size = [commCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
                height = [NSNumber numberWithFloat:size.height];
            }
            
            height = [NSNumber numberWithFloat:[height floatValue]+1.0f];
            
            [self.offscreenCellHeights setObject:height forKey:indexPath];
        }
        return [height floatValue];
    } else if (self.displayMode == description) {
        reuseIdentifier = @"descriptionCell";
        UITableViewCell *cell = [self.offscreenCells objectForKey:reuseIdentifier];
        if (!cell) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            [self.offscreenCells setObject:cell forKey:reuseIdentifier];
        }
        
        UNMDescriptionTableViewCell *descCell = (UNMDescriptionTableViewCell *)cell;
        NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithString:@""];
        if (self.mapItem) {
            if (self.mapItem.desc && [self.mapItem.desc class] != [NSNull class] && [self.mapItem.desc length] > 0) {
                [self stringWithTitle:@"Description:" andBody:self.mapItem.desc appendTo:labelString];
            }
            if (self.mapItem.website && [self.mapItem.website class] != [NSNull class] && [self.mapItem.website length] > 0) {
                [self stringWithTitle:@"Website:" andBody:self.mapItem.website appendTo:labelString];
            }
            if (self.mapItem.welcome && [self.mapItem.welcome class] != [NSNull class] && [self.mapItem.welcome length] > 0) {
                [self stringWithTitle:@"Welcome:" andBody:self.mapItem.welcome appendTo:labelString];
            }
            if (self.mapItem.disciplines && [self.mapItem.disciplines class] != [NSNull class] && [self.mapItem.disciplines length] > 0) {
                [self stringWithTitle:@"Disciplines:" andBody:self.mapItem.disciplines appendTo:labelString];
            }
            if (self.mapItem.openingHours && [self.mapItem.openingHours class] != [NSNull class] && [self.mapItem.openingHours length] > 0) {
                [self stringWithTitle:@"Opening hours:" andBody:self.mapItem.openingHours appendTo:labelString];
            }
            if (self.mapItem.closingHours && [self.mapItem.closingHours class] != [NSNull class] && [self.mapItem.closingHours length] > 0) {
                [self stringWithTitle:@"Closing hours:" andBody:self.mapItem.closingHours appendTo:labelString];
            }
            if (self.mapItem.floor && [self.mapItem.floor class] != [NSNull class] && [self.mapItem.floor length] > 0) {
                [self stringWithTitle:@"Floor:" andBody:self.mapItem.floor appendTo:labelString];
            }
            if (self.mapItem.itinerary && [self.mapItem.itinerary class] != [NSNull class] && [self.mapItem.itinerary length] > 0) {
                [self stringWithTitle:@"Itinerary:" andBody:self.mapItem.itinerary appendTo:labelString];
            }
        }
        [descCell.descriptionLabel setAttributedText:labelString];
        descCell.descriptionLabel.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds)-16.0f;
    
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        
        cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds)-16.0f, CGRectGetHeight(cell.bounds));
        
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
    
        CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        height = [NSNumber numberWithFloat:size.height];
        
        height = [NSNumber numberWithFloat:[height floatValue]+1.0f];
        
        return [height floatValue];
    } else {
        UNMTabButton *tab = [self.tabs firstObject];
        return CGRectGetHeight(self.tableView.frame) - CGRectGetHeight(tab.frame);
    }
}
- (IBAction)cancelComment:(id)sender {
    [self.commentField resignFirstResponder];
}
- (IBAction)submitComment:(id)sender {
    if ([self.commentField.text length] > 0) {
        NSDictionary *params = @{@"message":self.commentField.text,@"active":@"true",@"poi":[NSString stringWithFormat:@"%@pois/%d",kBaseApiURLStr,[self.mapItem.ID intValue]]};
        [UNMUtilities postToApiWithPath:@"comments" andParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self fetchComments];
            self.commentField.text = @"";
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //Error
        }];
    } else {
        [UNMUtilities showErrorWithTitle:@"Pas de commentaire" andMessage:@"Merci de saisir votre commentaire" andDelegate:nil];
    }
}

- (IBAction)didSelectClose:(id)sender {
    if ([self.delegate respondsToSelector:@selector(closeDescriptionView)]) {
        [self.delegate closeDescriptionView];
    }
}

- (void)setTabColor:(UIColor *)color SelectedColor:(UIColor *)selectedColor {
    for (UNMTabButton *tab in self.tabs) {
        tab.defaultColor = color;
        tab.highlightColor = selectedColor;
    }
}

- (void) setBottomButtonToValidate {
    self.bottomButton.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:97.0/255.0 blue:56.0/255.0 alpha:1.0];
    self.bottomButtonIcon.hidden = YES;
    self.bottomButtonLabel.hidden = YES;
    self.bottomButtonValidateLabel.hidden = NO;
}

- (void) setBottomButtonToSearch {
    self.bottomButton.backgroundColor = [UIColor lightGrayColor];
    self.bottomButtonIcon.hidden = NO;
    self.bottomButtonLabel.hidden = NO;
    self.bottomButtonValidateLabel.hidden = YES;
}

- (void)setSelectedTab:(NSInteger)tabIndex {
    for (UNMTabButton *tab in self.tabs) {
        tab.selected = NO;
    }
    switch (tabIndex) {
        case 0:
            self.displayMode = description;
            self.infoTab.selected = YES;
            [self setBottomButtonToSearch];
            break;
        case 1:
            self.displayMode = comment;
            self.commentTab.selected = YES;
            [self setBottomButtonToValidate];
            break;
        case 2:
            self.displayMode = restoMenu;
            self.menuTab.selected = YES;
            [self setBottomButtonToSearch];
        default:
            break;
    }
    [self.tableView reloadData];
}

- (IBAction)tabSelected:(id)sender {
    if (self.infoTab == sender) {
        [self setSelectedTab:0];
    } else if (self.commentTab == sender) {
        [self setSelectedTab:1];
    } else if (self.menuTab == sender) {
        [self setSelectedTab:2];
        if (self.mapItem) {
            [UNMRestoMenuItem fetchRestoMenuItemsWithPOIID:self.mapItem.ID andSuccess:^(NSArray *items) {
                self.restoItems = items;
                [self addWebviewForRestaurantsWithRestoItems:self.restoItems];
            } failure:^{
            }];
        }
        
    }
}

- (void)addWebviewForRestaurantsWithRestoItems:(NSArray *)items {
    if (self.htmlStr == nil) {
        self.htmlStr = [NSString new];
    }
    BOOL addNextOne = NO;
    NSDate *now = [NSDate date];
    for (UNMRestoMenuItem *item in items) {
        NSInteger days = [item.effectiveDate getDaysBetweenDate:now];
        NSInteger months = [item.effectiveDate getMonthsBetweenDate:now];
        NSInteger years = [item.effectiveDate getYearsBetweenDate:now];
        if (addNextOne) {
            self.htmlStr = [self.htmlStr stringByAppendingString:item.desc];
            break;
        }
        else if (days == 0 && months == 0 && years == 0) {
            addNextOne = YES;
            self.htmlStr = [self.htmlStr stringByAppendingString:item.desc];
        }
    }
    [self.tableView reloadData];
}

-(UIColor *)viewColor {
    if (_viewColor == nil) {
        return [UIColor greenColor];
    } else {
        return _viewColor;
    }
}

- (void)setViewColor:(UIColor *)viewColor {
    _viewColor = viewColor;
    [self setBackgroundColors];
}

- (void)setMapItem:(UNMMapItemBasic *)mapItem {
    _mapItem = mapItem;
    
    if (mapItem.phone && [mapItem.phone class] != [NSNull class]) {
        self.phoneLabel.text = mapItem.phone;
    } else {
        self.phoneLabel.text = @"";
    }
    if (mapItem.address && [mapItem.address class] != [NSNull class]) {
        if (mapItem.cityName && [mapItem.cityName class] != [NSNull class] && mapItem.address.length > 0 && mapItem.cityName.length > 0) {
            self.addressLabel.text = [NSString stringWithFormat:@"%@, %@",mapItem.address,mapItem.cityName];
        }
        else {
            self.addressLabel.text = mapItem.address;
        }
    } else {
        self.addressLabel.text = @"";
    }
    if (mapItem.email && [mapItem.email class] != [NSNull class]) {
        self.emailLabel.text = mapItem.email;
    } else {
        self.emailLabel.text = @"";
    }
    if (mapItem.name && [mapItem.name class] != [NSNull class]) {
        self.titleLabel.text = mapItem.name;
    } else {
        self.titleLabel.text = @"";
    }
    if (!mapItem.restoID || [mapItem.restoID class] == [NSNull class] || mapItem.restoID.length == 0) {
        self.menuTab.hidden = YES;
    } else {
        self.menuTab.hidden = NO;
    }
    if ([mapItem.categoryID class] != [NSNull class]) {
        UIImage *icon = [self.catIcons objectForKey:mapItem.categoryID];
        if (!icon) {
            [UNMCategoryIcons getCategoryImageWithCategoryProtocolItem:mapItem success:^(UNMCategoryIcons *icons) {
                self.categoryIcon.image = icons.activeImage;
                [self.catIcons setObject:icons.activeImage forKey:mapItem.categoryID];
            } failure:^{
                self.categoryIcon.image = nil;
            }];
        } else {
            self.categoryIcon.image = icon;
        }
    } else {
        self.categoryIcon.image = nil;
    }
    [self removeEmptyElements];
    [self.tableView reloadData];
    [self fetchComments];
    [self checkIfBookmarked];
}
- (IBAction)didSelectBottomButton:(id)sender {
    if (self.isImageMapDesc) {
        if ([self.delegate respondsToSelector:@selector(reloadController)]) {
            [self.delegate reloadController];
        }
    } else {
        if (self.commentTab.isSelected) {
            [self submitComment:nil];
        } else {
            if ([self.delegate respondsToSelector:@selector(displaySearch)]) {
                [self.delegate displaySearch];
            }
        }
    }
}

- (void)removeCommentTab {
    self.commentTab.hidden = YES;
}

- (void)addCommentTab {
    self.commentTab.hidden = NO;
}

- (void)setBookmarkIconChecked:(BOOL)checked {
    if (checked) {
        self.bookmarkCheckmarkIcon.hidden = NO;
        self.bookmarkRemoveIcon.hidden = YES;
    } else {
        self.bookmarkCheckmarkIcon.hidden = YES;
        self.bookmarkRemoveIcon.hidden = NO;
    }
}

- (IBAction)bookmark:(id)sender {
    if (self.bookmarkUnlocked) {
        self.bookmarkUnlocked = NO;
        if (!self.user) {
            self.user = [UNMUserBasic getSavedObject];
        }
        if (self.bookmarkRemoveIcon.hidden) {
            if (self.user) {
                NSDictionary *params = @{@"user":[NSString stringWithFormat:@"%@users/%d",kBaseApiURLStr,[self.user.ID intValue]],@"poi":[NSString stringWithFormat:@"%@pois/%d",kBaseApiURLStr,[self.mapItem.ID intValue]]};
                [UNMUtilities postToApiWithPath:@"bookmarks" andParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self setBookmarkIconChecked:NO];
                    if ([self.delegate respondsToSelector:@selector(updateUserBookmarksWithBookmark:)]) {
                        [self.delegate updateUserBookmarksWithBookmark:[[UNMBookmarkBasic alloc]initWithID:nil andPoiUrl:nil andPoiID:self.mapItem.ID andPoiName:self.mapItem.name andTab:self.tabSelected]];
                    }
                    self.bookmarkUnlocked = YES;
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [UNMUtilities showErrorWithTitle:@"Impossible d'enregistrer votre commentaire" andMessage:[error localizedDescription] andDelegate:nil];
                    [self setBookmarkIconChecked:YES];
                    self.bookmarkUnlocked = YES;
                }];
            } else {
                [UNMUtilities showErrorWithTitle:@"Merci de vous connecter" andMessage:@"Seuls les utilisateurs connectés peuvent enregistrer des commentaires" andDelegate:nil];
                self.bookmarkUnlocked = YES;
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(bookmarkForMapItem:)]) {
                UNMBookmarkBasic *bookmark = [self.delegate bookmarkForMapItem:self.mapItem];
                if (bookmark && self.user) {
                    [UNMUtilities deleteToApiWithPath:[NSString stringWithFormat:@"bookmarks/%d",[bookmark.ID intValue]] andParams:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self setBookmarkIconChecked:YES];
                        if ([self.delegate respondsToSelector:@selector(removeUserBookmark:)]) {
                            [self.delegate removeUserBookmark:bookmark];
                        }
                        self.bookmarkUnlocked = YES;
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [UNMUtilities showErrorWithTitle:@"Impossible de supprimer le bookmark" andMessage:[error localizedDescription] andDelegate:nil];
                        [self setBookmarkIconChecked:NO];
                        self.bookmarkUnlocked = YES;
                    }];
                } else {
                    [UNMUtilities showErrorWithTitle:@"Merci de vous connecter" andMessage:@"Vous devez être connecté pour pouvoir ajouter un bookmark" andDelegate:nil];
                    self.bookmarkUnlocked = YES;
                }
            }
            else {
                self.bookmarkUnlocked = YES;
            }
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView == self.commentField && [text isEqualToString:@"\n"]) {
        [self cancelComment:nil];
        return NO;
    } else {
        return YES;
    }
}
@end
