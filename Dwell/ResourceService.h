//
//  ResourceService.h
//  Dwell
//
//  Created by Ranosys on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"
@class ResourceModel;

@interface ResourceService : BaseService

//Get resource list with data
- (void)getResourceList:(void (^)(id))success onFailure:(void (^)(id))failure;
//Get resource type list
- (void)getResourceType:(void (^)(id))success onFailure:(void (^)(id))failure;
@end
