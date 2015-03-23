//
//  UNMImageMap.h
//  unm-ios
//
//  Created by UnivMobile on 2/17/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNMImageMap : NSObject
@property (strong, nonatomic) NSNumber *ID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *poisURLStr;
- (instancetype)initWithID:(NSNumber *)ID andName:(NSString *)name andDesc:(NSString *)desc andImageURLStr:(NSString *)imageURLStr andPOISURLStr:(NSString *)poisURLStr;
- (instancetype)initWithPathStr:(NSString *)urlStr andCallback:(void(^)(UNMImageMap *))callback;
@end
