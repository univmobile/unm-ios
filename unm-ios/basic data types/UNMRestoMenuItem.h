//
//  UNMRestoMenuItem.h
//  unm-ios
//
//  Created by UnivMobile on 2/20/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNMRestoMenuItem : NSObject
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSNumber *ID;
@property (strong, nonatomic) NSDate *effectiveDate;
+ (void)fetchRestoMenuItemsWithPOIID:(NSNumber *)ID andSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure;
@end
