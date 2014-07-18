//
//  UIBarButton+UIAccessibilityIdentification.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 18/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

@import Foundation;

@interface UIBarButtonItem (UIAccessibility) <UIAccessibilityIdentification>

@property (copy, nonatomic) NSString* accessibilityIdentifier;

@end
