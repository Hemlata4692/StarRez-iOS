//
//  SideMenuViewController.h
//  Dwell
//
//  Created by Shiven on 14/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//


@interface SideMenuViewController : UIViewController

//Add menu icon in all screens of side bar
- (void)addLeftBarButtonWithImage:(UIImage *)buttonImage;

//Add different backgroung image
- (void)addBackgroungImage : (NSString *)imageName;

//Check internet connectivity
- (bool)checkInternetConnection;
@end
