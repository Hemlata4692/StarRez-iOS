//
//  SideMenuViewController.m
//  Dwell
//
//  Created by Shiven on 14/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "SideMenuViewController.h"
#import "SWRevealViewController.h"
#import "UIImage+deviceSpecificMedia.h"
#import "Internet.h"

@interface SideMenuViewController () {
    UIBarButtonItem *barButton;
}
@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];    
    [self setTransparentNavigtionBar];
    [self addLeftBarButtonWithImage:[UIImage imageNamed:@"menu.png"]];
    
   //Add pan gesture for going back to main screens by clicking on menu button.
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    revealController.panGestureRecognizer.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Make the navigation bar transparent and show only bar items.
- (void)setTransparentNavigtionBar {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}

//Add side menu along with action in all the screens of sidebar.
- (void)addLeftBarButtonWithImage:(UIImage *)buttonImage {
    
    CGRect frameimg = CGRectMake(0, 0, buttonImage.size.width+5, buttonImage.size.height+5);
    UIButton *button = [[UIButton alloc] initWithFrame:frameimg];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    barButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [button addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

//Add different background image for all sub classes at run time.
- (void)addBackgroungImage:(NSString *)imageName {
    
    //Set background image on uiview
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:imageName] drawInRect:self.view.bounds];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[image imageForDeviceWithName:imageName]]];
    backgroundImage.contentMode = UIViewContentModeScaleAspectFit;
    backgroundImage.frame = self.view.frame;
    [self.view insertSubview:backgroundImage atIndex:0];
}

- (bool)checkInternetConnection {
    
    Internet *internet=[[Internet alloc] init];
    if (![internet start]) {
        return true;
    }
    else {
        return false;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
