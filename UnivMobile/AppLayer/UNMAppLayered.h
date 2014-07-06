//
//  UNMAppLayered.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 06/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UNMAppLayer.h"

@protocol UNMAppLayered <NSObject>

@property (weak, nonatomic) UNMAppLayer* appLayer;

@end
