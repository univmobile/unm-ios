//
//  UIBarButton+UIAccessibilityIdentification.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 18/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UIBarButtonItem+UIAccessibility.h"

@implementation UIBarButtonItem (UIAccessibility)

NSString* _accessibilityIdentifier;

// Override: UIAccessibilityIdentification
- (NSString*) accessibilityIdentifier {
	
	return _accessibilityIdentifier;
}

// Override: UIAccessibilityIdentification
- (void) setAccessibilityIdentifier:(NSString*)accessibilityIdentifier {
	
	_accessibilityIdentifier = accessibilityIdentifier;
}

@end
