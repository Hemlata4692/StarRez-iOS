//
//  ParcelModel.m
//  Dwell
//
//  Created by Ranosys on 15/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ParcelModel.h"
#import "ConnectionManager.h"

@implementation ParcelModel

#pragma mark - Shared instance
+ (instancetype)sharedUser {
    
    static ParcelModel *parselData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        parselData = [[[self class] alloc] init];
    });
    
    return parselData;
}
#pragma mark - end

#pragma mark - Parcel list with detail
- (void)getParcelListOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure {
    
    [[ConnectionManager sharedManager] getParcelList:self onSuccess:^(id parcelData) {
        if (NULL!=[parcelData objectForKey:@"entry"]&&[[parcelData objectForKey:@"entry"] count]!=0) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            NSMutableArray *dataArray = [NSMutableArray new];
            for (int i=0; i<[[parcelData objectForKey:@"entry"] count]; i++) {
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                __block ParcelModel *tempModel=[ParcelModel new];
                tempModel.parcelTitle=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.Description"];
                tempModel.parcelType=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.parcel_type_val"];
//                NSString*A=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.ReceiptDate"];
                
                DLog(@"%@",[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.ReceiptDate"]);
                NSDate *reciptDate = [dateFormatter dateFromString:[[[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.ReceiptDate"] componentsSeparatedByString:@"T"] objectAtIndex:0]];
                 NSDate *issuedDate = [dateFormatter dateFromString:[[[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.IssueDate"] componentsSeparatedByString:@"T"] objectAtIndex:0]];
                [dateFormatter setDateFormat:@"dd MMM, yy"];
                DLog(@"%@",reciptDate);
                DLog(@"%@",issuedDate);
                tempModel.parcelReceiptDate=[dateFormatter stringFromDate:reciptDate];
                tempModel.parcelShippingType=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.shipping_type_val"];
                tempModel.parcelIssueDate=[dateFormatter stringFromDate:issuedDate];
                tempModel.parcelStatus=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.status_desc"];
                tempModel.parcelForwardingAddress=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.address_val"];
                tempModel.parcelTrackingNo=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.TrackingNumber"];
                tempModel.parcelComment=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.Description"];
                 tempModel.parcelID=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.EntryParcelID"];
                [dataArray addObject:tempModel];
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
