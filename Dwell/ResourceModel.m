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
            if ([[resourceData objectForKey:@"entry"] isKindOfClass:[NSDictionary class]]) {
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                __block ResourceModel *tempModel=[ResourceModel new];
                tempModel.resourceTitle=[resourceData valueForKeyPath:@"entry.content.Record.resource"];
                tempModel.resourceType=[resourceData valueForKeyPath:@"entry.content.Record.resource_type"];
                NSDate *fromDate = [dateFormatter dateFromString:[[[resourceData valueForKeyPath:@"entry.content.Record.DateStart"] componentsSeparatedByString:@"T"] objectAtIndex:0]];
                NSDate *toDate = [dateFormatter dateFromString:[[[resourceData valueForKeyPath:@"entry.content.Record.DateEnd"] componentsSeparatedByString:@"T"] objectAtIndex:0]];
                [dateFormatter setDateFormat:@"dd MMM, yy"];
                tempModel.resourceFromDate=[dateFormatter stringFromDate:fromDate];
                tempModel.resourceToDate=[dateFormatter stringFromDate:toDate];
                tempModel.resourceStatus=[resourceData valueForKeyPath:@"entry.content.Record.status"];
                tempModel.resourceStatusId=[resourceData valueForKeyPath:@"entry.content.Record.ResourceBookingStatusEnum"];
                tempModel.resourceDescription=[resourceData valueForKeyPath:@"entry.content.Record.Description"];
                tempModel.resourceComment=[resourceData valueForKeyPath:@"entry.content.Record.Comments"];
                [dataArray addObject:tempModel];
            }
            else{
            for (int i=0; i<[[resourceData objectForKey:@"entry"] count]; i++) {
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                __block ResourceModel *tempModel=[ResourceModel new];
                tempModel.resourceTitle=[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.resource"];
                tempModel.resourceType=[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.resource_type"];
                NSDate *fromDate = [dateFormatter dateFromString:[[[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.DateStart"] componentsSeparatedByString:@"T"] objectAtIndex:0]];
                NSDate *toDate = [dateFormatter dateFromString:[[[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.DateEnd"] componentsSeparatedByString:@"T"] objectAtIndex:0]];
                [dateFormatter setDateFormat:@"dd MMM, yy"];
                tempModel.resourceFromDate=[dateFormatter stringFromDate:fromDate];
                tempModel.resourceToDate=[dateFormatter stringFromDate:toDate];
                tempModel.resourceStatus=[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.status"];
                tempModel.resourceStatusId=[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.ResourceBookingStatusEnum"];
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
            if ([[resourceData objectForKey:@"entry"] isKindOfClass:[NSDictionary class]]) {
                __block ResourceModel *tempModel=[ResourceModel new];
                tempModel.resourceTypeDescription=[resourceData valueForKeyPath:@"entry.content.Record.Description"];
                tempModel.resourceTypeMaxHour=[resourceData valueForKeyPath:@"entry.content.Record.MaxBookingHours"];
                tempModel.resourceTypeMinHour=[resourceData valueForKeyPath:@"entry.content.Record.MinBookingHours"];
                tempModel.resourceTypeLocationId=[resourceData valueForKeyPath:@"entry.content.Record.RoomLocationID"];
                [dataArray addObject:tempModel];
            }
            else {
                for (int i=0; i<[[resourceData objectForKey:@"entry"] count]; i++) {
                    __block ResourceModel *tempModel=[ResourceModel new];
                    tempModel.resourceTypeDescription=[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.Description"];
                    tempModel.resourceTypeMaxHour=[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.MaxBookingHours"];
                    tempModel.resourceTypeMinHour=[[[resourceData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.MinBookingHours"];                    
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
            if ([[resourceLocationData objectForKey:@"entry"] isKindOfClass:[NSDictionary class]]) {
                __block ResourceModel *tempModel=[ResourceModel new];
                tempModel.resourceLocationDescription=[resourceLocationData valueForKeyPath:@"entry.content.Record.Description"];
                [dataArray addObject:tempModel];
            }
            else {
                for (int i=0; i<[[resourceLocationData objectForKey:@"entry"] count]; i++) {
                    __block ResourceModel *tempModel=[ResourceModel new];
                    tempModel.resourceTypeDescription=[[[resourceLocationData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.Description"];
                    tempModel.resourceTypeMaxHour=[[[resourceLocationData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.MaxBookingHours"];
                    tempModel.resourceTypeMinHour=[[[resourceLocationData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.MinBookingHours"];
                    //                tempModel.resourceTitle=[[[resourceLocationData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.Description"];
                    
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
