//
//  UNMCommentsData.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 02/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>
#import "UNMCommentData.h"

@interface UNMCommentsData : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSArray* comments; // array of UNMCommentData*

- (NSUInteger) sizeOfCommentData;

- (UNMCommentData*) commentDataAtIndex:(NSUInteger)row;

@end
