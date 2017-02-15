//
//  SmartlingBridge.h
//  PropertyFinder
//
//  Created by Emilien on 2/14/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RCTBridge.h"
#import "RCTEventEmitter.h"

@interface SmartlingBridge : RCTEventEmitter <RCTBridgeModule>

+ (NSDictionary *)getStrings;

@end
