//
//  AppDelegate.h
//  Dwell
//
//  Created by Ranosys on 13/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

@interface AppDelegate : UIResponder <UIApplicationDelegate>
//Variable declaration
@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) UINavigationController *navigationController;

//Method declaration
//Global loader
- (void)showIndicator:(UIColor*)spinnerColor;
- (void)stopIndicator;

//Push notification method
- (void)registerDeviceForNotification;
- (void)unrigisterForNotification;
@end

