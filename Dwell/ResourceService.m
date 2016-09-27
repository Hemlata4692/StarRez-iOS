//
//  ResourceService.m
//  Dwell
//
//  Created by Ranosys on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ResourceService.h"
#import "ResourceModel.h"

@implementation ResourceService

#pragma mark - Get resource list data
- (void)getResourceList:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    NSString *parameters = [NSString stringWithFormat:@"SELECT rb.[DateStart], rbs.[ResourceBookingStatusEnum], rb.[DateEnd], re.[Description] as resource, rbs.[Description] AS status, rt.[Description] as resource_type, rb.[Description], rb.[Comments] FROM [ResourceBooking] as rb LEFT JOIN [Resource] AS re ON re.[ResourceID] = rb.[ResourceID] LEFT JOIN [ResourceBookingStatusEnum] AS rbs ON rbs.[ResourceBookingStatusEnum] = rb.[ResourceBookingStatusEnum] LEFT JOIN [ResourceType] AS rt ON rt.[ResourceTypeID] = re.[ResourceTypeID] WHERE rb.[EntryID] = '%@' ORDER BY re.[ResourceID] DESC",[UserDefaultManager getValue:@"entryId"]];
    DLog(@"request dict %@",parameters);
    [super post:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Get resource type list
- (void)getResourceType:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    NSString *parameters = [NSString stringWithFormat:@"SELECT rt.[Description], rt.[ResourceTypeID], rt.[MinBookingHours], rt.[MaxBookingHours], bk.[RoomLocationID] FROM [Booking] as bk LEFT JOIN ResourceType as rt ON rt.RoomLocationID = bk.RoomLocationID WHERE bk.[EntryID] = '%@'",[UserDefaultManager getValue:@"entryId"]];
    DLog(@"request dict %@",parameters);
    
    [super post:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Get location according to selected resource type
- (void)getLocationList:(NSString *)locationId success:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    NSString *parameters = [NSString stringWithFormat:@"SELECT [RoomLocationID], [Description], [RoomLocationAreaID], [CategoryID], [CountryID] FROM [RoomLocation] WHERE [RoomLocationAreaID] IN ('%@')",locationId];
    DLog(@"request dict %@",parameters);
    
    [super post:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Get already booked resources list
- (void)getBookedResourcesList:(ResourceModel *)resourceModelData success:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    NSString *parameters;
//    if ((nil==resourceModelData.resourceDescription)||[resourceModelData.resourceDescription isEqualToString:@""]) {
//        parameters = [NSString stringWithFormat:@"SELECT rt.[Description], rt.[ResourceTypeID], rt.[MinBookingHours], rt.[MaxBookingHours], bk.[RoomLocationID] FROM [Booking] as bk LEFT JOIN ResourceType as rt ON rt.RoomLocationID = bk.RoomLocationID WHERE bk.[EntryID] = '%@'",[UserDefaultManager getValue:@"entryId"]];
//    }
////    else {
        parameters = [NSString stringWithFormat:@"SELECT [ResourceBookingID], [ResourceId] FROM [ResourceBooking] WHERE (([DateStart] >= '%@' AND [DateStart] <= '%@') OR ([DateEnd] >= '%@' AND [DateEnd] <= '%@'))",resourceModelData.resourceFromDate,resourceModelData.resourceFromDate,resourceModelData.resourceToDate,resourceModelData.resourceToDate];
////    }
    
//    SELECT [ResourceBookingID], [ResourceId] FROM [ResourceBooking] WHERE (([DateStart] >= "'.$post['DateStart'].'" AND [DateStart] <= "'.$post['DateEnd'].'") OR ([DateEnd] >= "'.$post['DateStart'].'" AND [DateEnd] <= "'.$post['DateEnd'].'"))';
    DLog(@"request dict %@",parameters);
    
    [super post:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Get all resources list
- (void)getAllResourcesList:(NSMutableArray *)bookedResourceIds resourceModelData:(ResourceModel *)resourceModelData success:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    NSString *parameters;
    DLog(@"%@",bookedResourceIds);
    
    if (((nil==resourceModelData.resourceDescription)||[resourceModelData.resourceDescription isEqualToString:@""])&&0==bookedResourceIds.count) {
        parameters = [NSString stringWithFormat:@"SELECT [ResourceId], [Description] FROM [Resource] WHERE [ResourceTypeID] = '%@'",resourceModelData.resourceId];
    }
    else if (((nil==resourceModelData.resourceDescription)||[resourceModelData.resourceDescription isEqualToString:@""])) {
        parameters = [NSString stringWithFormat:@"SELECT [ResourceId], [Description] FROM [Resource] WHERE [ResourceTypeID] = '%@' and ResourceID NOT IN %@",resourceModelData.resourceId,bookedResourceIds];
    }
    else if (0==bookedResourceIds.count) {
        parameters = [NSString stringWithFormat:@"SELECT [ResourceId], [Description] FROM [Resource] WHERE [ResourceTypeID] = '%@' and [Description] LIKE '%%%@%%'",resourceModelData.resourceId,resourceModelData.resourceDescription];
    }
    else {
        parameters = [NSString stringWithFormat:@"SELECT [ResourceId], [Description] FROM [Resource] WHERE [ResourceTypeID] = '%@' and ResourceID NOT IN %@ and [Description] LIKE '%%%@%%'",resourceModelData.resourceId,bookedResourceIds,resourceModelData.resourceDescription];
    }
    DLog(@"request dict %@",parameters);
    
    [super post:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end
@end
