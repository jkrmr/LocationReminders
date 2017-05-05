//
//  HomeViewController.m
//  LocationReminders
//
//  Created by Jake Romer on 5/1/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController () <LocationControllerDelegate, MKMapViewDelegate,
                                  PFLogInViewControllerDelegate,
                                  PFSignUpViewControllerDelegate>
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
      initWithTarget:self
              action:@selector(mapWasPressed:)];
  longPress.minimumPressDuration = 1.0;
  [self.mapView addGestureRecognizer:longPress];

  LocationController.shared.delegate = self;

  PFQuery *query;
  query = [PFQuery queryWithClassName:@"Reminder"];
  [query setLimit:100];
  [query findObjectsInBackgroundWithBlock:^(NSArray *_Nullable objects,
                                            NSError *_Nullable error) {
    if (error) {
      NSString *errorString = [[error userInfo] objectForKey:@"error"];
      NSLog(@"Error: %@", errorString);
    } else {
      [self displayItemsAsOverlays:objects];
    }
  }];

  [NSNotificationCenter.defaultCenter addObserver:self
                                         selector:@selector(reminderWasSaved)
                                             name:@"ReminderWasSaved"
                                           object:nil];
  
  if (![PFUser currentUser]) {
    PFLogInViewController *loginVC = [[PFLogInViewController alloc] init];
    loginVC.delegate = self;
    loginVC.signUpController.delegate = self;

    loginVC.fields = PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton |
                     PFLogInFieldsUsernameAndPassword;

    [self presentViewController:loginVC animated:YES completion:nil];
  }
}

- (void)reminderWasSaved {
  NSLog(@"hello beatufiul reminder");
}

- (void)mapWasPressed:(UILongPressGestureRecognizer *)gesture {
  if (gesture.state == UIGestureRecognizerStateEnded) {
    CLLocationCoordinate2D coord;
    CGPoint point;
    MKPointAnnotation *pinLocation;

    point = [gesture locationInView:self.mapView];
    coord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    pinLocation = [[MKPointAnnotation alloc] init];
    pinLocation.coordinate = coord;
    pinLocation.title = @"New location";

    [self.mapView addAnnotation:pinLocation];
  }
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

- (void)displayItemsAsOverlays:(NSArray *)reminders {
  NSMutableArray *overlays = [NSMutableArray array];

  for (Reminder *reminder in reminders) {
    MKCircle *circle;
    CLLocationCoordinate2D coord;
    CLLocationDistance radius;

    coord = CLLocationCoordinate2DMake(reminder.location.latitude,
                                       reminder.location.longitude);
    radius = [reminder.radius doubleValue];
    circle = [MKCircle circleWithCenterCoordinate:coord radius:radius];

    [overlays addObject:circle];
  }

  [self.mapView addOverlays:overlays];
}

- (void)setMapLocation:(CLLocationCoordinate2D)location {
  MKCoordinateRegion region;
  MKCoordinateSpan span;

  span = MKCoordinateSpanMake(0.03, 0.03);
  region = MKCoordinateRegionMake(location, span);

  [self.mapView setRegion:region animated:YES];
}

#pragma mark - LocationController delegate methods

- (void)locationControllerUpdatedLocation:(CLLocation *)location {
  MKCoordinateRegion region;
  region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500);
  [self.mapView setRegion:region animated:YES];
}

#pragma mark - MapView delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation {
  MKPinAnnotationView *annotationView;
  UIButton *rightCalloutAccessory;

  if ([annotation isKindOfClass:[MKUserLocation class]]) {
    return nil;
  }

  annotationView = (MKPinAnnotationView *)[mapView
      dequeueReusableAnnotationViewWithIdentifier:@"annotation"];

  annotationView.annotation = annotation;

  if (!annotationView) {
    annotationView =
        [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                        reuseIdentifier:@"annotation"];
  }

  annotationView.canShowCallout = YES;
  annotationView.animatesDrop = YES;
  annotationView.pinTintColor = [MKPinAnnotationView randomColor];

  rightCalloutAccessory =
      [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  annotationView.rightCalloutAccessoryView = rightCalloutAccessory;

  return annotationView;
}

- (void)mapView:(MKMapView *)mapView
                   annotationView:(MKAnnotationView *)view
    calloutAccessoryControlTapped:(UIControl *)control {
  [self performSegueWithIdentifier:@"AddReminderViewController" sender:view];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay {

  MKCircleRenderer *renderer;
  renderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
  renderer.strokeColor = [UIColor blueColor];
  renderer.fillColor = [UIColor redColor];
  renderer.alpha = 0.25;

  return renderer;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  [super prepareForSegue:segue sender:sender];

  if ([[segue identifier] isEqualToString:@"AddReminderViewController"] &&
      [sender isKindOfClass:[MKAnnotationView class]]) {
    AddReminderViewController *addReminderVC;
    MKAnnotationView *annotationView = (MKAnnotationView *)sender;
    addReminderVC =
        (AddReminderViewController *)segue.destinationViewController;
    addReminderVC.coordinate = annotationView.annotation.coordinate;
    addReminderVC.annotationTitle = annotationView.annotation.title;
    addReminderVC.annotationSubtitle = annotationView.annotation.subtitle;
    addReminderVC.title = annotationView.annotation.title;

    __weak typeof(self) weakRef = self;
    addReminderVC.completion = ^(MKCircle *circle) {
      __strong typeof(weakRef) _self = weakRef;

      [_self.mapView removeAnnotation:annotationView.annotation];
      [_self.mapView addOverlay:circle];
    };
  }
}

- (void)dealloc {
  [NSNotificationCenter.defaultCenter removeObserver:self
                                                name:@"ReminderWasSaved"
                                              object:nil];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController
               didSignUpUser:(PFUser *)user {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewController:(PFLogInViewController *)logInController
               didLogInUser:(PFUser *)user {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
