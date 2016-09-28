//
//  MaintenanceService.m
//  Dwell
//
//  Created by Sumit on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MaintenanceService.h"
#import "MainatenanceModel.h"
@implementation MaintenanceService

#pragma mark - Get maintenance list data
- (void)getMaintenanceList:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    NSString *parameters = [NSString stringWithFormat:@"SELECT rm.[JobStatus] as status,rm.[RoomSpaceMaintenanceID], rm.[Description] as title, rm.[Cause], rm.[DateReported], rm.[CompleteDate], rsm.[Description] AS sub_category , rsc.[Description] AS main_category, rm.[OccupantPresent] , rm.[RepairDescription] as description, rm.[OccupantPresentReason] as comments FROM [Booking] as bk LEFT JOIN [RoomSpaceMaintenance] as rm ON bk.[RoomSpaceID] = rm.[RoomSpaceID] LEFT JOIN [RoomSpaceMaintenanceItem] AS rsm ON rsm.[RoomSpaceMaintenanceItemID] = rm.[RoomSpaceMaintenanceItemID] LEFT JOIN [RoomSpaceMaintenanceCategory] AS rsc ON rsc.[RoomSpaceMaintenanceCategoryID] = rm.[RoomSpaceMaintenanceCategoryID] WHERE bk.[EntryID] = '%@'",[UserDefaultManager getValue:@"entryId"]];
    DLog(@"request dict %@",parameters);
    [super post:parameters onSuccess:success onFailure:failure];
}

- (void)cancelService:(void (^)(id))success onFailure:(void (^)(id))failure{
    
    NSString *parameters = [NSString stringWithFormat:@"<RoomSpaceMaintenance><JobStatus>Closed by student</JobStatus></RoomSpaceMaintenance>"];
    DLog(@"request dict %@",parameters);
    [super xmlPost:[NSString stringWithFormat:@"update/RoomSpaceMaintenance/%@",[UserDefaultManager getValue:@"maintainId"]] parameters:parameters onSuccess:success onFailure:failure];
}



- (void)getCategoryService:(void (^)(id))success onFailure:(void (^)(id))failure{
    
    NSString *parameters = @"SELECT [RoomSpaceMaintenanceCategoryID], [Description], [Comments] FROM [RoomSpaceMaintenanceCategory]";
    DLog(@"request dict %@",parameters);
    [super post:parameters onSuccess:success onFailure:failure];
}

- (void)getSubCategoryService:(void (^)(id))success onFailure:(void (^)(id))failure{
    
    NSString *parameters = [NSString stringWithFormat:@"SELECT [RoomSpaceMaintenanceItemID], [RoomSpaceMaintenanceCategoryID], [Comments], [Description] FROM [RoomSpaceMaintenanceItem] WHERE [RoomSpaceMaintenanceCategoryID] = %@",[UserDefaultManager getValue:@"categoryId"] ];
    DLog(@"request dict %@",parameters);
    [super post:parameters onSuccess:success onFailure:failure];
}

- (void)saveJob:(MainatenanceModel *)data onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure
{
    NSString *parameters = [NSString stringWithFormat:@"<RoomSpaceMaintenance><RoomSpaceID>%@</RoomSpaceID> <RoomSpaceMaintenanceCategoryID> %@</RoomSpaceMaintenanceCategoryID><RoomSpaceMaintenanceItemID>%@</RoomSpaceMaintenanceItemID> <PriorityID>0</PriorityID><RoomSpaceClosedID>0</RoomSpaceClosedID><ContactID>0</ContactID><DateReported>%@</DateReported><ReportedByName>%@</ReportedByName><Occupant_EntryID>%@</Occupant_EntryID><OccupantEntryName>%@</OccupantEntryName><OccupantPresent>%@</OccupantPresent><OccupantPresentReason>%@</OccupantPresentReason><JobSent>0</JobSent><Description>%@</Description><Cause>%@</Cause><Charge>0</Charge><ViewOnWeb>1</ViewOnWeb></RoomSpaceMaintenance>",[UserDefaultManager getValue:@"RoomSpaceID"],data.maintenenceId,data.subcategoryId,@"date",[UserDefaultManager getValue:@"userName"],[UserDefaultManager getValue:@"entryId"],[UserDefaultManager getValue:@"userName"],data.isPresent,data.commetns,data.detail,data.cause];
    DLog(@"request dict %@",parameters);
    [super xmlPost:[NSString stringWithFormat:@"create/roomspacemaintenance"] parameters:parameters onSuccess:success onFailure:failure];

}
@end

