//
//  AvailableResourceViewController.h
//  Dwell
//
//  Created by Ranosys on 26/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResourceModel.h"

@interface AvailableResourceViewController : GlobalBackViewController

@property(nonatomic,strong)NSMutableArray *availableResourceData;
@property(nonatomic,strong)NSString *selectedFromDataTime;
@property(nonatomic,strong)NSString *selectedToDataTime;
@property(nonatomic,strong)NSString *selectedResourceId;
@end
