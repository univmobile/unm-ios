//
//  ViewController.m
//  unm-ios
//
//  Created by UnivMobile on 1/12/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMWelcomeViewController.h"
#import "UNMUniversityBasic.h"
#import "UNMRegionBasic.h"

@interface UNMWelcomeViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewBottomConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopConst;
@property (weak, nonatomic) IBOutlet UILabel *universityNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *universitySelectionButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectionViewTopConst;
@property (weak, nonatomic) IBOutlet UIView *selectionView;
@end

@implementation UNMWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Retour"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:nil
                                                                action:nil];
    
    [self.navigationItem setBackBarButtonItem:backItem];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgSideMenu"]];
    self.universitySelectionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.universitySelectionButton.titleLabel.minimumScaleFactor = 0.5;
    self.universitySelectionButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 25);
    self.selectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgSideMenu"]];
}

- (void)setUniversityNameLabel {
    
    NSString *universityName = [UNMUniversityBasic getSavedObject].title;
    
    if (universityName != nil) {
        [self.universitySelectionButton setTitle:universityName forState:UIControlStateNormal];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self moveSplashUp];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self setUniversityNameLabel];
}

- (void)moveSplashUp {
    [self.view layoutIfNeeded];
    
    self.selectionViewTopConst.constant = -211;
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}
- (IBAction)didSelectOK:(id)sender {
    
    id univ = [UNMUniversityBasic getSavedObject];
    id region = [UNMRegionBasic getSavedObject];
    
    if (univ && region) {
        [self performSegueWithIdentifier:@"home" sender:self];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erreur"
                                                   message:@"Merci de sélectionner une Université"
                                                  delegate:self
                                         cancelButtonTitle:@"Annuler"
                                         otherButtonTitles:@"OK",nil];
        
        [alertView show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self performSegueWithIdentifier:@"regionSelect" sender:self];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    if (self.navigationController.navigationBarHidden) {
        return UIStatusBarStyleBlackTranslucent;
    }
    return UIStatusBarStyleLightContent;
}
@end
