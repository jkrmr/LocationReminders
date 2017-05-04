//
//  MKPinAnnotationView+Color.m
//  LocationReminders
//
//  Created by Jake Romer on 5/3/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

#import "MKPinAnnotationView+Color.h"

@implementation MKPinAnnotationView (Color)
+ (UIColor *)randomColor {
  int rand = (int)arc4random_uniform(3);

  switch (rand) {
  case 0:
    return [[self class] redPinColor];
  case 1:
    return [[self class] purplePinColor];
  default:
    return [[self class] greenPinColor];
  }
}
@end
