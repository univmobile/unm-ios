//
//  UNMLayout.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 07/10/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
Utility that alloc+init UIView objects based on descriptions
read from a "UNMLayout.xml" file.
*/
@interface UNMLayout : NSObject

+ (id) addLayout:(NSString*)id toView:(UIView*)view;

@end
