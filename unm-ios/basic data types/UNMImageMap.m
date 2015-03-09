//
//  UNMImageMap.m
//  unm-ios
//
//  Created by UnivMobile on 2/17/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMImageMap.h"
#import "UNMUtilities.h"
#import "UNMConstants.h"

@implementation UNMImageMap

- (instancetype)initWithID:(NSNumber *)ID andName:(NSString *)name andDesc:(NSString *)desc andImageURLStr:(NSString *)imageURLStr andPOISURLStr:(NSString *)poisURLStr
{
    self = [super init];
    if (self) {
        _ID = ID;
        _name = name;
        _desc = desc;
        _imageUrl = [NSURL URLWithString:imageURLStr];
        _poisURLStr = poisURLStr;
    }
    return self;
}

- (instancetype)initWithURLStr:(NSString *)urlStr andCallback:(void(^)(UNMImageMap *))callback
{
    self = [super init];
    if (self) {
        [UNMUtilities fetchFromApiWithPath:urlStr success:^(AFHTTPRequestOperation *req,id responseObject){
            
            NSDictionary *embedded = responseObject;
            if (embedded != nil) {
                BOOL active = (BOOL)embedded[@"active"];
                if (active) {
                    NSNumber *ID = embedded[@"id"];
                    NSString *name = embedded[@"name"];
                    NSString *desc = embedded[@"description"];
                    NSString *imageURLStr = embedded[@"url"];
                    NSDictionary *links = embedded[@"_links"];
                    if (links != nil) {
                        NSString *poisURLStr = links[@"pois"][@"href"];
                        if (ID != nil && name != nil && desc != nil && poisURLStr != nil && imageURLStr != nil) {
                            _ID = ID;
                            _name = name;
                            _desc = desc;
                            _imageUrl = [NSURL URLWithString:[kImageDomainStr stringByAppendingString:imageURLStr]];
                            _poisURLStr = poisURLStr;
                            callback(self);
                        }
                    }
                }
            }
        } failure:^(AFHTTPRequestOperation *req,NSError *error){
            [UNMUtilities showErrorWithTitle:@"Impossible d'obtenir le plan du bâtiment" andMessage:[error localizedDescription] andDelegate:nil];
        }];
    }
    return self;
}

@end
