//
//  LoginModel.m
//  Dwell
//
//  Created by Ranosys on 14/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "LoginModel.h"
#import "ConnectionManager.h"

@implementation LoginModel

#pragma mark - Shared instance
+ (instancetype)sharedUser {
    
    static LoginModel *loginUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginUser = [[[self class] alloc] init];
    });
    
    return loginUser;
}
#pragma mark - end

#pragma mark - Login user
- (void)loginUserOnSuccess:(void (^)(LoginModel *))success onfailure:(void (^)(id))failure {
    
    [[ConnectionManager sharedManager] loginUser:self onSuccess:^(LoginModel *userData) {
        if (success) {
            DLog(@"check");
            [UserDefaultManager setValue:userData.userEmailId key:@"userEmailId"];
            [UserDefaultManager setValue:userData.entryId key:@"entryId"];
            //Call save device token
            if ((nil!=[UserDefaultManager getValue:@"deviceToken"])&&(NULL!=[UserDefaultManager getValue:@"deviceToken"])) {
                [self saveDeviceToken:^(LoginModel *userData) {
                    [UserDefaultManager setValue:userData.userEmailId key:@"userEmailId"];
                    [UserDefaultManager setValue:userData.entryId key:@"entryId"];
                    success (userData);
                } onfailure:^(id error) {
                    success(error);
                }];
            }
            else {
                success (userData);
            }
        }
    } onFailure:^(id error) {
        failure(error);
    }];
}
#pragma mark - end

#pragma mark - Save device token
- (void)saveDeviceToken:(void (^)(LoginModel *))success onfailure:(void (^)(id))failure {
    
    [[ConnectionManager sharedManager] sendDevcieToken:self onSuccess:^(LoginModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(id error) {
        failure(error);
    }] ;
}
#pragma mark - end
@end
