//
//  UNMDebug.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 08/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNMDebug : NSObject

+ (void)debug_recursiveNSLogWithLabel:(NSString*)label associationsForObject:(NSObject*)object;

@end
