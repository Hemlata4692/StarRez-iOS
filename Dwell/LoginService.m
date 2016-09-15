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
                       @"DeviceTokan" : [UserDefaultManager getValue:@"deviceToken"],
                       @"DeviceType" : @"IOS",
                       @"AppVersion" : [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ]};
        
            } @catch (NSException *exception) {
        
        NSLog(@"exception is %@",exception);
    }
    DLog(@"request dict device token code %@",parameters);
    [super jsonPost:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Login user
- (void)loginUser:(LoginModel *)userLogin onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    NSString *parameters = [NSString stringWithFormat:@"SELECT en.[entryid], en.[PinNumber], ed.[Email], en.[NameLast], en.[NameFirst], en.[NameTitle] FROM [Entry] AS en LEFT JOIN [EntryAddress] AS ed ON ed.[entryid] = en.[entryid] WHERE ed.[Email] = '%@' AND en.[PinNumber] = '%@'",userLogin.userEmailId,userLogin.password];
    DLog(@"request dict %@",parameters);
    [super post:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end

@end
