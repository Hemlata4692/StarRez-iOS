//
//  LoginModel.h
//  Dwell
//
//  Created by Ranosys on 14/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject

@property (strong, nonatomic) NSString *userEmailId;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *entryId;
@property (strong, nonatomic) NSString *userName;
+ (instancetype)sharedUser;
//Login user
- (void)loginUserOnSuccess:(void (^)(LoginModel *))success onfailure:(void (^)(id))failure;
//Save devcie token
- (void)saveDeviceToken:(void (^)(LoginModel *))success onfailure:(void (^)(id))failure;
//Logout service
- (void)logoutService:(void (^)(LoginModel *))success onfailure:(void (^)(id))failure;
@end
