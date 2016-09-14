///
//  ConnectionManager.m
//  Demo
//
//  Created by shiv vaishnav on 22/06/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//



#import "ConnectionManager.h"
#import "LoginModel.h"
#import "LoginService.h"

@implementation ConnectionManager

#pragma mark - Shared instance
+ (instancetype)sharedManager{
    static ConnectionManager *connectionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        connectionManager = [[[self class] alloc] init];
    });
    return connectionManager;
}
#pragma mark - end

#pragma mark - Login user
- (void)loginUser:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(id))failure {
    LoginService *loginService = [[LoginService alloc] init];
    [loginService loginUser:userData onSuccess:^(id response) {
        //parse data from server response and store in datamodel
        
        DLog(@"%@",[response valueForKeyPath:@"entry.content.Record.EntryID"]);
        if (NULL!=[response valueForKeyPath:@"entry.content.Record.EntryID"]) {
            userData.entryId=[response valueForKeyPath:@"entry.content.Record.EntryID"];
            success(userData);
        }
        else {
            NSMutableDictionary *responseDict=[NSMutableDictionary new];
            [responseDict setObject:@"0" forKey:@"success"];
            failure(responseDict);
        }
        success(userData);
    } onFailure:^(id error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Send device token
- (void)sendDevcieToken:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(id))failure{
    LoginService *deviceToken = [[LoginService alloc] init];
    [deviceToken saveDeviceToken:userData onSuccess:^(id response) {
        //send device token to server for push notification
        NSLog(@"device token  response %@",response);
        success(userData);
    } onFailure:^(id error) {
        failure(error);
    }] ;
}
#pragma mark - end
@end
