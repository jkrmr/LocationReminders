//
//  Reminder.m
//  LocationReminders
//
//  Created by Jake Romer on 5/3/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

#import "Reminder.h"

@implementation Reminder

@dynamic name;
@dynamic location;
@dynamic radius;

+ (void) load {
  [self registerSubclass];
}

+ (NSString *) parseClassName {
  return @"Reminder";
}

@end
