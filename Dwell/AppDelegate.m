//
//  AppDelegate.m
//  Dwell
//
//  Created by Ranosys on 13/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "AppDelegate.h"
#import "MMMaterialDesignSpinner.h"
#import "UncaughtExceptionHandler.h"
#import "LoginViewController.h"

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()<CustomAlertDelegate> {
    
    UIView *loaderView;
    CustomAlert* alertView;
    UIImageView *spinnerBackground;
}
@property (strong, nonatomic) MMMaterialDesignSpinner *spinnerView;
@end

@implementation AppDelegate
@synthesize currentNavigationController;
@synthesize notificationDict;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   //Call crashlytics method
    [self performSelector:@selector(installUncaughtExceptionHandler) withObject:nil afterDelay:0];
    //Set navigation theam
    [self setNavigationTheam];
    application.statusBarHidden = NO;//Unhide status bar
    //Set initialize navigation controller
    self.navigationController = (UINavigationController *)[self.window rootViewController];
    [self.navigationController setNavigationBarHidden:YES];
    //If user already exist then user navigate ot dashboard screen
    if (nil!=[UserDefaultManager getValue:@"userEmailId"]) {
        //If user already loged in then navigate to dashboard
        [self navigateToDashboardScreen];
    }
    
    //Initialize NSMutableDictionary variable to manage screen navigation according to push notification
    notificationDict = [NSMutableDictionary new];
    [notificationDict setObject:@"Other" forKey:@"toScreen"];
    [notificationDict setObject:@"No" forKey:@"isNotification"];
    //end
    //Accept push notification when app is not open
    application.applicationIconBadgeNumber = 0;
    NSDictionary *remoteNotifiInfo = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    if (remoteNotifiInfo) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [self application:application didReceiveRemoteNotification:remoteNotifiInfo];
    }
    return YES;
}

//Set navigation header
- (void)setNavigationTheam {

    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[Constants navigationColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont calibriNormalWithSize:23], NSFontAttributeName, nil]];
}

//Navigate to dashboard if user already loged in
- (void)navigateToDashboardScreen {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [UserDefaultManager setValue:[NSNumber numberWithInteger:0] key:@"indexpath"];
    UIViewController * objReveal = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:objReveal];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Global indicator view
//Show indicator
- (void)showIndicator:(UIColor*)spinnerColor {
    
    spinnerBackground=[[UIImageView alloc]initWithFrame:CGRectMake(3, 3, 50, 50)];
    spinnerBackground.backgroundColor=[UIColor whiteColor];
    spinnerBackground.layer.cornerRadius=25.0f;
    spinnerBackground.clipsToBounds=YES;
    spinnerBackground.center = CGPointMake(CGRectGetMidX(self.window.bounds), CGRectGetMidY(self.window.bounds));
    loaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height)];
    loaderView.backgroundColor=[UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:0.3];
    [loaderView addSubview:spinnerBackground];
    self.spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.spinnerView.tintColor = spinnerColor;
    self.spinnerView.center = CGPointMake(CGRectGetMidX(self.window.bounds), CGRectGetMidY(self.window.bounds));
    self.spinnerView.lineWidth=3.0f;
    [self.window addSubview:loaderView];
    [self.window addSubview:self.spinnerView];
    [self.spinnerView startAnimating];
}

//Stop indicator
- (void)stopIndicator {
    [loaderView removeFromSuperview];
    [self.spinnerView removeFromSuperview];
    [self.spinnerView stopAnimating];
}
#pragma mark - end

- (void)installUncaughtExceptionHandler {
    
    InstallUncaughtExceptionHandler();
}

#pragma mark - Push notification methods
//Get permission for iphone and ipad devices to receive push notifications
- (void)registerDeviceForNotification {

    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    else {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

//Get device token to register device for push notifications
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken1{
   
    NSString *token = [[deviceToken1 description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    DLog(@"content---.......................%@", token);
    [UserDefaultManager setValue:token key:@"deviceToken"];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    DLog(@"1.push notification response.............%@",userInfo);
    //If app is active then show alert other wise(app is terminated) navigate to ParcelListViewController through Dashboard
    if ((application.applicationState == UIApplicationStateActive) || (application.applicationState == UIApplicationStateBackground)) {
        alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] doneButtonText:@"OK" cancelButtonText:@""];
    }
    else {
        //Set notificationDict to navigation
        [notificationDict setObject:@"Yes" forKey:@"isNotification"];
        [notificationDict setObject:@"ParcelListViewController" forKey:@"toScreen"];
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * objReveal = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        [self.navigationController setViewControllers: [NSArray arrayWithObject: objReveal]
                                             animated: YES];
    }
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    DLog(@"did failtoRegister and testing : %@",[NSString stringWithFormat: @"Error: %@", err]);
}

#pragma mark - UNUserNotificationCenter Delegate // >= iOS 10
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    DLog(@"2.push notification response.............%@",notification.request.content.userInfo);

    alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:[[notification.request.content.userInfo objectForKey:@"aps"] objectForKey:@"alert"] doneButtonText:@"OK" cancelButtonText:@""];
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    DLog(@"3.push notification response.............%@",response.notification.request.content.userInfo);
    //Set notificationDict to navigation
    [notificationDict setObject:@"Yes" forKey:@"isNotification"];
    [notificationDict setObject:@"ParcelListViewController" forKey:@"toScreen"];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * objReveal = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [self.navigationController setViewControllers: [NSArray arrayWithObject: objReveal]
                                         animated: NO];
    completionHandler();
}
#pragma mark - End

//Unregister push notification
- (void)unrigisterForNotification {
    
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}
#pragma mark - end

#pragma mark - Custom alert delegates
- (void)customAlertDelegateAction:(CustomAlert *)customAlert option:(int)option{
    
    [alertView dismissAlertView];    
    //Set notificationDict to navigation
        [notificationDict setObject:@"Yes" forKey:@"isNotification"];
        [notificationDict setObject:@"ParcelListViewController" forKey:@"toScreen"];
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * objReveal = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        [self.navigationController setViewControllers: [NSArray arrayWithObject: objReveal]
                                             animated: NO];
}
#pragma mark - end
@end
