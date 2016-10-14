//
//  ResourceModel.h
//  Dwell
//
//  Created by Ranosys on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceModel : NSObject

@property (strong, nonatomic) NSString *resourceId;
@property (strong, nonatomic) NSString *resourceTitle;
@property (strong, nonatomic) NSString *resourceType;
@property (strong, nonatomic) NSString *resourceFromDate;
@property (strong, nonatomic) NSString *resourceToDate;
@property (strong, nonatomic) NSString *resourceStatusId;
@property (strong, nonatomic) NSString *resourceStatus;
@property (strong, nonatomic) NSString *resourceDescription;
@property (strong, nonatomic) NSString *resourceComment;
//Resource type objects declaration
@property (strong, nonatomic) NSString *resourceTypeDescription;
@property (strong, nonatomic) NSString *resourceTypeMaxHour;
@property (strong, nonatomic) NSString *resourceTypeMinHour;
@property (strong, nonatomic) NSString *resourceTypeLocationId;
//Resource location objects declaration
@property (strong, nonatomic) NSString *resourceLocationDescription;

+ (instancetype)sharedUser;
//Resource listing with detail
- (void)getResourceListOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure;
//Fetch resource type
- (void)getResourceTypeOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure;
//Get location list
- (void)getLocationListOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure;
//Get already booked resources list
- (void)getBookedResourcesOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure;
//Get all resources list
- (void)getAllResourcesOnSuccess:(NSMutableArray *)allResourceIds onSuccess:(void (^)(id))success onfailure:(void (^)(id))failure;
//Resources request service
- (void)setRequestResourceOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure;
@end
