//
//  ResourceService.m
//  Dwell
//
//  Created by Ranosys on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ResourceService.h"

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
//    DLog(@"request dict %@",parameters);
//    NSString *parameters = [NSString stringWithFormat:@"SELECT [RoomLocationID], [Description], [RoomLocationAreaID], [CategoryID], [CountryID] FROM [RoomLocation] WHERE [RoomLocationAreaID] IN ('1')"];
//    DLog(@"request dict %@",parameters);
//    NSString *parameters = [NSString stringWithFormat:@"SELECT rt.[Description], rt.[ResourceTypeID], rt.[MinBookingHours], rt.[MaxBookingHours] FROM ResourceType as rt"];
    DLog(@"request dict %@",parameters);
    
    [super post:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Get location according to selected resource type
- (void)getLocationList:(NSString *)locationId success:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    NSString *parameters = [NSString stringWithFormat:@"SELECT [RoomLocationID], [Description], [RoomLocationAreaID], [CategoryID], [CountryID] FROM [RoomLocation] WHERE [RoomLocationAreaID] IN ('%@')",locationId];
    //    DLog(@"request dict %@",parameters);
    //    NSString *parameters = [NSString stringWithFormat:@"SELECT [RoomLocationID], [Description], [RoomLocationAreaID], [CategoryID], [CountryID] FROM [RoomLocation] WHERE [RoomLocationAreaID] IN ('1')"];
    //    DLog(@"request dict %@",parameters);
    //    NSString *parameters = [NSString stringWithFormat:@"SELECT rt.[Description], rt.[ResourceTypeID], rt.[MinBookingHours], rt.[MaxBookingHours] FROM ResourceType as rt"];
    DLog(@"request dict %@",parameters);
    
    [super post:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end
@end
