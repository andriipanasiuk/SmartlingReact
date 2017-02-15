/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "Smartling.h"

int main(int argc, char * argv[]) {
  @autoreleasepool {
    [Smartling startWithProjectId:@"a1e0e6105" andOptions:@{SLMode:@(SLInAppReview), SLLogging: @(SLLoggingDebug), SLAPIUserId: @"usokdtdefpnwnygqduwmazyqxalthb", SLAPIUserSecret: @"fievop7l9e84pglqs3oa5j6hnaIO^4j2ou4q9jklooe2pldn1qfmrej"}];
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
  }
}
