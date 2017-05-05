//
//  LocationController.m
//  LocationReminders
//
//  Created by Jake Romer on 5/2/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

#import "LocationController.h"

@interface LocationController () <CLLocationManagerDelegate>
@property(strong, nonatomic) CLLocationManager *locationManager;
@property(strong, nonatomic) CLLocation *location;
@end

@implementation LocationController

+ (instancetype)shared {
  static LocationController *_shared = nil;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    _shared = [[self alloc] init];
  });

  return _shared;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1;
    self.locationManager.distanceFilter = 100;
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
  }
  return self;
}

- (void) startMonitoringForRegion:(CLRegion *)region {
  [self.locationManager startMonitoringForRegion:region];
}

#pragma mark - CLLocationManager delegate methods

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
  CLLocation *location;
  location = locations.lastObject;
  [self.delegate locationControllerUpdatedLocation:location];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
  NSLog(@"Failed to update the user's location.");
}

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region {
  NSLog(@"Did enter region: %@", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region {
  NSLog(@"Did exit region: %@", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager
               didVisit:(CLVisit *)visit {
  NSLog(@"didVisit: %@", visit);
}

- (void)locationManager:(CLLocationManager *)manager
didStartMonitoringForRegion:(CLRegion *)region {
  NSLog(@"began monitoring for region: %@", region);
  [manager requestStateForRegion: region];
}

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state
              forRegion:(CLRegion *)region {
  NSLog(@"determined state %lil for region %@", (long)state, region);
}
@end
