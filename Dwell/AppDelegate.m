//
//  AppDelegate.m
//  Dwell
//
//  Created by Ranosys on 13/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "AppDelegate.h"
#import "MMMaterialDesignSpinner.h"

@interface AppDelegate () {
    
    UIView *loaderView;
    UIImageView *spinnerBackground;
}
@property (strong, nonatomic) MMMaterialDesignSpinner *spinnerView;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:58.0/255.0 blue:78.0/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeueLTCom-Lt" size:19.0], NSFontAttributeName, nil]];
    application.statusBarHidden = NO;
    return YES;
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
- (void)showIndicator
{
    spinnerBackground=[[UIImageView alloc]initWithFrame:CGRectMake(3, 3, 50, 50)];
    spinnerBackground.backgroundColor=[UIColor whiteColor];
    spinnerBackground.layer.cornerRadius=25.0f;
    spinnerBackground.clipsToBounds=YES;
    spinnerBackground.center = CGPointMake(CGRectGetMidX(self.window.bounds), CGRectGetMidY(self.window.bounds));
    loaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height)];
    loaderView.backgroundColor=[UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:0.3];
    [loaderView addSubview:spinnerBackground];
    self.spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.spinnerView.tintColor = [UIColor colorWithRed:144.0/255.0 green:187.0/255.0 blue:62.0/255.0 alpha:1.0];
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
@end
