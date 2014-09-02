//
//  UNMDebug.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 08/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMDebug.h"
#import "UNMRuntime.h"

@implementation UNMDebug

+ (void)debug_recursiveNSLogWithLabel:(NSString*)label associationsForObject:(NSObject*)object {
	
#ifdef UNM_DEBUG
	
	[UNMDebug debug_recursiveNSLogWithLabel:label associationsForObject:object alreadyDumped:[NSMutableArray new]];

#endif
	
}

+ (void)debug_recursiveNSLogWithLabel:(NSString*)label
				associationsForObject:(NSObject*)object
						alreadyDumped:(NSMutableArray*)alreadyDumped {
	
	NSString* const objectAddressAsString = [UNMDebug toString:object];
	
	if ([alreadyDumped containsObject:objectAddressAsString]) return;
	
	NSLog(@"Dumping object associations for: %@ = %@...", label, objectAddressAsString);
	
	Class cls = [object class];
	
	NSLog(@"%@.class: %@", label, cls);
	
	unsigned int propertyCount;
	
	const objc_property_t* const properties = class_copyPropertyList(cls, &propertyCount);
	
	for (int i = 0; i < propertyCount; ++i) {
		
		const objc_property_t property = properties[i];
		
		const char* const property_name = property_getName(property);
		const char* const property_attributes = property_getAttributes(property);
		const id property_value = [UNMDebug get_property_value:property inObject:object];
		
		NSLog(@"%@.properties[%d]: %s (%s) = %@", label, i, property_name, property_attributes,
			  [UNMDebug toString:property_value]);
	}
		
#ifdef UNM_DEBUG
	
	UNMRuntime* runtime = [UNMRuntime sharedInstance];
	
	NSArray* const objectAssociations = [runtime objectAssociations];
	
	[objectAssociations enumerateObjectsUsingBlock:^(UNMRuntimeObjectAssociation* const objectAssociation, const NSUInteger index, BOOL* stop) {
		
		if (object == objectAssociation.object) {
			
			NSString* policy = [NSString stringWithFormat:@"%lu", objectAssociation.policy];
			
			switch (objectAssociation.policy) {
				case OBJC_ASSOCIATION_ASSIGN:
					policy = @""; // empty string
					break;
				case OBJC_ASSOCIATION_RETAIN_NONATOMIC:
					policy = @"&,N";
					break;
				case OBJC_ASSOCIATION_COPY_NONATOMIC:
					policy = @"C,N";
					break;
				case OBJC_ASSOCIATION_RETAIN:
					policy = @"&";
					break;
				case OBJC_ASSOCIATION_COPY:
					policy = @"C";
					break;
				default:
					break;
			}
			
			NSLog(@"%@.associatedObject[%d]: %s (T@\"%@\",%@) = %@", label, index,
				  objectAssociation.key,
				  [objectAssociation.value class],
				  policy,
				  [UNMDebug toString:objectAssociation.value]);
		}
	}];
	
#endif
	
	[alreadyDumped addObject:objectAddressAsString];
	
	for (int i = 0; i < propertyCount; ++i) {
		
		const objc_property_t property = properties[i];
		
		const char* const property_name = property_getName(property);
		const id property_value = [UNMDebug get_property_value:property inObject:object];
		
		[UNMDebug debug_recursiveNSLogWithLabel:[NSString stringWithFormat:@"%s", property_name]
						  associationsForObject:property_value
								  alreadyDumped:alreadyDumped];
	}
}

+ (id)get_property_value:(objc_property_t)property inObject:(id)object {
	
	unsigned int attributeCount;
	
	const objc_property_attribute_t* const attributes = property_copyAttributeList(property, &attributeCount);
	
	NSString* ivarName = nil;
	
	for (int i = 0; i < attributeCount; ++i) {
		
		const objc_property_attribute_t attribute = attributes[i];
		
		if (attribute.name[0] == 'V' && attribute.name[1] == 0) {
						
			ivarName = [NSString stringWithFormat:@"%s", attribute.value];
			
			break;
		}
	}
	
	if (ivarName == nil) return @"!iVar?";
	
	return [object valueForKey:ivarName];
}

+ (NSString*)toString:(id)object {
	
	return [NSString stringWithFormat:@"%p", object];
}

@end
