//
//  HomeViewController.m
//  LocationReminders
//
//  Created by Jake Romer on 5/1/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

#import "HomeViewController.h"
#import "AddReminderViewController.h"

@interface HomeViewController () <LocationControllerDelegate, MKMapViewDelegate>
@property(weak, nonatomic) IBOutlet MKMapView *mapView;
@property(weak, nonatomic) IBOutlet UISegmentedControl *locationSelector;
@property(strong, nonatomic) LocationController *locationController;
@end

@implementation HomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.mapView.showsUserLocation = YES;
  self.mapView.delegate = self;

  UILongPressGestureRecognizer *longPress;
  longPress = [[UILongPressGestureRecognizer alloc]
               initWithTarget:self action:@selector(mapWasPressed:)];
  longPress.minimumPressDuration = 1.0;
  [self.mapView addGestureRecognizer:longPress];

  LocationController.shared.delegate = self;
}

- (void) mapWasPressed:(UILongPressGestureRecognizer*)gesture {
  if (gesture.state == UIGestureRecognizerStateEnded) {
    CLLocationCoordinate2D coord;
    CGPoint point;
    MKPointAnnotation *pinLocation;

    point = [gesture locationInView:self.mapView];
    coord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    pinLocation = [[MKPointAnnotation alloc] init];
    pinLocation.coordinate = coord;
    pinLocation.title = @"Jake's Steak House";
    pinLocation.subtitle = @"where the magic happens";
    
    [self.mapView addAnnotation:pinLocation];
  }
}

- (void)performTestQuery {
  PFObject *testObj = [[PFObject alloc] initWithClassName:@"TestObject"];
  testObj[@"name"] = @"Jake";
  [testObj
      saveInBackgroundWithBlock:^(BOOL succeeded, NSError *_Nullable error) {
        if (succeeded) {
          NSLog(@"good!");
        } else {
          NSLog(@"no good!");
        }
      }];

  PFQuery *query = [PFQuery queryWithClassName:@"TestObject"];
  [query findObjectsInBackgroundWithBlock:^(NSArray *_Nullable objects,
                                            NSError *_Nullable error) {
    if (error) {
      NSLog(@"Error: %@", error.localizedDescription);
    } else {
      NSLog(@"Query results: %@", objects);
    }
  }];
}

#pragma mark - IBActions

- (IBAction)locationSelectonDidChange:(UISegmentedControl *)sender {
  [self displaySelectedMap];
}

#pragma mark - Map display logic

- (void)displaySelectedMap {
  NSString *selectedMap;
  NSInteger selectedIndex;
  CLLocationCoordinate2D location;

  selectedIndex = [self.locationSelector selectedSegmentIndex];
  selectedMap = [self.locationSelector titleForSegmentAtIndex:selectedIndex];

  if ([selectedMap isEqualToString:@"🏡"]) {
    location = CLLocationCoordinate2DMake(40.7829, -73.9654);
  } else if ([selectedMap isEqualToString:@"🥂"]) {
    location = CLLocationCoordinate2DMake(51.5033640, -0.1276250);
  } else if ([selectedMap isEqualToString:@"🚢"]) {
    location = CLLocationCoordinate2DMake(45.4997210, -73.5511130);
  } else {
    NSLog(@"Unrecognized selection.");
    location = CLLocationCoordinate2DMake(40.7829, -73.9654);
  }

  [self setMapLocation:location];
}

- (void)setMapLocation:(CLLocationCoordinate2D)location {
  MKCoordinateRegion region;
  MKCoordinateSpan span;

  span = MKCoordinateSpanMake(0.03, 0.03);
  region = MKCoordinateRegionMake(location, span);

  [self.mapView setRegion:region animated:YES];
}

#pragma mark - LocationController delegate methods

- (void) locationControllerUpdatedLocation:(CLLocation *)location {
  MKCoordinateRegion region;
  region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500);
  [self.mapView setRegion:region animated:YES];
}


#pragma mark - MapView delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  MKPinAnnotationView *annotationView;
  UIButton *rightCalloutAccessory;
  
  if ([annotation isKindOfClass:[MKUserLocation class]]) {
    return nil;
  }

  annotationView = (MKPinAnnotationView*)
    [mapView dequeueReusableAnnotationViewWithIdentifier:@"annotation"];

  annotationView.annotation = annotation;

  if (!annotationView) {
    annotationView = [[MKPinAnnotationView alloc]
                      initWithAnnotation:annotation
                      reuseIdentifier:@"annotation"];
  }

  annotationView.canShowCallout = YES;
  annotationView.animatesDrop = YES;

  // "(i)" button
  rightCalloutAccessory = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  [rightCalloutAccessory addTarget:self
                            action:@selector(infoButtonWasTapped:)
                  forControlEvents:UIControlEventTouchUpInside];
  
  annotationView.rightCalloutAccessoryView = rightCalloutAccessory;
  
  return annotationView;
}

- (void) infoButtonWasTapped:(UIButton*)sender {
  [self performSegueWithIdentifier:@"AddReminderViewController" sender:sender];
}
@end
