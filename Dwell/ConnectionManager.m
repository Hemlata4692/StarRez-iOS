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
#import "MaintenanceModel.h"
#import "MaintenanceService.h"
#import "ResourceService.h"
#import "ResourceModel.h"

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

#pragma mark - Login user
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

#pragma mark - Maintenance services
- (void)getMaintenancelList:(MaintenanceModel *)userData onSuccess:(void (^)(MaintenanceModel *userData))success onFailure:(void (^)(id))failure {
    
    MaintenanceService *mainatenanceService = [[MaintenanceService alloc] init];
    [mainatenanceService getMaintenanceList:^(id response) {
        //Parse data from server response and store in datamodel
        DLog(@"%@",[response valueForKeyPath:@"entry.content.Record.Cause"]);
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

#pragma mark - Check provided room space id is exist
- (void)checkRoomSpaceId:(MaintenanceModel *)userData onSuccess:(void (^)(MaintenanceModel *userData))success onFailure:(void (^)(id))failure {
    
    MaintenanceService *mainatenanceService = [[MaintenanceService alloc] init];
    [mainatenanceService getRoomSpaceId:^(id response) {
        //Parse data from server response and store in datamodel
        DLog(@"%@",[response valueForKeyPath:@"entry.content.Record.RoomSpaceID"]);
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

#pragma mark - Select maintenance id services
- (void)getMaintenanceIdList:(NSString *)selectedId onSuccess:(void (^)(MaintenanceModel *userData))success onFailure:(void (^)(id))failure {
    
    MaintenanceService *mainatenanceService = [[MaintenanceService alloc] init];
    [mainatenanceService getMaintenanceImageId:selectedId success:^(id response) {
        //Parse data from server response and store in datamodel
        success(response);
    } onFailure:^(id error) {
        failure(error);
    }] ;
}

//Cancel service
- (void)cancelServiceOnSuccess:(MaintenanceModel *)userData onSuccess:(void (^)(MaintenanceModel *userData))success onFailure:(void (^)(id))failure {

    MaintenanceService *mainatenanceService = [[MaintenanceService alloc] init];
    [mainatenanceService cancelService:^(id response) {
        //Parse data from server response and store in datamodel
        DLog(@"%@",[response valueForKeyPath:@"entry.content.Record.Cause"]);
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

//Get category listing
- (void)getCategoryOnSuccess:(MaintenanceModel *)userData onSuccess:(void (^)(MaintenanceModel *userData))success onFailure:(void (^)(id))failure {
    
    MaintenanceService *mainatenanceService = [[MaintenanceService alloc] init];
    [mainatenanceService getCategoryService:^(id response) {
        //Parse data from server response and store in datamodel
        DLog(@"%@",[response valueForKeyPath:@"entry.content.Record.Cause"]);
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

//Get Subcategory service
- (void)getSubCategoryOnSuccess:(MaintenanceModel *)userData onSuccess:(void (^)(MaintenanceModel *userData))success onFailure:(void (^)(id))failure {
    
    MaintenanceService *mainatenanceService = [[MaintenanceService alloc] init];
    [mainatenanceService getSubCategoryService:^(id response) {
        //Parse data from server response and store in datamodel
        DLog(@"%@",[response valueForKeyPath:@"entry.content.Record.Cause"]);
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

//Save new maintenance job
- (void)saveMaintenanceJob:(MaintenanceModel *)userData onSuccess:(void (^)(MaintenanceModel *userData))success onFailure:(void (^)(id))failure {
    
    MaintenanceService *mainatenanceService = [[MaintenanceService alloc] init];
    [mainatenanceService saveJob:userData onSuccess:^(id response) {
        //Parse data from server response and store in datamodel
        DLog(@"%@",[response valueForKeyPath:@"entry.content.Record.RoomSpaceMaintenance"]);
        if (NULL!=[response valueForKeyPath:@"entry.content.RoomSpaceMaintenance"]) {
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
            userData.userName=[NSString stringWithFormat:@"%@ %@",[response valueForKeyPath:@"entry.content.Record.NameFirst"],[response valueForKeyPath:@"entry.content.Record.NameLast"]];
//            [UserDefaultManager setValue:[NSString stringWithFormat:@"%@ %@ %@",[response valueForKeyPath:@"entry.content.Record.NameTitle"],[response valueForKeyPath:@"entry.content.Record.NameFirst"],[response valueForKeyPath:@"entry.content.Record.NameLast"]] key:@"userName"];
            [UserDefaultManager setValue:[NSString stringWithFormat:@"Hello %@ %@",[response valueForKeyPath:@"entry.content.Record.NameFirst"],[response valueForKeyPath:@"entry.content.Record.NameLast"]] key:@"userName"];
            [UserDefaultManager setValue:[response valueForKeyPath:@"entry.content.Record.RoomLocationID"] key:@"RoomLocationID"];
            [UserDefaultManager setValue:[response valueForKeyPath:@"entry.content.Record.RoomSpaceID"] key:@"RoomSpaceID"];
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
#pragma mark - end.

#pragma mark - Logout service
- (void)logoutService:(void (^)(LoginModel *userData))success onFailure:(void (^)(id))failure {
    
    LoginService *logoutObj = [[LoginService alloc] init];
    [logoutObj logoutService:^(id response) {
        DLog(@"logout  response %@",response);
        success(response);
    } onFailure:^(id error) {
        failure(error);
    }] ;
}
#pragma mark - end.

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
    [resourceService getLocationList:resourceData.resourceId success:^(id response) {
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

#pragma mark - Get already booked resources list
- (void)getBookedResources:(ResourceModel *)resourceData onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    ResourceService *resourceService = [[ResourceService alloc] init];
    [resourceService getBookedResourcesList:resourceData success:^(id response) {
        //Resource data from server response and store in data model
        success(response);
    } onFailure:^(id error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Get get all resources
- (void)getAllResources:(NSMutableArray *)bookedResourceIds resourceData:(ResourceModel *)resourceData onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    ResourceService *resourceService = [[ResourceService alloc] init];
    [resourceService getAllResourcesList:bookedResourceIds resourceModelData:resourceData success:^(id response) {
        success(response);
    } onFailure:^(id error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Resources request service
- (void)setRequestResource:(ResourceModel *)resourceData onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    ResourceService *resourceService = [[ResourceService alloc] init];
    [resourceService setRequestResourceService:resourceData success:^(id response) {
        //Resource data from server response and store in data model
        DLog(@"%@",[response valueForKeyPath:@"entry.content.ResourceBooking.ResourceBookingID"]);
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
