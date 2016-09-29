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
            //If single entry exist then use as dictionay
            if ([[parcelData objectForKey:@"entry"] isKindOfClass:[NSDictionary class]]) {
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                __block ParcelModel *tempModel=[ParcelModel new];
                tempModel.parcelTitle=[parcelData valueForKeyPath:@"entry.content.Record.Description"];
                tempModel.parcelType=[parcelData valueForKeyPath:@"entry.content.Record.parcel_type_val"];
                NSDate *reciptDate = [dateFormatter dateFromString:[[[UserDefaultManager GMTToSytemDateTimeFormat:[parcelData valueForKeyPath:@"entry.content.Record.ReceiptDate"]] componentsSeparatedByString:@"T"] objectAtIndex:0]];
                NSDate *issuedDate = [dateFormatter dateFromString:[[[UserDefaultManager GMTToSytemDateTimeFormat:[parcelData valueForKeyPath:@"entry.content.Record.IssueDate"]] componentsSeparatedByString:@"T"] objectAtIndex:0]];
                [dateFormatter setDateFormat:@"dd MMM, yy"];
                tempModel.parcelReceiptDate=[dateFormatter stringFromDate:reciptDate];
                tempModel.parcelShippingType=[parcelData valueForKeyPath:@"entry.content.Record.shipping_type_val"];
                tempModel.parcelIssueDate=[dateFormatter stringFromDate:issuedDate];
                tempModel.parcelStatus=[parcelData valueForKeyPath:@"entry.content.Record.status_desc"];
                tempModel.parcelStatusId=[parcelData valueForKeyPath:@"entry.content.Record.ParcelStatusEnum"];
                tempModel.parcelForwardingAddress=[parcelData valueForKeyPath:@"entry.content.Record.address_val"];
                tempModel.parcelTrackingNo=[parcelData valueForKeyPath:@"entry.content.Record.TrackingNumber"];
                tempModel.parcelComment=[parcelData valueForKeyPath:@"entry.content.Record.Comments"];
                tempModel.parcelID=[parcelData valueForKeyPath:@"entry.content.Record.EntryParcelID"];
                [dataArray addObject:tempModel];
            }
            else {
                for (int i=0; i<[[parcelData objectForKey:@"entry"] count]; i++) {
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                    __block ParcelModel *tempModel=[ParcelModel new];
                    tempModel.parcelTitle=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.Description"];
                    tempModel.parcelType=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.parcel_type_val"];
                    //               [UserDefaultManager GMTToSytemDateTimeFormat:[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.ReceiptDate"]]
                    NSDate *reciptDate = [dateFormatter dateFromString:[[[UserDefaultManager GMTToSytemDateTimeFormat:[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.ReceiptDate"]] componentsSeparatedByString:@"T"] objectAtIndex:0]];
                    NSDate *issuedDate = [dateFormatter dateFromString:[[[UserDefaultManager GMTToSytemDateTimeFormat:[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.IssueDate"]] componentsSeparatedByString:@"T"] objectAtIndex:0]];
                    [dateFormatter setDateFormat:@"dd MMM, yy"];
                    tempModel.parcelReceiptDate=[dateFormatter stringFromDate:reciptDate];
                    tempModel.parcelShippingType=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.shipping_type_val"];
                    tempModel.parcelIssueDate=[dateFormatter stringFromDate:issuedDate];
                    tempModel.parcelStatus=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.status_desc"];
                    tempModel.parcelStatusId=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.ParcelStatusEnum"];
                    tempModel.parcelForwardingAddress=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.address_val"];
                    tempModel.parcelTrackingNo=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.TrackingNumber"];
                    tempModel.parcelComment=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.Comments"];
                    tempModel.parcelID=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.EntryParcelID"];
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
