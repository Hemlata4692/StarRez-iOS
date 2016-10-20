//
//  MainatenanceModel.m
//  Dwell
//
//  Created by Sumit on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MaintenanceModel.h"
#import "ConnectionManager.h"
@implementation MaintenanceModel
@synthesize title;
@synthesize detail;
@synthesize completedDate;
@synthesize status;

#pragma mark - Shared instance
+ (instancetype)sharedUser {
    
    static MaintenanceModel *maintenanceData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        maintenanceData = [[[self class] alloc] init];
    });
    
    return maintenanceData;
}
#pragma mark - end

- (void)getMaintenanceListOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure{
    
    [[ConnectionManager sharedManager] getMaintenancelList:self onSuccess:^(id maintenanceData) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        NSMutableArray *dataArray = [NSMutableArray new];
        //If single entry exist then use as dictionay
        if ([[maintenanceData objectForKey:@"entry"] isKindOfClass:[NSDictionary class]]) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            __block MaintenanceModel *tempModel=[MaintenanceModel new];
            if ([maintenanceData valueForKeyPath:@"entry.content.Record.sub_category"]) {
                tempModel.title=[self setNAValue:[maintenanceData valueForKeyPath:@"entry.content.Record.sub_category"]];
            }
            else {
                tempModel.title=@"No title available";
            }
            tempModel.title=[self setNAValue:[maintenanceData valueForKeyPath:@"entry.content.Record.sub_category"]];
            tempModel.detail=[self setNAValue:[maintenanceData valueForKeyPath:@"entry.content.Record.title"]];
            NSDate *dateCompleted = [dateFormatter dateFromString:[[[UserDefaultManager GMTToSytemDateTimeFormat:[maintenanceData valueForKeyPath:@"entry.content.Record.CompleteDate"]] componentsSeparatedByString:@"T"] objectAtIndex:0]];
            NSDate *dateReported = [dateFormatter dateFromString:[[[UserDefaultManager GMTToSytemDateTimeFormat:[maintenanceData valueForKeyPath:@"entry.content.Record.DateReported"]] componentsSeparatedByString:@"T"] objectAtIndex:0]];
            [dateFormatter setDateFormat:@"dd MMM, yy"];
            tempModel.completedDate=[dateFormatter stringFromDate:dateCompleted];
            tempModel.reportedDate=[dateFormatter stringFromDate:dateReported];
            tempModel.status=[maintenanceData valueForKeyPath:@"entry.content.Record.status"];
            tempModel.category=[maintenanceData valueForKeyPath:@"entry.content.Record.main_category"];
            tempModel.cause=[maintenanceData valueForKeyPath:@"entry.content.Record.Cause"];
            tempModel.commetns=[maintenanceData valueForKeyPath:@"entry.content.Record.comments"];
            tempModel.maintenanceId=[maintenanceData valueForKeyPath:@"entry.content.Record.RoomSpaceMaintenanceID"];
            if (!tempModel.status && tempModel.completedDate) {
                tempModel.status=@"Closed";
            }
            else if (!tempModel.status) {
                tempModel.status=@"Job Submitted";
            }
            [dataArray addObject:tempModel];
        }
        else {
            for (int i=0; i<[[maintenanceData objectForKey:@"entry"] count]; i++) {
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                __block MaintenanceModel *tempModel=[MaintenanceModel new];
                if ([[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.sub_category"]) {
                    tempModel.title=[self setNAValue:[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.sub_category"]];
                }
                else {
                    tempModel.title=@"No title available";
                }
                tempModel.detail=[self setNAValue:[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.title"]];
                NSDate *dateCompleted = [dateFormatter dateFromString:[[[UserDefaultManager GMTToSytemDateTimeFormat:[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.CompleteDate"]] componentsSeparatedByString:@"T"] objectAtIndex:0]];
                NSDate *dateReported = [dateFormatter dateFromString:[[[UserDefaultManager GMTToSytemDateTimeFormat:[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.DateReported"]] componentsSeparatedByString:@"T"] objectAtIndex:0]];
                [dateFormatter setDateFormat:@"dd MMM, yy"];
                tempModel.completedDate=[dateFormatter stringFromDate:dateCompleted];
                tempModel.reportedDate=[dateFormatter stringFromDate:dateReported];
                tempModel.status=[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.status"];
                tempModel.category=[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.main_category"];
                tempModel.cause=[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.Cause"];
                tempModel.commetns=[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.comments"];
                tempModel.maintenanceId=[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.RoomSpaceMaintenanceID"];
                if (!tempModel.status && tempModel.completedDate) {
                    tempModel.status=@"Closed";
                }
                else if (!tempModel.status) {
                    tempModel.status=@"Job Submitted";
                }
                [dataArray addObject:tempModel];
            }
        }
        success(dataArray);
    } onFailure:^(id error) {
        failure(error);
    }];
}

#pragma mark - Check provided room space id is exist
- (void)checkRoomSpaceOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure {
    
    [[ConnectionManager sharedManager] checkRoomSpaceId:self onSuccess:^(id maintenanceData) {
                
        NSMutableArray *dataArray = [NSMutableArray new];
        success(dataArray);
    } onFailure:^(id error) {
        failure(error);
    }];
}

//Set NA value is model data is nil
- (NSString *)setNAValue:(NSString*)modelDataString {

    if (modelDataString) {
        return modelDataString;
    }
    else {
        return @"NA";
    }
}

- (void)cancelServiceOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure{
    
    [[ConnectionManager sharedManager] cancelServiceOnSuccess:self onSuccess:^(id maintenanceData) {

        success(maintenanceData);
    } onFailure:^(id error) {
        failure(error);
    }];
}

- (void)getCategoryListOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure;{
    
    [[ConnectionManager sharedManager] getCategoryOnSuccess:self onSuccess:^(id maintenanceData) {
        
        NSMutableArray *dataArray = [NSMutableArray new];
        if ([[maintenanceData objectForKey:@"entry"] isKindOfClass:[NSDictionary class]]) {
            __block MaintenanceModel *tempModel=[MaintenanceModel new];
            tempModel.title=[maintenanceData valueForKeyPath:@"entry.content.Record.Description"];
            tempModel.maintenanceId=[maintenanceData valueForKeyPath:@"entry.content.Record.RoomSpaceMaintenanceCategoryID"];
            
            if (![tempModel.title isEqualToString:@"(Please Select Category)"]) {
                
                [dataArray addObject:tempModel];
            }
        }
        else {
            for (int i=0; i<[[maintenanceData objectForKey:@"entry"] count]; i++) {
                
                __block MaintenanceModel *tempModel=[MaintenanceModel new];
                tempModel.title=[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.Description"];
                tempModel.maintenanceId=[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.RoomSpaceMaintenanceCategoryID"];
                
                if (![tempModel.title isEqualToString:@"(Please Select Category)"]) {
                    
                    [dataArray addObject:tempModel];
                }
            }
        }
        success(dataArray);
    } onFailure:^(id error) {
        failure(error);
    }];
}

- (void)getSubCategoryListOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure {
    
    [[ConnectionManager sharedManager] getSubCategoryOnSuccess:self onSuccess:^(id maintenanceData) {
        
        NSMutableArray *dataArray = [NSMutableArray new];
        if ([[maintenanceData objectForKey:@"entry"] isKindOfClass:[NSDictionary class]]) {
            
            __block MaintenanceModel *tempModel=[MaintenanceModel new];
            tempModel.subcategory=[maintenanceData valueForKeyPath:@"entry.content.Record.Description"];
            tempModel.subcategoryId=[maintenanceData valueForKeyPath:@"entry.content.Record.RoomSpaceMaintenanceItemID"];
            
            if (![tempModel.title isEqualToString:@"(Please Select Category)"]) {
                
                [dataArray addObject:tempModel];
            }
        }
        else {
            for (int i=0; i<[[maintenanceData objectForKey:@"entry"] count]; i++) {
                
                __block MaintenanceModel *tempModel=[MaintenanceModel new];
                tempModel.subcategory=[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.Description"];
                tempModel.subcategoryId=[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.RoomSpaceMaintenanceItemID"];
                
                if (![tempModel.title isEqualToString:@"(Please Select Category)"]) {
                    
                    [dataArray addObject:tempModel];
                }
            }
        }
        success(dataArray);
    } onFailure:^(id error) {
        failure(error);
    }];
}

- (void)saveMainatenanceJobOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure{
    
    [[ConnectionManager sharedManager] saveMaintenanceJob:self onSuccess:^(id parcelData) {
        
        success(parcelData);
    } onFailure:^(id error) {
        failure(error);
    }];
}

//Fetch selected maintenance image ids
- (void)getMaintenanceImageIdOnSuccess:(NSString*)selectedId success:(void (^)(id))success onfailure:(void (^)(id))failure {
    
    [[ConnectionManager sharedManager] getMaintenanceIdList:selectedId onSuccess:^(id maintenanceData) {
                
        NSMutableArray *dataArray = [NSMutableArray new];
        //If single entry exist then use as dictionay
        if ([[maintenanceData objectForKey:@"entry"] isKindOfClass:[NSDictionary class]]) {
            [dataArray addObject:[maintenanceData valueForKeyPath:@"entry.content.Record.RecordAttachmentID"]];
        }
        else if ([[maintenanceData objectForKey:@"entry"] isKindOfClass:[NSMutableArray class]]){
            for (int i=0; i<[[maintenanceData objectForKey:@"entry"] count]; i++) {
                [dataArray addObject:[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.RecordAttachmentID"]];
            }
        }
        success(dataArray);
    } onFailure:^(id error) {
        failure(error);
    }];
}
@end
