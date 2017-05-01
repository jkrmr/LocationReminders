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
@end

@implementation HomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  MKCoordinateRegion region;
  CLLocationCoordinate2D tenDowning, flushing, botaBota;
  MKCoordinateSpan span;
  
  tenDowning = CLLocationCoordinate2DMake(51.5033640, -0.1276250);
  flushing = CLLocationCoordinate2DMake(40.7671980, -73.8278410);
  botaBota = CLLocationCoordinate2DMake(45.4997210, -73.5511130);
  span = MKCoordinateSpanMake(1, 1);
  
  region = MKCoordinateRegionMake(tenDowning, span);
  [self.mapView setRegion:region];

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

- (IBAction)locationSelectonDidChange:(UISegmentedControl *)sender {
}

@end
