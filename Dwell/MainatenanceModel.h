//
//  MainatenanceModel.h
//  Dwell
//
//  Created by Sumit on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainatenanceModel : NSObject
@property(retain,nonatomic)NSString *maintenenceId;
@property(retain,nonatomic)NSString *title;
@property(retain,nonatomic)NSString *completedDate;
@property(retain,nonatomic)NSString *reportedDate;
@property(retain,nonatomic)NSString *detail;
@property(retain,nonatomic)NSString *status;
@property(retain,nonatomic)NSString *cause;
@property(retain,nonatomic)NSString *commetns;
@property(retain,nonatomic)NSString *category;
@property(retain,nonatomic)NSString *subcategory;
@property(retain,nonatomic)NSString *subcategoryId;
+ (instancetype)sharedUser;
//Maintenance listing
- (void)getMaintenanceListOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure;

//Cancel service
- (void)cancelServiceOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure;

//Get category
- (void)getCategoryListOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure;

//Get subcategory
- (void)getSubCategoryListOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure;

@end
