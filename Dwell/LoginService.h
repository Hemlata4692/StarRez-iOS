//
//  LoginService.m
//  MyTake
//
//  Created by Hema on 11/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "BaseService.h"
@class LoginModel;

@interface LoginService : BaseService

//Login user
- (void)loginUser:(LoginModel *)userLogin onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure;

//Save device token
- (void)saveDeviceToken:(LoginModel *)userData onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure;

//Logout
- (void)logoutService:(void (^)(id))success onFailure:(void (^)(id))failure;
@end
