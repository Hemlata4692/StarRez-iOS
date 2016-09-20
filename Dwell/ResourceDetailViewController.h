//
//  ResourceDetailViewController.h
//  Dwell
//
//  Created by Ranosys on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ResourceModel.h"
@interface ResourceDetailViewController : GlobalBackViewController

//Get resource data model from parcel listing
@property(nonatomic,strong)ResourceModel *resourceDetailData;
@end
