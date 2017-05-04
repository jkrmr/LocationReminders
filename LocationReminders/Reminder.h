//
//  Reminder.h
//  LocationReminders
//
//  Created by Jake Romer on 5/3/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

@import Foundation;
@import Parse;

@interface Reminder : PFObject <PFSubclassing>

@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) PFGeoPoint *location;
@property(strong, nonatomic) NSNumber *radius;

@end
