//
//  SmartlingBridge.m
//  PropertyFinder
//
//  Created by Emilien on 2/14/17.
//  Copyright © 2017 Smartling Inc. All rights reserved.
//

#import "SmartlingBridge.h"
#import "Smartling.h"

#pragma mark - NativeModule

@implementation SmartlingBridge

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(getLocalizedStrings:(RCTResponseSenderBlock)callback) {
  NSDictionary *strings = [SmartlingBridge getStrings];
  callback(@[[NSNull null], strings]);
}

#pragma mark - Helper

+ (NSDictionary *)getStrings {
  NSMutableDictionary *strings = [NSMutableDictionary dictionary];
  
  NSLocale *baseLocale = [Smartling baseLocale];
  NSDictionary *baseLocaleStrings = [Smartling baseLocaleStrings];
  if (baseLocale && baseLocaleStrings) {
    strings[[baseLocale localeIdentifier]] = baseLocaleStrings;
  }
  
  NSLocale *locale = [Smartling locale];
  NSDictionary *localizedStrings = [Smartling localizedStrings];
  if (locale && localizedStrings) {
    strings[[locale localeIdentifier]] = localizedStrings;
  }
  
  // set system locale for react
  NSString *currentLocale = [locale localeIdentifier];
  if (!currentLocale) {
    currentLocale = [baseLocale localeIdentifier];
  }
  
  if (currentLocale) {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *systemLocales = [NSMutableArray arrayWithArray:[ud objectForKey:@"AppleLanguages"]];
    
    if ([systemLocales count] == 0 || ![systemLocales[0] isEqualToString:currentLocale]) {
      [systemLocales insertObject:currentLocale atIndex:0];
      [ud setObject:systemLocales forKey:@"AppleLanguages"];
      [ud synchronize];
    }
  }
  return strings;
}

@end

#pragma mark - NativeAppEventEmitter

@implementation SmartlingEmitter

RCT_EXPORT_MODULE();

- (void)startObserving {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stringsWereUpdated:) name:@"SmartlingStringsUpdatedNotification" object:nil];
}

- (void)stopObserving {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SmartlingStringsUpdatedNotification" object:nil];
}

- (NSArray<NSString *> *)supportedEvents {
  return @[@"SmartlingStringsUpdated"];
}

- (void)stringsWereUpdated:(NSNotification *)notification {
  NSDictionary *strings = [SmartlingBridge getStrings];
  [self sendEventWithName:@"SmartlingStringsUpdated" body:strings];
}

@end
