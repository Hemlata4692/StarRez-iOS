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
#import "ParcelModel.h"
#import "ParcelService.h"
#import "ResourceModel.h"
#import "ResourceService.h"

@implementation ConnectionManager

#pragma mark - Shared instance
+ (instancetype)sharedManager {
    
    static ConnectionManager *connectionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        connectionManager = [[[self class] alloc] init];
    });
    return connectionManager;
}
#pragma mark - end

#pragma mark - Get parcel list with detail
- (void)getParcelList:(ParcelModel *)parcelData onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    ParcelService *parcelService = [[ParcelService alloc] init];
    [parcelService getParcelList:^(id response) {
        //Parse data from server response and store in datamodel
        DLog(@"%@",[response valueForKeyPath:@"entry.content.Record.EntryParcelID"]);
        if (NULL!=[response objectForKey:@"entry"]&&[[response objectForKey:@"entry"] count]!=0) {
            success(response);
        }
        else {
            NSMutableDictionary *responseDict=[NSMutableDictionary new];
            [responseDict setObject:@"0" forKey:@"success"];
            failure(responseDict);
        }
    } onFailure:^(id error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Login user
- (void)loginUser:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(id))failure {
    
    LoginService *loginService = [[LoginService alloc] init];
    [loginService loginUser:userData onSuccess:^(id response) {
        //Parse data from server response and store in datamodel
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
    } onFailure:^(id error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Send device token
- (void)sendDevcieToken:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(id))failure {
    
    LoginService *deviceToken = [[LoginService alloc] init];
    [deviceToken saveDeviceToken:userData onSuccess:^(id response) {
        //Send device token to server for push notification
        DLog(@"device token  response %@",response);
        success(userData);
    } onFailure:^(id error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Get resource list with detail
- (void)getResourceList:(ResourceModel *)resourceData onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    ResourceService *resourceService = [[ResourceService alloc] init];
    [resourceService getResourceList:^(id response) {
        //Resource data from server response and store in data model
        DLog(@"%@",[response valueForKeyPath:@"entry.content.Record.EntryParcelID"]);
        if (NULL!=[response objectForKey:@"entry"]&&[[response objectForKey:@"entry"] count]!=0) {
            success(response);
        }
        else {
            NSMutableDictionary *responseDict=[NSMutableDictionary new];
            [responseDict setObject:@"0" forKey:@"success"];
            failure(responseDict);
        }
    } onFailure:^(id error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Get resource type list
- (void)getResourceType:(ResourceModel *)resourceData onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    ResourceService *resourceService = [[ResourceService alloc] init];
    [resourceService getResourceType:^(id response) {
        //Resource data from server response and store in data model
        if (NULL!=[response objectForKey:@"entry"]&&[[response objectForKey:@"entry"] count]!=0) {
            success(response);
        }
        else {
            NSMutableDictionary *responseDict=[NSMutableDictionary new];
            [responseDict setObject:@"0" forKey:@"success"];
            failure(responseDict);
        }
    } onFailure:^(id error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Get location list
- (void)getLocationList:(ResourceModel *)resourceData onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    ResourceService *resourceService = [[ResourceService alloc] init];
    [resourceService getLocationList:^(id response) {
        //Resource data from server response and store in data model
        if (NULL!=[response objectForKey:@"entry"]&&[[response objectForKey:@"entry"] count]!=0) {
            success(response);
        }
        else {
            NSMutableDictionary *responseDict=[NSMutableDictionary new];
            [responseDict setObject:@"0" forKey:@"success"];
            failure(responseDict);
        }
    } onFailure:^(id error) {
        failure(error);
    }] ;
}
#pragma mark - end
@end
