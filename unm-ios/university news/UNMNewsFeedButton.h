//
//  UNMNewsFeedButton.h
//  
//
//  Created by Andrius Alekna on 27/11/15.
//
//

#import <UIKit/UIKit.h>

@interface UNMNewsFeedButton : UIButton
@property (nonatomic, strong) NSNumber* tagId;
- (instancetype)initWithID:(NSNumber *)ID;
@end
