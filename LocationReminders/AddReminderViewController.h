//
//  AddReminderViewController.h
//  LocationReminders
//
//  Created by Jake Romer on 5/2/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

@import UIKit;
@import CoreLocation;
@import Parse;
@import MapKit;
#import "Reminder.h"
#import "LocationController.h"

typedef void (^PFPostCompletion)(MKCircle *circle);

@interface AddReminderViewController : UIViewController
@property(nonatomic) CLLocationCoordinate2D coordinate;
@property(strong, nonatomic) NSString *annotationTitle;
@property(strong, nonatomic) NSString *annotationSubtitle;
@property(strong, nonatomic) PFPostCompletion completion;
@end
