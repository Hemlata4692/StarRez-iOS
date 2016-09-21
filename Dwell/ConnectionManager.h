//
//  ConnectionManager.h
//  MyTake
//
//  Created by Hema on 11/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LoginModel;
@class ParcelModel;
@class MainatenanceModel;
@interface ConnectionManager : NSObject

+ (instancetype)sharedManager;

//Login user
- (void)loginUser:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(id))failure;

//Save device token
- (void)sendDevcieToken:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(id))failure;

//Parcel list with detail
- (void)getParcelList:(ParcelModel *)parcelData onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure;

//Get Maintenance listing
- (void)getMaintenancelList:(MainatenanceModel *)userData onSuccess:(void (^)(MainatenanceModel *userData))success onFailure:(void (^)(id))failure;
@end
