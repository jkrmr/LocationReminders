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
}

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region {
  NSLog(@"Did enter region: %@", region.identifier);

  UNMutableNotificationContent *content;
  content = [[UNMutableNotificationContent alloc] init];
  content.title = @"you're in the zone!";
  content.body = @"you've entered a monitored region.";
  content.sound = [UNNotificationSound defaultSound];

  // Deliver the notification in five seconds.
  UNTimeIntervalNotificationTrigger* trigger;
  trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5
                                                               repeats:NO];
  UNNotificationRequest* request;
  request = [UNNotificationRequest requestWithIdentifier:@"UserEnteredMonitoredRegion"
                                                 content:content
                                                 trigger:trigger];
  // Schedule the notification.
  UNUserNotificationCenter* center;
  center = [UNUserNotificationCenter currentNotificationCenter];
  [center addNotificationRequest:request withCompletionHandler:nil];
}

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region {
}

- (void)locationManager:(CLLocationManager *)manager
               didVisit:(CLVisit *)visit {
}

- (void)locationManager:(CLLocationManager *)manager
didStartMonitoringForRegion:(CLRegion *)region {
  [manager requestStateForRegion: region];
}

@end
