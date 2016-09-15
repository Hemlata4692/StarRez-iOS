//
//  Webservice.h
//  MyTake
//
//  Created by Hema on 11/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseService : NSObject

- (void)post:(NSString *)parameters onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure;
- (void)jsonPost:(NSDictionary *)parameters onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure;
@end
