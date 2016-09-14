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

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"Dashboard";
    //Add background image
    [super addBackgroungImage:@"Dashboard"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
