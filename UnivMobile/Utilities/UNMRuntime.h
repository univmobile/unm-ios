//
//  UNMRuntime.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 08/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

@import Foundation;
#import <objc/runtime.h>

// #define UNM_DEBUG
#undef UNM_DEBUG

@interface UNMRuntime : NSObject

// Using this class method instead of the objc_setAssociatedObject function
// from objc/runtime.h allows to track low-level object associations.
//
// Based on objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
// from objc/runtime.h
+ (void)objc_setAssociatedObject:(id)object
							 key:(void*)key
						   value:(id)value
						  policy:(objc_AssociationPolicy)policy;

#ifdef UNM_DEBUG

+ (instancetype)sharedInstance;

// Array of UNMRuntimeObjectAssociation
- (NSArray*)objectAssociations;

#endif

@end

#ifdef UNM_DEBUG

@interface UNMRuntimeObjectAssociation : NSObject

@property (assign, readonly) id object;
@property (assign, readonly) void* key;
@property (assign, readonly) id value;
@property (assign, readonly) objc_AssociationPolicy policy;

- (instancetype)initWithObject:(id)object key:(void*)key value:(id)value policy:(objc_AssociationPolicy)policy;

@end

#endif
