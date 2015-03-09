//
//  UNMCommentBasic.h
//  unm-ios
//
//  Created by UnivMobile on 2/6/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNMCommentBasic : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *comment;
- (instancetype)initWithName:(NSString *)name andDate:(NSDate *)date andComment:(NSString *)comment;
@end
