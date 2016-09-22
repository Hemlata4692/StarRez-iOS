//
//  DashboardViewController.m
//  Dwell
//
//  Created by Shiven on 14/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "DashboardViewController.h"

@interface DashboardViewController ()
@end

@implementation DashboardViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[myDelegate.notificationDict objectForKey:@"isNotification"] isEqualToString:@"Yes"]) {
        [myDelegate.notificationDict setObject:@"No" forKey:@"isNotification"];
        UIViewController * profileView = [self.storyboard instantiateViewControllerWithIdentifier:[myDelegate.notificationDict objectForKey:@"toScreen"]];
        [self.navigationController pushViewController:profileView animated:NO];
        return;
    }
    self.navigationItem.title = @"Dashboard";
    //Add background image
    [super addBackgroungImage:@"Dashboard"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
