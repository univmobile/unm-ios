//
//  UNMLoginCallbackProtocol.h
//  unm-ios
//
//  Created by UnivMobile on 2/20/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UNMUserBasic.h"

@protocol UNMLoginCallbackProtocol <NSObject>
- (void)updateNavBarWithUser:(UNMUserBasic *)user;
@end
