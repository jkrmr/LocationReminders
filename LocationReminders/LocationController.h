//
//  LocationController.h
//  LocationReminders
//
//  Created by Jake Romer on 5/2/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

@import Foundation;
@import CoreLocation;
@import MapKit;

@protocol LocationControllerDelegate <NSObject>
- (void) locationControllerUpdatedLocation:(CLLocation *) location;
@end

@interface LocationController : NSObject
@property (weak, nonatomic) id delegate;
+ (instancetype) shared;
@end
