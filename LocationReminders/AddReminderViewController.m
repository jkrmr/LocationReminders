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
}

- (IBAction)doneButtonTapped:(UIBarButtonItem *)sender {

  [self.navigationController popViewControllerAnimated:YES];
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
