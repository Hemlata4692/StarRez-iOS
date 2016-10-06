//
//  LoginService.m
//  MyTake
//
//  Created by Hema on 11/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "LoginService.h"
#import "LoginModel.h"

@implementation LoginService

#pragma mark - Save device token
- (void)saveDeviceToken:(LoginModel *)userData onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    NSDictionary *parameters;
    @try {
        parameters = @{@"EnteryId" : userData.entryId,
                       @"DeviceToken" : [UserDefaultManager getValue:@"deviceToken"],
                       @"DeviceType" : @"IOS",
                       @"Name" : userData.userName,
                       @"EmailId" : userData.userEmailId,
                       @"AppVersion" : [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ]};
        
            } @catch (NSException *exception) {
        
        DLog(@"exception is %@",exception);
    }
    DLog(@"request dict device token code %@",parameters);
    [super jsonPost:@"SaveUser" parameters:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Logout
- (void)logoutService:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    NSDictionary *parameters;
    @try {
        parameters = @{@"EnteryId" : [UserDefaultManager getValue:@"entryId"]};
        
    } @catch (NSException *exception) {
        
        DLog(@"exception is %@",exception);
    }
    DLog(@"request dict device token code %@",parameters);
    [super jsonPost:@"logout" parameters:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Login user
- (void)loginUser:(LoginModel *)userLogin onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    NSString *parameters = [NSString stringWithFormat:@"SELECT en.[entryid], en.[PinNumber], ed.[Email], en.[NameLast], en.[NameFirst], en.[NameTitle], bk.[RoomSpaceID] FROM [Entry] AS en LEFT JOIN [EntryAddress] AS ed ON ed.[entryid] = en.[entryid] LEFT JOIN [Booking] as bk ON bk.[entryid] = en.[entryid] WHERE ed.[Email] ='%@' AND en.[PinNumber] = '%@'",userLogin.userEmailId,userLogin.password];
    DLog(@"request dict %@",parameters);
    [super post:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end
@end
