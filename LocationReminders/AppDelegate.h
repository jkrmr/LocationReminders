//
//  AppDelegate.h
//  LocationReminders
//
//  Created by Jake Romer on 5/1/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

@import CoreData;
@import UIKit;
@import ParseUI;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) UIWindow *window;
@property(readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end
