//
//  Settings.h
//  LocationReminders
//
//  Created by Jake Romer on 5/1/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject
+ (NSString *)parseAppId;
+ (NSString *)parseClientKey;
+ (NSString *)parseServerUrl;
@end
