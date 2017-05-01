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
}

- (IBAction)locationSelectonDidChange:(UISegmentedControl *)sender {
  NSLog(sender);
  NSLog(@"hello");
}

@end
