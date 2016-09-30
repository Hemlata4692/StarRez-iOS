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
    
    NSString *parameters = [NSString stringWithFormat:@"SELECT rb.[DateModified], rb.[DateStart], rbs.[ResourceBookingStatusEnum], rb.[DateEnd], re.[Description] as resource, rbs.[Description] AS status, rt.[Description] as resource_type, rb.[Description], rb.[Comments] FROM [ResourceBooking] as rb LEFT JOIN [Resource] AS re ON re.[ResourceID] = rb.[ResourceID] LEFT JOIN [ResourceBookingStatusEnum] AS rbs ON rbs.[ResourceBookingStatusEnum] = rb.[ResourceBookingStatusEnum] LEFT JOIN [ResourceType] AS rt ON rt.[ResourceTypeID] = re.[ResourceTypeID] WHERE rb.[EntryID] = '%@' ORDER BY rb.[DateModified] DESC",[UserDefaultManager getValue:@"entryId"]];
    DLog(@"request dict %@",parameters);
    [super post:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Get resource type list
- (void)getResourceType:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    NSString *parameters = [NSString stringWithFormat:@"SELECT rt.[Description], rt.[ResourceTypeID], rt.[MinBookingHours], rt.[MaxBookingHours], rl.[RoomLocationAreaID] FROM [Booking] as bk LEFT JOIN ResourceType as rt ON rt.RoomLocationID = bk.RoomLocationID LEFT JOIN [RoomLocation] as rl ON rl.[RoomLocationID] = bk.[RoomLocationID]  WHERE bk.[EntryID] = '%@'",[UserDefaultManager getValue:@"entryId"]];
    DLog(@"request dict %@",parameters);
    
    [super post:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Get location according to selected resource type
- (void)getLocationList:(NSString *)locationId success:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    NSString *parameters = [NSString stringWithFormat:@"SELECT [Description], [RoomLocationID] FROM [RoomLocation] WHERE [RoomLocationAreaID] = '%@'",locationId];
    DLog(@"request dict %@",parameters);
    
    [super post:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Get already booked resources list
- (void)getBookedResourcesList:(ResourceModel *)resourceModelData success:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    NSString *parameters;
    parameters = [NSString stringWithFormat:@"SELECT [ResourceBookingID], [ResourceId] FROM [ResourceBooking] WHERE (([DateStart] >= '%@' AND [DateStart] <= '%@') OR ([DateEnd] >= '%@' AND [DateEnd] <= '%@'))",resourceModelData.resourceFromDate,resourceModelData.resourceFromDate,resourceModelData.resourceToDate,resourceModelData.resourceToDate];
    DLog(@"request dict %@",parameters);
    
    [super post:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Get all resources list
- (void)getAllResourcesList:(NSMutableArray *)bookedResourceIds resourceModelData:(ResourceModel *)resourceModelData success:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    NSString *parameters;
    DLog(@"%@",bookedResourceIds);
    if (((nil==resourceModelData.resourceDescription)||[resourceModelData.resourceDescription isEqualToString:@""])&&(0==bookedResourceIds.count)) {    //if resourceDescription and bookResourceIds both do not exist
        parameters = [NSString stringWithFormat:@"SELECT rs.[ResourceId], rs.[Description], rs.[ResourceTypeID] FROM [Resource] as rs LEFT JOIN [ResourceType] as rt ON rt.[ResourceTypeID] =  rs.[ResourceTypeID] WHERE rs.[ResourceTypeID] = '%@' AND rt.[RoomLocationID] = '%@'",resourceModelData.resourceId,resourceModelData.resourceTypeLocationId];
    }
    else if (((nil==resourceModelData.resourceDescription)||[resourceModelData.resourceDescription isEqualToString:@""])) {     //if resourceDescription does not exist but bookResourceIds exist
        parameters = [NSString stringWithFormat:@"SELECT rs.[ResourceId], rs.[Description], rs.[ResourceTypeID] FROM [Resource] as rs LEFT JOIN [ResourceType] as rt ON rt.[ResourceTypeID] =  rs.[ResourceTypeID] WHERE rs.[ResourceTypeID] = '%@' AND rt.[RoomLocationID] = '%@' and ResourceID NOT IN %@",resourceModelData.resourceId,resourceModelData.resourceTypeLocationId,bookedResourceIds];
    }
    else if (0==bookedResourceIds.count) {  //if resourceDescription exists but bookResourceIds don't exist
        parameters = [NSString stringWithFormat:@"SELECT rs.[ResourceId], rs.[Description], rs.[ResourceTypeID] FROM [Resource] as rs LEFT JOIN [ResourceType] as rt ON rt.[ResourceTypeID] =  rs.[ResourceTypeID] WHERE rs.[ResourceTypeID] = '%@' AND rt.[RoomLocationID] = '%@' and [Description] LIKE '%%%@%%'",resourceModelData.resourceId,resourceModelData.resourceTypeLocationId,resourceModelData.resourceDescription];
    }
    else {  //if resourceDescription and bookResourceIds both exist
        parameters = [NSString stringWithFormat:@"SELECT rs.[ResourceId], rs.[Description], rs.[ResourceTypeID] FROM [Resource] as rs LEFT JOIN [ResourceType] as rt ON rt.[ResourceTypeID] =  rs.[ResourceTypeID] WHERE rs.[ResourceTypeID] = '%@' AND rt.[RoomLocationID] = '%@' and ResourceID NOT IN %@ and [Description] LIKE '%%%@%%'",resourceModelData.resourceId,resourceModelData.resourceTypeLocationId,bookedResourceIds,resourceModelData.resourceDescription];
    }
    DLog(@"request dict %@",parameters);
    
    [super post:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Resources request service
- (void)setRequestResourceService:(ResourceModel *)resourceModelData success:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    NSString *parameters = [NSString stringWithFormat:@"<ResourceBooking><EntryID>%@</EntryID><ResourceID>%@</ResourceID><BookingID>0</BookingID><ResourceBookingStatusEnum>0</ResourceBookingStatusEnum><ProgramID>0</ProgramID><DateStart>%@</DateStart><DateEnd>%@</DateEnd><AutoAssigned>0</AutoAssigned></ResourceBooking>",[UserDefaultManager getValue:@"entryId"],resourceModelData.resourceId,resourceModelData.resourceFromDate,resourceModelData.resourceToDate];
    DLog(@"request dict %@",parameters);
    [super xmlPost:@"create/ResourceBooking" parameters:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end
@end
