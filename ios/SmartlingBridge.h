//
//  SmartlingBridge.h
//  PropertyFinder
//
//  Created by Emilien on 2/14/17.
//  Copyright © 2017 Smartling Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RCTBridge.h"
#import "RCTEventEmitter.h"

@interface SmartlingBridge : NSObject <RCTBridgeModule>

+ (NSDictionary *)getStrings;

@end

@interface SmartlingEmitter : RCTEventEmitter <RCTBridgeModule>

@end
