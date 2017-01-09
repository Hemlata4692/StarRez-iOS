//
//  AppDelegate.h
//  Dwell
//
//  Created by Ranosys on 13/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//


#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>
//Variable declaration
@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) UINavigationController *navigationController;
@property (retain, nonatomic) UINavigationController *currentNavigationController;
@property(nonatomic,retain)NSMutableDictionary *notificationDict;
//Method declaration
//Global loader
- (void)showIndicator:(UIColor*)spinnerColor;
- (void)stopIndicator;

//Push notification method
- (void)registerDeviceForNotification;
- (void)unrigisterForNotification;
@end

