//
//  UNMBuildInfo.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 09/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNMBuildInfo : NSObject

// e.g. @"2014-07-08_13_19_00"
@property (copy, nonatomic, readonly) NSString* BUILD_ID;

// e.g. @"#153"
@property (copy, nonatomic, readonly) NSString* BUILD_DISPLAY_NAME;

// e.g. @"153"
@property (copy, nonatomic, readonly) NSString* BUILD_NUMBER;

// e.g. @"c159768e3c52b27bb15e4b8c9d865a3debe667e0"
@property (copy, nonatomic, readonly) NSString* GIT_COMMIT;

// e.g. @"https://univmobile-dev.univ-paris1.fr/json/"
@property (copy, nonatomic, readonly) NSString* UNMJsonBaseURL;

@end