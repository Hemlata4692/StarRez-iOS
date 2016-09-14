//
//  SideMenuViewController.h
//  Dwell
//
//  Created by Shiven on 14/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuViewController : UIViewController

//add menu icon in all screens of side bar
- (void)addLeftBarButtonWithImage:(UIImage *)buttonImage;

//Add different backgroung image
- (void)addBackgroungImage : (NSString *)imageName;
@end
