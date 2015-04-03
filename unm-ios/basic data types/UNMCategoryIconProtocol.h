//
//  UNMCategoryIconProtocol.h
//  unm-ios
//
//  Created by UnivMobile on 09/03/15.
//  Copyright (c) 2015 univmobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UNMCategoryIconProtocol <NSObject>
@required
@property (strong, nonatomic) NSNumber *categoryID;
@property (strong, nonatomic) NSString *activeIconName;
@property (strong, nonatomic) NSString *markerIconName;
@end
