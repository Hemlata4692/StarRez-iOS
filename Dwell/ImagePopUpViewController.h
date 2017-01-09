//
//  ImagePopUpViewController.h
//  Dwell
//
//  Created by Ranosys on 13/10/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePopUpViewController : UIViewController

@property (nonatomic,retain)NSMutableArray *imageArray;
@property (nonatomic,assign)int currentSelectedImage;
@property (strong, nonatomic) IBOutlet UIImageView *maintenanceDetailImage;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@end
