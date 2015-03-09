//
//  UNMBonPlanViewController.m
//  unm-ios
//
//  Created by UnivMobile on 2/4/15.
//  Copyright (c) 2015 univmobile. All rights reserved.
//

#import "UNMBonPlanViewController.h"
#import "UNMBonPlanScrollView.h"
#import "UNMScrollIndicatorHelper.h"
#import "UIScrollView+ScrollIndicator.h"
#import "UIColor+Extension.h"
#import "UNMConstants.h"
#import "UNMUniversityBasic.h"
#import "UNMUtilities.h"
#import "NSDate+notificationDate.h"

@interface UNMBonPlanViewController ()
@property (strong, nonatomic) UNMScrollIndicatorHelper *scrollHelper;
@property (strong, nonatomic) UNMCategoryBasic *selectedCategory;
@property (strong, nonatomic) UITextField *nextResp;
@end

@implementation UNMBonPlanViewController {
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _scrollHelper = [UNMScrollIndicatorHelper new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categoryButton.layer.cornerRadius = 50;
    self.categoryButton.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_scrollHelper setUpScrollIndicatorWithScrollView:self.scrollView andColor:[UIColor whiteColor]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.25 animations:^{
        [scrollView refreshCustomScrollIndicatorsWithAlpha:0.0];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView refreshCustomScrollIndicatorsWithAlpha:1.0];
}

- (IBAction)didSelectClose:(id)sender {
    if ([self getFirstResponder] != nil) {
        [self resignResponders];
    } else {
        [self askDelegateToClose];
    }
}

- (void)askDelegateToClose {
    if ([self.delegate respondsToSelector:@selector(updateAfterBonPlan)]) {
        [self.delegate updateAfterBonPlan];
    }
    if ([self.delegate respondsToSelector:@selector(closeBonPlanView)]) {
        [self.delegate closeBonPlanView];
    }
}

- (IBAction)didSelectCategory:(id)sender {
    UNMCategoryViewController *categoryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"categorySlideOut"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:categoryVC];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        nav.navigationBar.barTintColor = [UIColor navBarPurple];
        nav.navigationBar.translucent = NO;
        nav.navigationBar.barStyle = UIBarStyleBlack;
    }
    categoryVC.noTopElements = YES;
    categoryVC.allowsMultipleSelect = NO;
    categoryVC.color = [UIColor rightTabGreen];
    categoryVC.delegate = self;
    categoryVC.categoryId = [NSNumber numberWithInt:2];
    [self.navigationController pushViewController:categoryVC animated:YES];
}
- (IBAction)validateButton:(id)sender {
    if (self.selectedCategory && self.nameField.text.length > 0 && self.addressField.text.length > 0 && self.descriptionField.text.length > 0) {
        UNMUniversityBasic *univ = [UNMUniversityBasic getSavedObject];
        UNMUserBasic *user = [UNMUserBasic getSavedObject]; //save users university id to send with bon plan
        if (univ) {
            if (user) {
                CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                [geocoder geocodeAddressString:self.addressField.text completionHandler:^(NSArray* placemarks, NSError* error){
                    if ([placemarks count] == 0) {
                        [UNMUtilities showErrorWithTitle:@"Adresse inconnue" andMessage:@"Impossible de trouver les coordonnées GPS de cette adresse" andDelegate:nil];
                    }
                    for (CLPlacemark* aPlacemark in placemarks)
                    {
                        NSString *latDest = [NSString stringWithFormat:@"%f",aPlacemark.location.coordinate.latitude];
                        NSString *lngDest = [NSString stringWithFormat:@"%f",aPlacemark.location.coordinate.longitude];
                        NSDictionary *params = @{ @"active":@YES,
                                                  @"name":self.nameField.text,
                                                  @"category":[NSString stringWithFormat:@"%@categories/%d",kBaseApiURLStr,[self.selectedCategory.ID intValue]],
                                                  @"university":[NSString stringWithFormat:@"%@universities/%d",kBaseApiURLStr,[user.univID intValue]],
                                                  @"address":self.addressField.text,
                                                  @"phones":self.phoneField.text,
                                                  @"email":self.emailField.text,
                                                  @"description":self.descriptionField.text,
                                                  @"hasEthernet":@1,
                                                  @"hasWifi":@1,
                                                  @"iconRuedesfacs":@1,
                                                  @"createdon":[[NSDate date] bonPlanDateString],
                                                  @"updatedon":[[NSDate date] bonPlanDateString],
                                                  @"lat":latDest,
                                                  @"lng":lngDest
                                                  };
                        [UNMUtilities postToApiWithPath:@"pois" andParams:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [self askDelegateToClose];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [UNMUtilities showErrorWithTitle:@"Impossible d'ajouter le Bon Plan" andMessage:[error localizedDescription]andDelegate:nil];
                        }];
                        break;
                    }
                }];
            } else {
                [UNMUtilities showErrorWithTitle:@"Merci de vous connecter" andMessage:@"Merci de cliquer sur le lien \"connectez-vous\" dans le haut de page" andDelegate:nil];
            }
            
        } else {
            [UNMUtilities showErrorWithTitle:@"Aucune université trouvée" andMessage:@"Merci de choisir une Université" andDelegate:nil];
        }
        
    } else {
        [UNMUtilities showErrorWithTitle:@"Champs obligatoires manquants" andMessage:@"Les champs marqués par * doivent etre rensignés" andDelegate:nil];
    }
}

- (void)layoutForKeyboardShown:(NSNotification *)notification {
    [UIView animateWithDuration:0.5 animations:^{
        [self resizeNameField];
        CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey ] CGRectValue].size.height;
        CGFloat scrollBottomInset = keyboardHeight - CGRectGetHeight(self.validateButton.frame) - CGRectGetHeight(self.bottomSeparator.frame);
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, scrollBottomInset, 0);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
        if (self.descriptionField.isFirstResponder) {
            [self.scrollView scrollRectToVisible:self.descriptionField.frame animated:YES];
        }
    }];
}

- (void)resizeNameField {
    if (self.nextResp == self.nameField) {
        return;
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.categoryNameBarHeightConst.constant = 0;
            self.categoryNameBarView.clipsToBounds = YES;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.categoryButton.hidden = YES;
        }];
    }
}

- (void)layoutForKeyboardHidden:(NSNotification *)notification {
    self.categoryButton.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.categoryNameBarHeightConst.constant = 80;
        self.categoryNameBarView.clipsToBounds = NO;
        self.scrollView.contentInset = UIEdgeInsetsZero;
        [self.view layoutIfNeeded];
    }];
}

- (id)getFirstResponder {
    if (self.addressField.isFirstResponder) {
        return self.addressField;
    } else if (self.phoneField.isFirstResponder) {
        return self.phoneField;
    } else if (self.emailField.isFirstResponder) {
        return self.emailField;
    } else if (self.descriptionField.isFirstResponder) {
        return self.descriptionField;
    } else if (self.nameField.isFirstResponder) {
        return self.nameField;
    }
    return nil;
}

- (void)resignResponders {
    if (self.nameField.isFirstResponder) {
        [self.nameField resignFirstResponder];
    } else if (self.addressField.isFirstResponder) {
        [self.addressField resignFirstResponder];
    } else if (self.phoneField.isFirstResponder) {
        [self.phoneField resignFirstResponder];
    } else if (self.emailField.isFirstResponder) {
        [self.emailField resignFirstResponder];
    } else if (self.descriptionField.isFirstResponder) {
        [self.descriptionField resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameField) {
        [self.addressField becomeFirstResponder];
    } else if (textField == self.addressField) {
        [self.phoneField becomeFirstResponder];
    } else if (textField == self.phoneField) {
        [self.emailField becomeFirstResponder];
    } else if (textField == self.emailField) {
        [self.descriptionField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0]; //known bug, adds new line to textview without this
    }
    UIView *firstResponder = [self getFirstResponder];
    [self.scrollView scrollRectToVisible:firstResponder.frame animated:YES];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    } else {
        return YES;
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.nextResp = textField;
    if (textField != self.nameField) {
        [self resizeNameField];
    }
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self resizeNameField];
    [self.scrollView scrollRectToVisible:self.descriptionField.frame animated:YES];
    return YES;
}

- (IBAction)longPressOnTopSection:(id)sender {
    UILongPressGestureRecognizer *longPressGestureRecognizer = sender;
    if (longPressGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint touchedPoint = [longPressGestureRecognizer locationInView: self.topView];
        if (CGRectContainsPoint(self.topView.bounds, touchedPoint))
        {
            [self resignResponders];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    
    if (touch.view == self.closeButton) {
        return NO;
    }
    return YES;
}

- (void)updateWithCategory:(UNMCategoryBasic *)category {
    if (category) {
        self.selectedCategory = category;
    }
}

- (void)updateWithCategoryImage:(UIImage *)catImage {
    if (catImage) {
        [self.categoryButton setImage:catImage forState:UIControlStateNormal];
    }
}

@end
