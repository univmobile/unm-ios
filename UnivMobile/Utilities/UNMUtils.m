//
//  UNMUtils.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 29/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMUtils.h"

@implementation UNMUtils

+ (NSString*)urlEncode:(NSString*)s {
	
	// return [s stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return (NSString*) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
															   (CFStringRef)s, NULL, CFSTR("?!:/=&+"), kCFStringEncodingUTF8));
}

@end
