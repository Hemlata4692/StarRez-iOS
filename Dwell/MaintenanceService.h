//
//  MaintenanceService.h
//  Dwell
//
//  Created by Sumit on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "BaseService.h"

@interface MaintenanceService : BaseService

//Get maintenance list data
- (void)getMaintenanceList:(void (^)(id))success onFailure:(void (^)(id))failure;
@end
