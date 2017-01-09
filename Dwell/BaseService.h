//
//  Webservice.h
//  MyTake
//
//  Created by Hema on 11/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseService : NSObject

//Post method for other services
- (void)post:(NSString *)parameters onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure;

//Post method for save device token services
- (void)jsonPost:(NSString *)path parameters:(NSDictionary *)parameters onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure;

//Post method for XML services
- (void)xmlPost:(NSString *)path parameters:(NSString *)parameters onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure;
@end
