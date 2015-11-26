//
//  UNMNewsFeed.h
//  unm-ios
//
//  Created by Arnas Dundulis on 26/11/15.
//  Copyright © 2015 univmobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNMNewsFeed : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *ID;

- (instancetype)initWithID:(NSNumber *)ID andTitle:(NSString *)title;
+ (void)fetchUniversityNewsFeedsWithUniversityID:(NSNumber *)ID success:(void(^)(NSArray *))callback;
@end
