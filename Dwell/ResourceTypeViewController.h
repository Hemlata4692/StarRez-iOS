//
//  ResourceTypeViewController.h
//  Dwell
//
//  Created by Ranosys on 24/01/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResourceTypeViewController : GlobalBackViewController

@property(nonatomic,strong)NSMutableArray *resourceNameListArray;
@property(nonatomic,strong)NSString *resourceNameFromDate;
@property(nonatomic,strong)NSString *resourceNameToDate;
@end
