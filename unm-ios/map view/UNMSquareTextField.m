//
//  UNMSquareTextField.m
//  unm-ios
//
//  Created by UnivMobile on 2/5/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMSquareTextField.h"

@implementation UNMSquareTextField

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}
@end
