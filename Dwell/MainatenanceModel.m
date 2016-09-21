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
    
    [[ConnectionManager sharedManager] getMaintenancelList:self onSuccess:^(id parcelData) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        NSMutableArray *dataArray = [NSMutableArray new];
        for (int i=0; i<[[parcelData objectForKey:@"entry"] count]; i++) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            __block MainatenanceModel *tempModel=[MainatenanceModel new];
            tempModel.title=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.sub_category"];
            tempModel.detail=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.title"];
            NSDate *dateCompleted = [dateFormatter dateFromString:[[[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.CompleteDate"] componentsSeparatedByString:@"T"] objectAtIndex:0]];
                        NSDate *dateReported = [dateFormatter dateFromString:[[[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.DateReported"] componentsSeparatedByString:@"T"] objectAtIndex:0]];
                        [dateFormatter setDateFormat:@"dd MMM, yy"];
            tempModel.completedDate=[dateFormatter stringFromDate:dateCompleted];
            //            tempModel.parcelShippingType=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.shipping_type_val"];
                        tempModel.reportedDate=[dateFormatter stringFromDate:dateReported];
                        tempModel.status=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.status"];
            
            if (!tempModel.status) {
                tempModel.status=@"Submitted";
            }
            
            //            tempModel.parcelStatusId=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.ParcelStatusEnum"];
            //            tempModel.parcelForwardingAddress=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.address_val"];
            //            tempModel.parcelTrackingNo=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.TrackingNumber"];
            //            tempModel.parcelComment=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.Comments"];
            //            tempModel.parcelID=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.EntryParcelID"];
            [dataArray addObject:tempModel];
           
            
        }
         success(dataArray);
    } onFailure:^(id error) {
        failure(error);
    }];
}
@end
