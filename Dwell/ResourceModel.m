//
//  ResourceModel.m
//  Dwell
//
//  Created by Ranosys on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ResourceModel.h"
#import "ConnectionManager.h"

@implementation ResourceModel

#pragma mark - Shared instance
+ (instancetype)sharedUser {
    
    static ResourceModel *resourceData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        resourceData = [[[self class] alloc] init];
    });
    
    return resourceData;
}
#pragma mark - end

#pragma mark - Resources list with detail
- (void)getResourceListOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure {
    
    [[ConnectionManager sharedManager] getResourceList:self onSuccess:^(id resourceData) {
        if (NULL!=[resourceData objectForKey:@"entry"]&&[[resourceData objectForKey:@"entry"] count]!=0) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            NSMutableArray *dataArray = [NSMutableArray new];
            //If single entry then resourceData is dictionary type
            if ([[resourceData objectForKey:@"entry"] isKindOfClass:[NSDictionary class]]) {
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                __block ResourceModel *tempModel=[ResourceModel new];
                tempModel.resourceTitle=[resourceData valueForKeyPath:@"entry.content.Record.resource"];
                tempModel.resourceType=[resourceData valueForKeyPath:@"entry.content.Record.resource_type"];
                
                
                //Convert date/time in system date/time
                NSString *dateFromTempString=[UserDefaultManager GMTToSytemDateTimeFormat:[resourceData valueForKeyPath:@"entry.content.Record.DateStart"]];
                NSString *dateToTempString=[UserDefaultManager GMTToSytemDateTimeFormat:[resourceData valueForKeyPath:@"entry.content.Record.DateEnd"]];
                //Get date from system date
                NSDate *fromDate = [dateFormatter dateFromString:[[dateFromTempString componentsSeparatedByString:@"T"] objectAtIndex:0]];
                NSDate *toDate = [dateFormatter dateFromString:[[dateToTempString componentsSeparatedByString:@"T"] objectAtIndex:0]];
                //Get time from system time
                [dateFormatter setDateFormat:@"HH:mm:ss"];
                NSDate *fromTime = [dateFormatter dateFromString:[[dateFromTempString componentsSeparatedByString:@"T"] objectAtIndex:1]];
                NSDate *totime = [dateFormatter dateFromString:[[dateToTempString componentsSeparatedByString:@"T"] objectAtIndex:1]];
                //Convert system date to own date format
                [dateFormatter setDateFormat:@"dd MMM,yy"];
                tempModel.resourceFromDate=[dateFormatter stringFromDate:fromDate];
                tempModel.resourceToDate=[dateFormatter stringFromDate:toDate];
                //Convert system time to own time format
                [dateFormatter setDateFormat:@"HH:mm"];
                tempModel.resourceFromTime=[dateFormatter stringFromDate:fromTime];
                tempModel.resourceToTime=[dateFormatter stringFromDate:totime];
                
                tempModel.resourceStatus=[resourceData valueForKeyPath:@"entry.content.Record.status"];
                tempModel.resourceStatusId=[resourceData valueForKeyPath:@"entry.content.Record.ResourceBookingStatusEnum"];
                if ([tempModel.resourceStatusId isEqualToString:@"1"]) {
                    tempModel.resourceStatus=@"Collected";
                }
                tempModel.resourceDescription=[resourceData valueForKeyPath:@"entry.content.Record.Description"];
                tempModel.resourceComment=[resourceData valueForKeyPath:@"entry.content.Record.Comments"];
                [dataArray addObject:tempModel];
            }
            else {   //If multiple entry then resourceData is array type
                for (int i=0; i<[[resourceData objectForKey:@"entry"] count]; i++) {
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                    __block ResourceModel *tempModel=[ResourceModel new];
                    tempModel.resourceTitle=[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.resource"];
                    tempModel.resourceType=[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.resource_type"];
                    //Convert date/time in system date/time
                    NSString *dateFromTempString=[UserDefaultManager GMTToSytemDateTimeFormat:[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.DateStart"]];
                    NSString *dateToTempString=[UserDefaultManager GMTToSytemDateTimeFormat:[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.DateEnd"]];
                    //Get date from system date
                    NSDate *fromDate = [dateFormatter dateFromString:[[dateFromTempString componentsSeparatedByString:@"T"] objectAtIndex:0]];
                    NSDate *toDate = [dateFormatter dateFromString:[[dateToTempString componentsSeparatedByString:@"T"] objectAtIndex:0]];
                    //Get time from system time
                    [dateFormatter setDateFormat:@"HH:mm:ss"];
                    NSDate *fromTime = [dateFormatter dateFromString:[[dateFromTempString componentsSeparatedByString:@"T"] objectAtIndex:1]];
                    NSDate *totime = [dateFormatter dateFromString:[[dateToTempString componentsSeparatedByString:@"T"] objectAtIndex:1]];
                    //Convert system date to own date format
                    [dateFormatter setDateFormat:@"dd MMM,yy"];
                    tempModel.resourceFromDate=[dateFormatter stringFromDate:fromDate];
                    tempModel.resourceToDate=[dateFormatter stringFromDate:toDate];
                    //Convert system time to own time format
                    [dateFormatter setDateFormat:@"HH:mm"];
                    tempModel.resourceFromTime=[dateFormatter stringFromDate:fromTime];
                    tempModel.resourceToTime=[dateFormatter stringFromDate:totime];
                    
                    tempModel.resourceStatus=[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.status"];
                    
                    tempModel.resourceStatusId=[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.ResourceBookingStatusEnum"];
                    if ([tempModel.resourceStatusId isEqualToString:@"1"]) {
                        tempModel.resourceStatus=@"Collected";
                    }
                    tempModel.resourceDescription=[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.Description"];
                    tempModel.resourceComment=[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.Comments"];
                    [dataArray addObject:tempModel];
                }
            }
            success(dataArray);
        }
        else {
            NSMutableDictionary *responseDict=[NSMutableDictionary new];
            [responseDict setObject:@"0" forKey:@"success"];
            failure(responseDict);
        }
    } onFailure:^(id error) {
        failure(error);
    }];
}
#pragma mark - end

#pragma mark - Resources type list
- (void)getResourceTypeOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure {
    
    [[ConnectionManager sharedManager] getResourceType:self onSuccess:^(id resourceData) {
        if (NULL!=[resourceData objectForKey:@"entry"]&&[[resourceData objectForKey:@"entry"] count]!=0) {
            
            NSMutableArray *dataArray = [NSMutableArray new];
             //If single entry then resourceData is dictionary type
            if ([[resourceData objectForKey:@"entry"] isKindOfClass:[NSDictionary class]]) {
                __block ResourceModel *tempModel=[ResourceModel new];
                tempModel.resourceTypeDescription=[resourceData valueForKeyPath:@"entry.content.Record.Description"];
                tempModel.resourceTypeMaxHour=[resourceData valueForKeyPath:@"entry.content.Record.MaxBookingHours"];
                tempModel.resourceTypeMinHour=[resourceData valueForKeyPath:@"entry.content.Record.MinBookingHours"];
                tempModel.resourceTypeLocationId=[resourceData valueForKeyPath:@"entry.content.Record.RoomLocationAreaID"];
                tempModel.resourceId=[resourceData valueForKeyPath:@"entry.content.Record.ResourceTypeID"];
                [dataArray addObject:tempModel];
            }
            else {  //If multiple entry then resourceData is array type
                for (int i=0; i<[[resourceData objectForKey:@"entry"] count]; i++) {
                    __block ResourceModel *tempModel=[ResourceModel new];
                    tempModel.resourceTypeDescription=[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.Description"];
                    tempModel.resourceTypeMaxHour=[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.MaxBookingHours"];
                    tempModel.resourceTypeMinHour=[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.MinBookingHours"];
                    tempModel.resourceTypeLocationId=[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.RoomLocationAreaID"];
                     tempModel.resourceId=[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.ResourceTypeID"];
                    [dataArray addObject:tempModel];
                }
            }
            success(dataArray);
        }
        else {
            NSMutableDictionary *responseDict=[NSMutableDictionary new];
            [responseDict setObject:@"0" forKey:@"success"];
            failure(responseDict);
        }
    } onFailure:^(id error) {
        failure(error);
    }];
}
#pragma mark - end

#pragma mark - Get location list
- (void)getLocationListOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure {
    
    [[ConnectionManager sharedManager] getLocationList:self onSuccess:^(id resourceLocationData) {
        if (NULL!=[resourceLocationData objectForKey:@"entry"]&&[[resourceLocationData objectForKey:@"entry"] count]!=0) {
            
            NSMutableArray *dataArray = [NSMutableArray new];
             //If single entry then resourceData is dictionary type
            if ([[resourceLocationData objectForKey:@"entry"] isKindOfClass:[NSDictionary class]]) {
                __block ResourceModel *tempModel=[ResourceModel new];
                tempModel.resourceLocationDescription=[resourceLocationData valueForKeyPath:@"entry.content.Record.Description"];
                tempModel.resourceTypeLocationId=[resourceLocationData valueForKeyPath:@"entry.content.Record.ResourceID"];
                [dataArray addObject:tempModel];
            }
            else {  //If multiple entry then resourceData is array type
                for (int i=0; i<[[resourceLocationData objectForKey:@"entry"] count]; i++) {
                    __block ResourceModel *tempModel=[ResourceModel new];
                    tempModel.resourceLocationDescription=[[[resourceLocationData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.Description"];
                    tempModel.resourceTypeLocationId=[[[resourceLocationData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.ResourceID"];
                    [dataArray addObject:tempModel];
                }
            }
            success(dataArray);
        }
        else {
            NSMutableDictionary *responseDict=[NSMutableDictionary new];
            [responseDict setObject:@"0" forKey:@"success"];
            failure(responseDict);
        }
    } onFailure:^(id error) {
        failure(error);
    }];
}
#pragma mark - end

#pragma mark - Get already booked resources list
- (void)getBookedResourcesOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure {
    
    [[ConnectionManager sharedManager] getBookedResources:self onSuccess:^(id resourceData) {
        if (NULL!=[resourceData objectForKey:@"entry"]&&[[resourceData objectForKey:@"entry"] count]!=0) {
            
            NSMutableArray *tempDataArray = [NSMutableArray new];
             //If single entry then resourceData is dictionary type
            if ([[resourceData objectForKey:@"entry"] isKindOfClass:[NSDictionary class]]) {
                [tempDataArray addObject:[resourceData valueForKeyPath:@"entry.content.Record.ResourceID"]];
            }
            else {  //If multiple entry then resourceData is array type
                for (int i=0; i<[[resourceData objectForKey:@"entry"] count]; i++) {
                    [tempDataArray addObject:[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.ResourceID"]];
                }
            }
            [self getAllResourcesOnSuccess:tempDataArray onSuccess:^(id resourceData) {
                DLog(@"%@",resourceData);
                    success(resourceData);
                
            } onfailure:^(id error) {
                failure(error);
            }];
        }
        else {
             NSMutableArray *tempDataArray = [NSMutableArray new];
            [self getAllResourcesOnSuccess:tempDataArray onSuccess:^(id resourceData) {
                
                success(resourceData);
            } onfailure:^(id error) {
                failure(error);
            }];
        }
    } onFailure:^(id error) {
        failure(error);
    }];
}
#pragma mark - end

#pragma mark - Get all resources list
- (void)getAllResourcesOnSuccess:(NSMutableArray *)allResourceIds onSuccess:(void (^)(id))success onfailure:(void (^)(id))failure {
    
    [[ConnectionManager sharedManager] getAllResources:allResourceIds resourceData:self onSuccess:^(id resourceData) {
        if (NULL!=[resourceData objectForKey:@"entry"]&&[[resourceData objectForKey:@"entry"] count]!=0) {
            
            NSMutableArray *dataArray = [NSMutableArray new];
             //If single entry then resourceData is dictionary type
            if ([[resourceData objectForKey:@"entry"] isKindOfClass:[NSDictionary class]]) {
                
                __block ResourceModel *tempModel=[ResourceModel new];
                tempModel.resourceId=[resourceData valueForKeyPath:@"entry.content.Record.ResourceID"];
                tempModel.resourceDescription=[resourceData valueForKeyPath:@"entry.content.Record.Description"];
                [dataArray addObject:tempModel];
            }
            else {  //If multiple entry then resourceData is array type
                for (int i=0; i<[[resourceData objectForKey:@"entry"] count]; i++) {
                    __block ResourceModel *tempModel=[ResourceModel new];
                    tempModel.resourceId=[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.ResourceID"];
                    tempModel.resourceDescription=[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.Description"];
                    [dataArray addObject:tempModel];
                }
            }
            success(dataArray);
        }
        else {
            NSMutableArray *dataArray = [NSMutableArray new];
             success(dataArray);
        }
    } onFailure:^(id error) {
        failure(error);
    }];
}
#pragma mark - end

#pragma mark - Resources request service
- (void)setRequestResourceOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure {
    
    [[ConnectionManager sharedManager] setRequestResource:self onSuccess:^(id resourceData) {
        if (NULL!=[resourceData valueForKeyPath:@"entry.content.ResourceBooking.ResourceBookingID"]) {
            NSMutableDictionary *responseDict=[NSMutableDictionary new];
            [responseDict setObject:@"1" forKey:@"success"];
            success(responseDict);
        }
        else {
            NSMutableDictionary *responseDict=[NSMutableDictionary new];
            [responseDict setObject:@"0" forKey:@"success"];
            failure(responseDict);
        }
    } onFailure:^(id error) {
        failure(error);
    }];
}
#pragma mark - end

#pragma mark - Get selected resource detail
- (void)getSelectedResourceDetailOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure {
    
    [[ConnectionManager sharedManager] getSelectedResourceDetail:self onSuccess:^(id resourceData) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        if (NULL!=[resourceData objectForKey:@"entry"]&&[[resourceData objectForKey:@"entry"] count]!=0) {
            
            NSMutableArray *dataArray = [NSMutableArray new];
            //If single entry then resourceData is dictionary type
            if ([[resourceData objectForKey:@"entry"] isKindOfClass:[NSDictionary class]]) {
                __block ResourceModel *tempModel=[ResourceModel new];
               
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];               
                
                //Convert date/time in system date/time
                NSString *dateFromTempString=[UserDefaultManager GMTToSytemDateTimeFormat:[resourceData valueForKeyPath:@"entry.content.Record.DateStart"]];
                NSString *dateToTempString=[UserDefaultManager GMTToSytemDateTimeFormat:[resourceData valueForKeyPath:@"entry.content.Record.DateEnd"]];
                //Get date from system date
                NSDate *fromDate = [dateFormatter dateFromString:[[dateFromTempString componentsSeparatedByString:@"T"] objectAtIndex:0]];
                NSDate *toDate = [dateFormatter dateFromString:[[dateToTempString componentsSeparatedByString:@"T"] objectAtIndex:0]];
                //Get time from system time
                [dateFormatter setDateFormat:@"HH:mm:ss"];
                NSDate *fromTime = [dateFormatter dateFromString:[[dateFromTempString componentsSeparatedByString:@"T"] objectAtIndex:1]];
                NSDate *totime = [dateFormatter dateFromString:[[dateToTempString componentsSeparatedByString:@"T"] objectAtIndex:1]];
                //Convert system date to own date format
                [dateFormatter setDateFormat:@"dd MMM,yy"];
                tempModel.resourceFromDate=[dateFormatter stringFromDate:fromDate];
                tempModel.resourceToDate=[dateFormatter stringFromDate:toDate];
                //Convert system time to own time format
                [dateFormatter setDateFormat:@"HH:mm"];
                tempModel.resourceFromTime=[dateFormatter stringFromDate:fromTime];
                tempModel.resourceToTime=[dateFormatter stringFromDate:totime];
                [dataArray addObject:tempModel];
            }
            else {  //If multiple entry then resourceData is array type
                for (int i=0; i<[[resourceData objectForKey:@"entry"] count]; i++) {
                    __block ResourceModel *tempModel=[ResourceModel new];
                    
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            
                    //Convert date/time in system date/time
                    NSString *dateFromTempString=[UserDefaultManager GMTToSytemDateTimeFormat:[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.DateStart"]];
                    NSString *dateToTempString=[UserDefaultManager GMTToSytemDateTimeFormat:[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.DateEnd"]];
                    //Get date from system date
                    NSDate *fromDate = [dateFormatter dateFromString:[[dateFromTempString componentsSeparatedByString:@"T"] objectAtIndex:0]];
                    NSDate *toDate = [dateFormatter dateFromString:[[dateToTempString componentsSeparatedByString:@"T"] objectAtIndex:0]];
                    //Get time from system time
                    [dateFormatter setDateFormat:@"HH:mm:ss"];
                    NSDate *fromTime = [dateFormatter dateFromString:[[dateFromTempString componentsSeparatedByString:@"T"] objectAtIndex:1]];
                    NSDate *totime = [dateFormatter dateFromString:[[dateToTempString componentsSeparatedByString:@"T"] objectAtIndex:1]];
                    //Convert system date to own date format
                    [dateFormatter setDateFormat:@"dd MMM,yy"];
                    tempModel.resourceFromDate=[dateFormatter stringFromDate:fromDate];
                    tempModel.resourceToDate=[dateFormatter stringFromDate:toDate];
                    //Convert system time to own time format
                    [dateFormatter setDateFormat:@"HH:mm"];
                    tempModel.resourceFromTime=[dateFormatter stringFromDate:fromTime];
                    tempModel.resourceToTime=[dateFormatter stringFromDate:totime];
                    [dataArray addObject:tempModel];
                }
            }
            success(dataArray);
        }
        else {
            NSMutableDictionary *responseDict=[NSMutableDictionary new];
            [responseDict setObject:@"0" forKey:@"success"];
            failure(responseDict);
        }
    } onFailure:^(id error) {
        failure(error);
    }];
}
#pragma mark - end
@end
