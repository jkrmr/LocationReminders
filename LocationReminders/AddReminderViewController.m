//
//  AddReminderViewController.m
//  LocationReminders
//
//  Created by Jake Romer on 5/2/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

#import "AddReminderViewController.h"

@interface AddReminderViewController () <UITextFieldDelegate>
@property(weak, nonatomic) IBOutlet UITextField *reminderName;
@property(weak, nonatomic) IBOutlet UITextField *reminderRadius;
@end

@implementation AddReminderViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.reminderName.delegate = self;
  self.reminderRadius.delegate = self;
  [Reminder load];
}

- (IBAction)doneButtonTapped:(UIBarButtonItem *)sender {
  NSNumber *rRadius;
  NSString *rName;
  Reminder *newReminder;
  double rLat, rLon;

  rLat = self.coordinate.latitude;
  rLon = self.coordinate.longitude;
  rName = self.reminderName.text;
  rRadius = [NSNumber numberWithDouble:[self.reminderRadius.text doubleValue]];

  newReminder = [Reminder object];
  newReminder.name = rName;
  newReminder.location = [PFGeoPoint geoPointWithLatitude:rLat longitude:rLon];
  newReminder.radius = rRadius;

  [newReminder saveInBackgroundWithBlock:^(BOOL succeeded,
                                           NSError *_Nullable error) {
    if (!succeeded) {
      NSLog(@"Whoops!");
      return;
    }
    
    NSLog(@"Whoops! It worked!");
    
    [NSNotificationCenter.defaultCenter
        postNotificationName:@"ReminderWasSaved"
                      object:nil];
    
    if (self.completion) {
      MKCircle *circle;
      circle = [MKCircle circleWithCenterCoordinate:self.coordinate
                                             radius:[rRadius doubleValue]];

      if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        CLCircularRegion *region;
        region = [[CLCircularRegion alloc] initWithCenter:self.coordinate
                                                   radius:[rRadius doubleValue]
                                               identifier:self.reminderName.text];
        [LocationController.shared startMonitoringForRegion:region];
      } else {
        NSLog(@"Error: monitoring is not available for CLCircularRegion");
      }
      
      self.completion(circle);
      [self.navigationController popViewControllerAnimated:YES];
    }
  }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  NSInteger nextTag;
  UITextField *nextField;

  nextTag = textField.tag + 1;
  nextField = [[self.view superview] viewWithTag:nextTag];

  if (nextField) {
    [nextField becomeFirstResponder];
  } else {
    [textField resignFirstResponder];
  }

  return NO;
}

@end
