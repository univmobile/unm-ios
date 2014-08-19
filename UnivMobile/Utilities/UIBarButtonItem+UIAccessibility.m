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
	
	NSLog(@"--getacc: %@", _accessibilityIdentifier);
	
	return _accessibilityIdentifier;
}

// Override: UIAccessibilityIdentification
- (void) setAccessibilityIdentifier:(NSString*)accessibilityIdentifier {
	
	// NSLog(@"setacc: %@", accessibilityIdentifier);
	
	//self.title=@"toto";
	
	_accessibilityIdentifier = accessibilityIdentifier;
}

@end
