//
//  UNMBonPlanViewController.h
//  unm-ios
//
//  Created by UnivMobile on 2/4/15.
//  Copyright (c) 2015 univmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNMBonPlanScrollView.h"
#import "UNMViewWithUnclippedButton.h"
#import "UNMCategoryViewController.h"

@protocol UNMBonPlanViewControllerDelegate <NSObject>
- (void)closeBonPlanView;
- (void)updateAfterBonPlan;
@end

@interface UNMBonPlanViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UNMCategoryViewControllerDelegate>
@property (weak, nonatomic) id<UNMBonPlanViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UIView *categoryNameBarView;
@property (weak, nonatomic) IBOutlet UIControl *validateButton;
@property (weak, nonatomic) IBOutlet UIView *bottomSeparator;
@property (weak, nonatomic) IBOutlet UNMBonPlanScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UNMViewWithUnclippedButton *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryNameBarHeightConst;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
- (void)layoutForKeyboardShown:(NSNotification *)notification;
- (void)layoutForKeyboardHidden:(NSNotification *)notification;
@end
