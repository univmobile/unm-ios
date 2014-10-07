//
//  UNMLayout.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 07/10/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMLayout.h"
#import "UIBarButtonItem+UIAccessibility.h"

@interface UNMLayout () <NSXMLParserDelegate>

@property (copy, nonatomic, readonly) NSString* viewId;
@property (weak, nonatomic, readonly) UIViewController* viewController;
@property (strong, nonatomic) id view;
@property (copy, nonatomic) NSString* viewElementName;
@property (copy, nonatomic) NSDictionary* attributes;

- (instancetype) initWithSubViewId:(NSString*)id viewController:(UIViewController*)viewController;

@end

@implementation UNMLayout {
	
	BOOL ended;
}

- (instancetype) initWithSubViewId:(NSString*)viewId viewController:(UIViewController*)viewController {
	
	self = [super init];
	
	if (self) {
		
		_viewId = viewId;
		_viewController = viewController;
		
		self.viewElementName = nil;
		self.attributes = nil;
		
		ended = NO;
	}
	
	return self;
}

+ (id) addLayout:(NSString*)viewId toViewController:(UIViewController*)viewController {
	
	// NSLog(@"addLayout: %@", viewId);
	
	NSString* const path = [[NSBundle mainBundle] pathForResource:@"UNMLayout" ofType:@"xml"];
	
	NSData* const data = [NSData dataWithContentsOfFile:path];
	
	NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithData:data];
	
	UNMLayout* const layout = [[UNMLayout alloc] initWithSubViewId:viewId viewController:viewController];
	
	xmlParser.delegate = layout;
	
	[xmlParser parse];
	
	if (!layout.view) {
		
		NSLog(@"** Error: Unknown viewId: %@", viewId);
		
		return nil;
	}
	
	[viewController.view addSubview:layout.view];
	
	return layout.view;
}

// Overrides: NSXMLParserDelegate
- (void) parser:(NSXMLParser*)parser
didStartElement:(NSString*)elementName
   namespaceURI:(NSString*)namespaceURI
  qualifiedName:(NSString*)qName
	 attributes:(NSDictionary*)attributes {
	
	if (ended) return;
	
	// NSLog(@"elementName: %@", elementName);
	
	NSString* const objectId = [attributes objectForKey:@"id"];
	
	if (objectId && [objectId isEqualToString:self.viewId]) {
		
		self.viewElementName = elementName;
		
		self.attributes = attributes;
		
		return;
	}
	
	if (!self.viewElementName) return;
	
	if ([@"frame" isEqualToString:elementName]) {
		
		CGRect frame;
		
		if ([@"superview.bounds" isEqualToString:[attributes objectForKey:@"ref"]]) {
			
			frame = self.viewController.view.bounds;
			
		} else {
			
			const CGFloat x = [[attributes objectForKey:@"x"] floatValue];
			const CGFloat y = [[attributes objectForKey:@"y"] floatValue];
			const CGFloat width = [[attributes objectForKey:@"width"] floatValue];
			const CGFloat height = [[attributes objectForKey:@"height"] floatValue];
			
			frame = CGRectMake(x, y, width, height);
		}
		
		NSString* const accessibilityIdentifier = [self.attributes objectForKey:@"accessibilityIdentifier"];
		NSString* const text = [self.attributes objectForKey:@"text"];
		NSString* const textColor = [self.attributes objectForKey:@"textColor"];
		NSString* const textAlignment = [self.attributes objectForKey:@"textAlignment"];
		NSString* const backgroundColor = [self.attributes objectForKey:@"backgroundColor"];
		NSString* const hidden = [self.attributes objectForKey:@"hidden"];
		NSString* const returnKeyType = [self.attributes objectForKey:@"returnKeyType"];
		NSString* const keyboardType = [self.attributes objectForKey:@"keyboardType"];
		NSString* const secureTextEntry = [self.attributes objectForKey:@"secureTextEntry"];
		NSString* const lineBreakMode = [self.attributes objectForKey:@"lineBreakMode"];
		
		if ([@"UIButton" isEqualToString:self.viewElementName]) {
		
			UIButton* const button = [[UIButton alloc] initWithFrame:frame];
			
			self.view = button;
			
			if (accessibilityIdentifier) button.accessibilityIdentifier = accessibilityIdentifier;
			if (hidden) button.hidden = [UNMLayout readBoolean:hidden];
			if (lineBreakMode) button.titleLabel.lineBreakMode = [UNMLayout readLineBreakMode:lineBreakMode];
			if (textAlignment) button.titleLabel.textAlignment = [UNMLayout readTextAlignment:textAlignment];
		
		} else if ([@"UILabel" isEqualToString:self.viewElementName]) {
			
			UILabel* const label = [[UILabel alloc] initWithFrame:frame];
			
			self.view = label;
			
			if (accessibilityIdentifier) label.accessibilityIdentifier = accessibilityIdentifier;
			if (text) label.text = text;
			if (textColor) label.textColor = [UNMLayout readColor:textColor];
			if (textAlignment) label.textAlignment = [UNMLayout readTextAlignment:textAlignment];
			if (hidden) label.hidden = [UNMLayout readBoolean:hidden];
			
		} else if ([@"UITextField" isEqualToString:self.viewElementName]) {
			
			UITextField* const textField = [[UITextField alloc] initWithFrame:frame];
			
			self.view = textField;
			
			if (accessibilityIdentifier) textField.accessibilityIdentifier = accessibilityIdentifier;
			// if (text) label.text = text;
			if (textColor) textField.textColor = [UNMLayout readColor:textColor];
			if (textAlignment) textField.textAlignment = [UNMLayout readTextAlignment:textAlignment];
			if (backgroundColor) textField.backgroundColor = [UNMLayout readColor:backgroundColor];
			if (hidden) textField.hidden = [UNMLayout readBoolean:hidden];
			if (returnKeyType) textField.returnKeyType = [UNMLayout readReturnKeyType:returnKeyType];
			if (keyboardType) textField.keyboardType = [UNMLayout readKeyboardType:keyboardType];
			if (secureTextEntry) textField.secureTextEntry = [UNMLayout readBoolean:secureTextEntry];
			
		} else if ([@"UIWebView" isEqualToString:self.viewElementName]) {
			
			UIWebView* const webView = [[UIWebView alloc] initWithFrame:frame];
			
			self.view = webView;
			
			if (accessibilityIdentifier) webView.accessibilityIdentifier = accessibilityIdentifier;
			if (backgroundColor) webView.backgroundColor = [UNMLayout readColor:backgroundColor];
			if (hidden) webView.hidden = [UNMLayout readBoolean:hidden];
			
		} else {
			
			NSLog(@"** Error: Unknown viewElementName: %@", self.viewElementName);
		}
	
		return;
	}
	
	NSString* const value = [attributes objectForKey:@"value"];
	NSString* const forState = [attributes objectForKey:@"forState"];
	NSString* const size = [attributes objectForKey:@"size"];
	
	if ([@"title" isEqualToString:elementName]) {
		
		if ([@"UIButton" isEqualToString:self.viewElementName]) {
				
			[((UIButton*) self.view) setTitle:value forState:[UNMLayout readForState:forState]];

		} else {
			
			NSLog(@"** (%@) Error: Unknown viewElementName: %@", elementName, self.viewElementName);
		}
	
	} else if ([@"titleColor" isEqualToString:elementName]) {
		
		if ([@"UIButton" isEqualToString:self.viewElementName]) {
			
			[((UIButton*) self.view) setTitleColor:[UNMLayout readColor:value]
											forState:[UNMLayout readForState:forState]];
		
		} else {
			
			NSLog(@"** (%@) Error: Unknown viewElementName: %@", elementName, self.viewElementName);
		}
		
	} else if ([@"systemFont" isEqualToString:elementName]) {
		
		if ([@"UILabel" isEqualToString:self.viewElementName]) {
						
			[((UILabel*) self.view) setFont:[UIFont systemFontOfSize:[UNMLayout readFontSize:size]]];
			
		} else {
			
			NSLog(@"** (%@) Error: Unknown viewElementName: %@", elementName, self.viewElementName);
		}
	
	} else {
		
		NSLog(@"** Error: Unknown elementName: %@", elementName);
	}
}

// Overrides: NSXMLParserDelegate
- (void) parser:(NSXMLParser*)parser
  didEndElement:(NSString*)elementName
   namespaceURI:(NSString*)namespaceURI
  qualifiedName:(NSString*)qName {

	if (ended) return;
	
	if ([elementName isEqualToString:self.viewElementName]) {
		
		ended = YES;
	}
}

+ (UIColor*) readColor:(NSString*)value {
	
	if ([@"UIColor.whiteColor" isEqualToString:value]) {
		
		return [UIColor whiteColor];
	
	} else if ([@"UIColor.greenColor" isEqualToString:value]) {
		
		return [UIColor greenColor];
		
	} else if ([@"UIColor.redColor" isEqualToString:value]) {
		
		return [UIColor redColor];
		
	} else if ([@"UIColor.grayColor" isEqualToString:value]) {
		
		return [UIColor grayColor];
		
	} else if ([@"UIColor.lightGrayColor" isEqualToString:value]) {
		
		return [UIColor lightGrayColor];
		
	} else {
		
		NSLog(@"** Error: Unknown color: %@", value);
		
		return nil;
	}
}

+ (UIControlState) readForState:(NSString*)forState {
	
	if ([@"UIControlStateNormal" isEqualToString:forState]) {
		
		return UIControlStateNormal;
		
	} else if ([@"UIControlStateHighlighted" isEqualToString:forState]) {
		
		return UIControlStateHighlighted;
		
	} else if ([@"UIControlStateDisabled" isEqualToString:forState]) {
		
		return UIControlStateDisabled;
		
	} else if ([@"UIControlStateSelected" isEqualToString:forState]) {
		
		return UIControlStateSelected;
		
	} else if ([@"UIControlStateApplication" isEqualToString:forState]) {
		
		return UIControlStateApplication;
		
	} else if ([@"UIControlStateReserved" isEqualToString:forState]) {
		
		return UIControlStateReserved;
		
	} else {
		
		NSLog(@"** Error: Unknown forState: %@", forState);
		
		return UIControlStateNormal;
	}
}

+ (NSLineBreakMode) readLineBreakMode:(NSString*)lineBreakMode {
	
	if ([@"NSLineBreakByWordWrapping" isEqualToString:lineBreakMode]) {
		
		return NSLineBreakByWordWrapping;
		
	} else if ([@"NSLineBreakByCharWrapping" isEqualToString:lineBreakMode]) {
			
		return NSLineBreakByCharWrapping;
		
	} else if ([@"NSLineBreakByClipping" isEqualToString:lineBreakMode]) {
		
		return NSLineBreakByClipping;
		
	} else if ([@"NSLineBreakByTruncatingHead" isEqualToString:lineBreakMode]) {
		
		return NSLineBreakByTruncatingHead;
		
	} else if ([@"NSLineBreakByTruncatingTail" isEqualToString:lineBreakMode]) {
		
		return NSLineBreakByTruncatingTail;
		
	} else if ([@"NSLineBreakByTruncatingMiddle" isEqualToString:lineBreakMode]) {
		
		return NSLineBreakByTruncatingMiddle;

	} else {
		
		NSLog(@"** Error: Unknown lineBreakMode: %@", lineBreakMode);
		
		return NSLineBreakByClipping;
	}
}

+ (NSTextAlignment) readTextAlignment:(NSString*)textAlignement {
				 
	if ([@"NSTextAlignmentCenter" isEqualToString:textAlignement]) {
					 
		return NSTextAlignmentCenter;
					 
	} else {
					 
		NSLog(@"** Error: Unknown textAlignement: %@", textAlignement);
					 
		return NSTextAlignmentLeft;
	}
}
			 
+ (CGFloat) readFontSize:(NSString*)fontSize {
				
	return [fontSize floatValue];
}

+ (BOOL) readBoolean:(NSString*)value {
	
	if ([@"YES" isEqualToString:value] || [@"true" isEqualToString:value]) {
		
		return YES;
		
	} else if ([@"NO" isEqualToString:value] || [@"false" isEqualToString:value]) {
		
		return NO;
		
	} else {
		
		NSLog(@"** Error: Unknown boolean: %@", value);
		
		return NO;
	}
}

+ (UIReturnKeyType) readReturnKeyType:(NSString*)returnKeyType {
	
	if ([@"UIReturnKeyDone" isEqualToString:returnKeyType]) {
		
		return UIReturnKeyDone;
		
	} else {
		
		NSLog(@"** Error: Unknown UIReturnKeyType: %@", returnKeyType);
		
		return UIReturnKeyDone;
	}
}

+ (UIKeyboardType) readKeyboardType:(NSString*)keyboardType {
	
	if ([@"UIKeyboardTypeNamePhonePad" isEqualToString:keyboardType]) {
		
		return UIKeyboardTypeNamePhonePad;
		
	} else {
		
		NSLog(@"** Error: Unknown UIKeyboardTypeNamePhonePad: %@", keyboardType);
		
		return UIKeyboardTypeNamePhonePad;
	}
}

@end
