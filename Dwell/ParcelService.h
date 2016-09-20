//
//  ParcelService.h
//  Dwell
//
//  Created by Ranosys on 15/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"
@class ParcelModel;

@interface ParcelService : BaseService

//Get parcel list with data
- (void)getParcelList:(void (^)(id))success onFailure:(void (^)(id))failure;
@end
