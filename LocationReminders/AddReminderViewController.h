//
//  AddReminderViewController.h
//  LocationReminders
//
//  Created by Jake Romer on 5/2/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

@import UIKit;
@import CoreLocation;

@interface AddReminderViewController : UIViewController
@property(nonatomic) CLLocationCoordinate2D coordinate;
@property(strong, nonatomic) NSString *annotationTitle;
@property(strong, nonatomic) NSString *annotationSubtitle;
@end
