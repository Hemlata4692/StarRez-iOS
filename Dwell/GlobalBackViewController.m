//
//  GlobalBackViewController.m
//  Dwell
//
//  Created by Shiven on 15/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "GlobalBackViewController.h"
#import "UIImage+deviceSpecificMedia.h"
#import "Internet.h"

@interface GlobalBackViewController () {
    
 UIBarButtonItem *barButton,*barButton1;
}

@end

@implementation GlobalBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftBarButtonWithImage:[UIImage imageNamed:@"back_btn"]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Add back button
- (void)addLeftBarButtonWithImage:(UIImage *)buttonImage {
    
    //Navigation bar button for adding global back button for all the sub screens.
    CGRect framing1 = CGRectMake(0, 0, 25, 25);
    UIButton *button = [[UIButton alloc] initWithFrame:framing1];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    barButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems=[NSArray arrayWithObjects:barButton, nil];
}

//Back button action
- (void)backButtonAction :(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - end

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

//Check internet connectivity
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
