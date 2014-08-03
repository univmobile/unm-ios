//
//  NSBundle+String.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 04/08/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (String)

+ (NSString*) stringForKey:(NSString*)key defaultValue:(NSString*)defaultValue;

@end



