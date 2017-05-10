//
//  MaintenanceService.h
//  Dwell
//
//  Created by Sumit on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "BaseService.h"
@class MaintenanceModel;
@interface MaintenanceService : BaseService

//Get maintenance list data
- (void)getMaintenanceList:(void (^)(id))success onFailure:(void (^)(id))failure;

//Get room space id
- (void)getRoomSpaceId:(void (^)(id))success onFailure:(void (^)(id))failure;

//Cancel service
- (void)cancelService:(void (^)(id))success onFailure:(void (^)(id))failure;

//Category service
- (void)getCategoryService:(void (^)(id))success onFailure:(void (^)(id))failure;

//Subcategory service
- (void)getSubCategoryService:(void (^)(id))success onFailure:(void (^)(id))failure;

//Get priorties
- (void)getPrioritiesService:(void (^)(id))success onFailure:(void (^)(id))failure;

//Save job
- (void)saveJob:(MaintenanceModel *)data onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure;

//Fetch selected maintenance id
- (void)getMaintenanceImageId:(NSString *)selectedMaintenanceId success:(void (^)(id))success onFailure:(void (^)(id))failure;
@end
