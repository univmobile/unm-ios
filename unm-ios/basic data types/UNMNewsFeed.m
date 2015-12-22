//
//  UNMNewsFeed.m
//  unm-ios
//
//  Created by Arnas Dundulis on 26/11/15.
//  Copyright © 2015 univmobile. All rights reserved.
//

#import "UNMNewsFeed.h"
#import "UNMUtilities.h"
#import "UNMConstants.h"

@implementation UNMNewsFeedSelectable

- (instancetype)initWithNewsFeed:(UNMNewsFeed *)newsFeed andSelected:(BOOL)selected {
    self = [super init];
    if (self) {
        _item = newsFeed;
        _selected = selected;
    }
    return self;
}
+ (NSDictionary <NSString *, UNMNewsFeedSelectable *> *) selectableNewsFeeds: (NSArray *) newsFeeds {
    NSDictionary<NSString *, UNMNewsFeedSelectable *> *returnDict = [NSMutableDictionary new];
    
    for (UNMNewsFeed *item in newsFeeds) {

        UNMNewsFeedSelectable *selectable = [[UNMNewsFeedSelectable alloc] initWithNewsFeed:item andSelected: YES];
        
        [returnDict setValue:selectable forKey:[selectable.item.ID stringValue]];
    }
    return returnDict;
}

@end

@implementation UNMNewsFeed
- (instancetype)initWithID:(NSNumber *)ID andTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _ID = ID;
        _title = title;
    }
    return self;
}

+ (void)fetchUniversityNewsFeedsWithUniversityID:(NSNumber *)ID success:(void(^)(NSArray *))callback {
//    NSArray *mockArray = @[ @{@"id":@"1",@"title":@"number 1"},@{@"id":@"2",@"title":@"number 2222222 22 22 "},@{@"id":@"3",@"title":@"number 3"},@{@"id":@"4",@"title":@"number 4"},@{@"id":@"5",@"title":@"number 5"},@{@"id":@"6",@"title":@"number 6"},@{@"id":@"7",@"title":@"number 7"},@{@"id":@"8",@"title":@"number 8"}  ];
//    callback([self parseResponseWithArray:mockArray]);
    NSString *path = [NSString stringWithFormat:@"%@%d",@"feeds/search/findAllActiveRssFeedsForUniversity?universityId=",[ID intValue]];
    [UNMUtilities fetchFromApiWithPath:path success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *returnArray = [self parseResponseWithArray:responseObject];
        callback(returnArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [UNMUtilities showErrorWithTitle:@"Impossible de charger les informations utilisateur" andMessage:[error localizedDescription] andDelegate:nil];
    }];
}

+ (NSArray *)parseResponseWithArray:(NSDictionary *)array {
    NSMutableArray *returnArray = [NSMutableArray new];
    NSDictionary *feeds = array[@"_embedded"];
    NSArray *feedsArray = feeds[@"feeds"];
    for (NSDictionary *newsFeed in feedsArray) {
        NSNumber *ID = newsFeed[@"id"];
        NSString *title = newsFeed[@"name"];
        if (ID && ![ID isKindOfClass:[NSNull class]] && title && ![title isKindOfClass:[NSNull class]]) {
            UNMNewsFeed *item = [[UNMNewsFeed alloc] initWithID:ID andTitle:title];
            [returnArray addObject:item];
        }
    }
    return returnArray;
}
@end
