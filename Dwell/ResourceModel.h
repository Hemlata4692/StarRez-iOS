//
//  ResourceModel.h
//  Dwell
//
//  Created by Ranosys on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceModel : NSObject

@property (strong, nonatomic) NSString *resourceTitle;
@property (strong, nonatomic) NSString *resourceType;
@property (strong, nonatomic) NSString *resourceFromDate;
@property (strong, nonatomic) NSString *resourceToDate;
@property (strong, nonatomic) NSString *resourceStatusId;
@property (strong, nonatomic) NSString *resourceStatus;
@property (strong, nonatomic) NSString *resourceDescription;
@property (strong, nonatomic) NSString *resourceComment;

+ (instancetype)sharedUser;
//Resource listing with detail
- (void)getResourceListOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure;
//Fetch resource type
- (void)getResourceTypeOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure;
@end
