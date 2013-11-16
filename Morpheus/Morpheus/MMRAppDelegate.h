//
//  MMRAppDelegate.h
//  Morpheus
//
//  Created by Comyar Zaheri on 11/15/13.
//  Copyright (c) 2013 Comyar Zaheri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMRAlarmViewController;
@class MMRSettingsViewController;

@interface MMRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController        *tabBarController;
@property (strong, nonatomic) MMRAlarmViewController    *mainViewController;
@property (strong, nonatomic) MMRSettingsViewController *settingsViewController;


@end
