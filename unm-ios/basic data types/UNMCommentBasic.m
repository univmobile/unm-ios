//
//  UNMCommentBasic.m
//  unm-ios
//
//  Created by UnivMobile on 2/6/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMCommentBasic.h"

@implementation UNMCommentBasic
- (instancetype)initWithName:(NSString *)name andDate:(NSDate *)date andComment:(NSString *)comment {
    self = [super init];
    if (self) {
        _name = name;
        _date = date;
        _comment = comment;
    }
    return self;
}
@end
