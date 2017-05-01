//
//  ParseConfiguration.m
//  LocationReminders
//
//  Created by Jake Romer on 5/1/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

#import "ParseConfiguration.h"

@implementation ParseConfiguration
+ (void)configure {
  ParseClientConfiguration *parseConfig;

  parseConfig = [ParseClientConfiguration
      configurationWithBlock:^(
          id<ParseMutableClientConfiguration> _Nonnull configuration) {
        configuration.applicationId = [Settings parseAppId];
        configuration.clientKey = [Settings parseClientKey];
        configuration.server = [Settings parseServerUrl];
      }];

  [Parse initializeWithConfiguration:parseConfig];
}

@end
