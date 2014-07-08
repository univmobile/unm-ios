//
//  UNMRuntime.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 08/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMRuntime.h"

@implementation UNMRuntime {
	
	NSMutableArray* _objectAssociations;
}

+ (void)objc_setAssociatedObject:(id)object
							 key:(void*)key
						   value:(id)value
						  policy:(objc_AssociationPolicy)policy {
	
	objc_setAssociatedObject(object, key, value, policy);
	
#ifdef UNM_DEBUG
	
	UNMRuntime* const runtime = [UNMRuntime sharedInstance];
	
	[runtime addObject:object associationKey:key value:value policy:policy];
	
#endif
	
}

#ifdef UNM_DEBUG

+ (instancetype)sharedInstance {
	
	static UNMRuntime* sharedInstance = nil;
	static dispatch_once_t onceToken = 0;
	
	dispatch_once(&onceToken, ^{
		sharedInstance = [[UNMRuntime alloc] init];
	});
	
	return sharedInstance;
}

- (instancetype)init {
	
	self = [super init];
	
	if (self) {
		
		_objectAssociations = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (NSArray*)objectAssociations {
	
	return _objectAssociations;
}

- (void)addObject:(id)object associationKey:(void*)key value:(id)value policy:(objc_AssociationPolicy)policy {
	
	UNMRuntimeObjectAssociation* const objectAssociation = [[UNMRuntimeObjectAssociation alloc] initWithObject:object key:key value:value policy:policy];
	
	[_objectAssociations addObject:objectAssociation];
}

#endif

@end

#ifdef UNM_DEBUG

@implementation UNMRuntimeObjectAssociation

- (instancetype)initWithObject:(id)object key:(void*)key value:(id)value policy:(objc_AssociationPolicy)policy {
	
	self = [super init];
	
	if (self) {
		
		_object = object;
		_key = key;
		_value = value;
		_policy = policy;
	}
	
	return self;
}

@end

#endif
