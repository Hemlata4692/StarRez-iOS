//
//  MainatenanceModel.m
//  Dwell
//
//  Created by Sumit on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MainatenanceModel.h"
#import "ConnectionManager.h"
@implementation MainatenanceModel
@synthesize title;
@synthesize detail;
@synthesize completedDate;
@synthesize status;

#pragma mark - Shared instance
+ (instancetype)sharedUser {
    
    static MainatenanceModel *ainatenanceData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ainatenanceData = [[[self class] alloc] init];
    });
    
    return ainatenanceData;
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
            __block MainatenanceModel *tempModel=[MainatenanceModel new];
            tempModel.title=[maintenanceData valueForKeyPath:@"entry.content.Record.sub_category"];
            tempModel.detail=[maintenanceData valueForKeyPath:@"entry.content.Record.title"];
            NSDate *dateCompleted = [dateFormatter dateFromString:[[[UserDefaultManager GMTToSytemDateTimeFormat:[maintenanceData valueForKeyPath:@"entry.content.Record.CompleteDate"]] componentsSeparatedByString:@"T"] objectAtIndex:0]];
            NSDate *dateReported = [dateFormatter dateFromString:[[[UserDefaultManager GMTToSytemDateTimeFormat:[maintenanceData valueForKeyPath:@"entry.content.Record.DateReported"]] componentsSeparatedByString:@"T"] objectAtIndex:0]];
            [dateFormatter setDateFormat:@"dd MMM, yy"];
            tempModel.completedDate=[dateFormatter stringFromDate:dateCompleted];
            tempModel.reportedDate=[dateFormatter stringFromDate:dateReported];
            tempModel.status=[maintenanceData valueForKeyPath:@"entry.content.Record.status"];
            tempModel.category=[maintenanceData valueForKeyPath:@"entry.content.Record.main_category"];
            tempModel.cause=[maintenanceData valueForKeyPath:@"entry.content.Record.Cause"];
            tempModel.commetns=[maintenanceData valueForKeyPath:@"entry.content.Record.comments"];
            tempModel.maintenenceId=[maintenanceData valueForKeyPath:@"entry.content.Record.RoomSpaceMaintenanceID"];
            
            if (!tempModel.status) {
                tempModel.status=@"Submitted";
            }
            [dataArray addObject:tempModel];
        }
        else {
            for (int i=0; i<[[maintenanceData objectForKey:@"entry"] count]; i++) {
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                __block MainatenanceModel *tempModel=[MainatenanceModel new];
                tempModel.title=[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.sub_category"];
                tempModel.detail=[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.title"];
                NSDate *dateCompleted = [dateFormatter dateFromString:[[[UserDefaultManager GMTToSytemDateTimeFormat:[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.CompleteDate"]] componentsSeparatedByString:@"T"] objectAtIndex:0]];
                NSDate *dateReported = [dateFormatter dateFromString:[[[UserDefaultManager GMTToSytemDateTimeFormat:[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.DateReported"]] componentsSeparatedByString:@"T"] objectAtIndex:0]];
                [dateFormatter setDateFormat:@"dd MMM, yy"];
                tempModel.completedDate=[dateFormatter stringFromDate:dateCompleted];
                tempModel.reportedDate=[dateFormatter stringFromDate:dateReported];
                tempModel.status=[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.status"];
                tempModel.category=[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.main_category"];
                tempModel.cause=[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.Cause"];
                tempModel.commetns=[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.comments"];
                tempModel.maintenenceId=[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.RoomSpaceMaintenanceID"];
                
                if (!tempModel.status) {
                    tempModel.status=@"Submitted";
                }
                [dataArray addObject:tempModel];
            }
        }
        success(dataArray);
    } onFailure:^(id error) {
        failure(error);
    }];
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
        for (int i=0; i<[[maintenanceData objectForKey:@"entry"] count]; i++) {
            
            __block MainatenanceModel *tempModel=[MainatenanceModel new];
            tempModel.title=[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.Description"];
            tempModel.maintenenceId=[[[maintenanceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.RoomSpaceMaintenanceCategoryID"];
            
            if (!tempModel.status) {
                tempModel.status=@"Submitted";
            }
           [dataArray addObject:tempModel];
        }
        
        success(dataArray);
    } onFailure:^(id error) {
        failure(error);
    }];
}
@end
