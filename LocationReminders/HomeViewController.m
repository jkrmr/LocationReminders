//
//  HomeViewController.m
//  LocationReminders
//
//  Created by Jake Romer on 5/1/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *locationSelector;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation HomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.mapView.showsUserLocation = YES;

  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  [self.locationManager requestWhenInUseAuthorization];
  [self.locationManager requestLocation];

  CLLocationCoordinate2D location;
  location = CLLocationCoordinate2DMake(47.6062, -122.3321);
  [self setMapLocation: location];
  
  // PFObject *testObj = [[PFObject alloc] initWithClassName:@"TestObject"];
  // testObj[@"name"] = @"Jake";
  // [testObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
  //   if (succeeded) {
  //     NSLog(@"good!");
  //   } else {
  //     NSLog(@"no good!");
  //   }
  // }];

  // PFQuery *query = [PFQuery queryWithClassName:@"TestObject"];
  // [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
  //   if (error) {
  //     NSLog(@"Error: %@", error.localizedDescription);
  //   } else {
  //     NSLog(@"Query results: %@", objects);
  //   }
  // }];
}

- (void) setMapLocation:(CLLocationCoordinate2D)location {
  MKCoordinateRegion region;
  MKCoordinateSpan span;

  span = MKCoordinateSpanMake(0.05, 0.05);
  region = MKCoordinateRegionMake(location, span);
  
  [self.mapView setRegion:region];
}

- (IBAction)locationSelectonDidChange:(UISegmentedControl *)sender {
  NSString *selectedMap;
  CLLocationCoordinate2D location;
  
  selectedMap = [sender titleForSegmentAtIndex: sender.selectedSegmentIndex];

  if ([selectedMap isEqualToString:@"🏡"]) {
    location = CLLocationCoordinate2DMake(40.7671980, -73.8278410);
    [self setMapLocation: location];
  } else if ([selectedMap isEqualToString:@"🥂"]) {
    location = CLLocationCoordinate2DMake(51.5033640, -0.1276250);
    [self setMapLocation: location];
  } else if ([selectedMap isEqualToString:@"🚢"]) {
    location = CLLocationCoordinate2DMake(45.4997210, -73.5511130);
    [self setMapLocation: location];
  } else {
    NSLog(@"what the hell is this");
  }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
  NSLog(@"updated");
}

- (void) locationManager:(CLLocationManager *)manager
        didFailWithError:(NSError *)error {
  NSLog(@"failed");
}

@end
