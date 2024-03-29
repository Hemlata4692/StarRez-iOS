//
//  ConnectionManager.h
//  MyTake
//
//  Created by Hema on 11/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LoginModel;
@class ParcelModel;
@class ResourceModel;
@class MaintenanceModel;
@interface ConnectionManager : NSObject

+ (instancetype)sharedManager;

//Login user
- (void)loginUser:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(id))failure;

//Save device token
- (void)sendDevcieToken:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(id))failure;

//Parcel list with detail
- (void)getParcelList:(ParcelModel *)parcelData onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure;

//Get Maintenance listing
- (void)getMaintenancelList:(MaintenanceModel *)userData onSuccess:(void (^)(MaintenanceModel *userData))success onFailure:(void (^)(id))failure;

//Check provided room space id is exist
- (void)checkRoomSpaceId:(MaintenanceModel *)userData onSuccess:(void (^)(MaintenanceModel *userData))success onFailure:(void (^)(id))failure;

//Canscel service
- (void)cancelServiceOnSuccess:(MaintenanceModel *)userData onSuccess:(void (^)(MaintenanceModel *userData))success onFailure:(void (^)(id))failure;

//Get Category service
- (void)getCategoryOnSuccess:(MaintenanceModel *)userData onSuccess:(void (^)(MaintenanceModel *userData))success onFailure:(void (^)(id))failure;

//Get Subcategory service
- (void)getSubCategoryOnSuccess:(MaintenanceModel *)userData onSuccess:(void (^)(MaintenanceModel *userData))success onFailure:(void (^)(id))failure;

//Save maintenance job
- (void)saveMaintenanceJob:(MaintenanceModel *)userData onSuccess:(void (^)(MaintenanceModel *userData))success onFailure:(void (^)(id))failure;

//Resource list with detail
- (void)getResourceList:(ResourceModel *)resourceData onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure;
//Resource type list
- (void)getResourceType:(ResourceModel *)resourceData onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure;
//Get location list
- (void)getLocationList:(ResourceModel *)resourceData onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure;
//Get already booked resources list
- (void)getBookedResources:(ResourceModel *)resourceData onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure;
//Get get all resources
- (void)getAllResources:(NSMutableArray *)bookedResourceIds resourceData:(ResourceModel *)resourceData onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure;
//Resources request service
- (void)setRequestResource:(ResourceModel *)resourceData onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure;
//Select maintenance id
- (void)getMaintenanceIdList:(NSString *)selectedId onSuccess:(void (^)(MaintenanceModel *userData))success onFailure:(void (^)(id))failure;

//Logout service
- (void)logoutService:(void (^)(LoginModel *userData))success onFailure:(void (^)(id))failure;

//Get selected resource detail
- (void)getSelectedResourceDetail:(ResourceModel *)resourceData onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure;
@end
