//
//  GlobalBackViewController.h
//  Dwell
//
//  Created by Shiven on 15/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlobalBackViewController : UIViewController

//Add back button to all the sub screens of app.
- (void)addLeftBarButtonWithImage:(UIImage *)buttonImage;

//Add different backgroung image
- (void)addBackgroungImage : (NSString *)imageName;
@end
