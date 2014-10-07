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

@property (strong, nonatomic, readonly) id viewId;
@property (strong, nonatomic) id view;
@property (strong, nonatomic) NSString* viewElementName;
@property (strong, nonatomic) NSString* accessibilityIdentifier;

- (instancetype) initWithViewId:(NSString*)id ;

@end

@implementation UNMLayout {
	
	BOOL ended;
}

- (instancetype) initWithViewId:(NSString*)viewId {
	
	self = [super init];
	
	if (self) {
		
		_viewId = viewId;
		
		self.viewElementName = nil;
		self.accessibilityIdentifier = nil;
		
		ended = NO;
	}
	
	return self;
}

+ (id) addLayout:(NSString*)viewId toView:(UIView*)view {
	
	NSLog(@"addLayout: %@", viewId);
	
	NSString* const path = [[NSBundle mainBundle] pathForResource:@"UNMLayout" ofType:@"xml"];
	
	NSData* const data = [NSData dataWithContentsOfFile:path];
	
	NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithData:data];
	
	UNMLayout* const layout = [[UNMLayout alloc] initWithViewId:viewId];
	
	xmlParser.delegate = layout;
	
	[xmlParser parse];
	
	if (!layout.view) {
		
		NSLog(@"** Error: Unknown viewId: %@", viewId);
		
		return nil;
	}
	
	[view addSubview:layout.view];
	
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
		
		self.accessibilityIdentifier = [attributes objectForKey:@"accessibilityIdentifier"];
		
		return;
	}
	
	if (!self.viewElementName) return;
	
	if ([@"frame" isEqualToString:elementName]) {
		
		const CGFloat x = [[attributes objectForKey:@"x"] floatValue];
		const CGFloat y = [[attributes objectForKey:@"y"] floatValue];
		const CGFloat width = [[attributes objectForKey:@"width"] floatValue];
		const CGFloat height = [[attributes objectForKey:@"height"] floatValue];
		
		const CGRect frame = CGRectMake(x, y, width, height);
		
		if ([@"UIButton" isEqualToString:self.viewElementName]) {
		
			UIButton* const button = [[UIButton alloc] initWithFrame:frame];
			
			self.view = button;
			
			if (self.accessibilityIdentifier) button.accessibilityIdentifier = self.accessibilityIdentifier;
		
		} else {
			
			NSLog(@"** Error: Unknown viewElementName: %@", self.viewElementName);
		}
	
		return;
	}
	
	NSString* const value = [attributes objectForKey:@"value"];
	NSString* const forState = [attributes objectForKey:@"forState"];
	
	if ([@"title" isEqualToString:elementName]) {
		
		if ([@"UIButton" isEqualToString:self.viewElementName]) {
		
			if ([@"UIControlStateNormal" isEqualToString:forState]) {
				
				[((UIButton*) self.view) setTitle:value forState:UIControlStateNormal];
			
			} else {
				
				NSLog(@"** Error: Unknown forState: %@", forState);
			}
			
		} else {
			
			NSLog(@"** Error: Unknown viewElementName: %@", self.viewElementName);
		}
	
	} else if ([@"titleColor" isEqualToString:elementName]) {
		
		if ([@"UIButton" isEqualToString:self.viewElementName]) {
			
			if ([@"UIControlStateHighlighted" isEqualToString:forState]) {
				
				if ([@"UIColor.greenColor" isEqualToString:value]) {
				
					[((UIButton*) self.view) setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
					
				} else {
				
					NSLog(@"** Error: Unknown titleColor: %@", value);
				}
			
			} else {
				
				NSLog(@"** Error: Unknown forState: %@", forState);
			}
		
		} else {
			
			NSLog(@"** Error: Unknown viewElementName: %@", self.viewElementName);
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

@end
