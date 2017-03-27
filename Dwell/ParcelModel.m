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
            //If single entry then resourceData is dictionary type
            if ([[parcelData objectForKey:@"entry"] isKindOfClass:[NSDictionary class]]) {
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                __block ParcelModel *tempModel=[ParcelModel new];
                tempModel.parcelTitle=[parcelData valueForKeyPath:@"entry.content.Record.Description"];
                tempModel.parcelType=[parcelData valueForKeyPath:@"entry.content.Record.parcel_type_val"];
                
                
                //Convert date/time in system date/time
                NSString *dateReceiptTempString=[UserDefaultManager GMTToSytemDateTimeFormat:[parcelData valueForKeyPath:@"entry.content.Record.ReceiptDate"]];
                NSString *dateIssueTempString=[UserDefaultManager GMTToSytemDateTimeFormat:[parcelData valueForKeyPath:@"entry.content.Record.IssueDate"]];
                //Get date from system date
                NSDate *reciptDate = [dateFormatter dateFromString:[[dateReceiptTempString componentsSeparatedByString:@"T"] objectAtIndex:0]];
                NSDate *issuedDate = [dateFormatter dateFromString:[[dateIssueTempString componentsSeparatedByString:@"T"] objectAtIndex:0]];
                //Get time from system time
                [dateFormatter setDateFormat:@"HH:mm:ss"];
                NSDate *timeReceipt = [dateFormatter dateFromString:[[dateReceiptTempString componentsSeparatedByString:@"T"] objectAtIndex:1]];
                NSDate *timeIssue = [dateFormatter dateFromString:[[dateIssueTempString componentsSeparatedByString:@"T"] objectAtIndex:1]];
                //Convert system date to own date format
                [dateFormatter setDateFormat:@"dd MMM,yy"];
                tempModel.parcelReceiptDate=[dateFormatter stringFromDate:reciptDate];
                tempModel.parcelIssueDate=[dateFormatter stringFromDate:issuedDate];
                //Convert system time to own time format
                [dateFormatter setDateFormat:@"HH:mm"];
                tempModel.parcelReceiptTime=[dateFormatter stringFromDate:timeReceipt];
                tempModel.parcelIssueTime=[dateFormatter stringFromDate:timeIssue];
                
                tempModel.parcelShippingType=[parcelData valueForKeyPath:@"entry.content.Record.shipping_type_val"];
                if ([[parcelData valueForKeyPath:@"entry.content.Record.status_desc"] isEqualToString:@"Issued"]) {
                    tempModel.parcelStatus=@"Collected";
                }
                else if ([[parcelData valueForKeyPath:@"entry.content.Record.status_desc"] isEqualToString:@"Received"]) {
                    tempModel.parcelStatus=@"New Parcel";
                }
                else {
                    tempModel.parcelStatus=[parcelData valueForKeyPath:@"entry.content.Record.status_desc"];
                }
                
                tempModel.parcelStatusId=[parcelData valueForKeyPath:@"entry.content.Record.ParcelStatusEnum"];
                tempModel.parcelForwardingAddress=[parcelData valueForKeyPath:@"entry.content.Record.address_val"];
                tempModel.parcelTrackingNo=[parcelData valueForKeyPath:@"entry.content.Record.TrackingNumber"];
                tempModel.parcelComment=[parcelData valueForKeyPath:@"entry.content.Record.Comments"];
                tempModel.parcelID=[parcelData valueForKeyPath:@"entry.content.Record.EntryParcelID"];
                [dataArray addObject:tempModel];
            }
            else {  //If multiple entry then resourceData is array type
                for (int i=0; i<[[parcelData objectForKey:@"entry"] count]; i++) {
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                    __block ParcelModel *tempModel=[ParcelModel new];
                    tempModel.parcelTitle=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.Description"];
                    tempModel.parcelType=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.parcel_type_val"];
                    
                    
                    //Convert date/time in system date/time
                    NSString *dateReceiptTempString=[UserDefaultManager GMTToSytemDateTimeFormat:[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.ReceiptDate"]];
                    NSString *dateIssueTempString=[UserDefaultManager GMTToSytemDateTimeFormat:[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.IssueDate"]];
                    //Get date from system date
                    NSDate *reciptDate = [dateFormatter dateFromString:[[dateReceiptTempString componentsSeparatedByString:@"T"] objectAtIndex:0]];
                    NSDate *issuedDate = [dateFormatter dateFromString:[[dateIssueTempString componentsSeparatedByString:@"T"] objectAtIndex:0]];
                    //Get time from system time
                    [dateFormatter setDateFormat:@"HH:mm:ss"];
                    NSDate *timeReceipt = [dateFormatter dateFromString:[[dateReceiptTempString componentsSeparatedByString:@"T"] objectAtIndex:1]];
                    NSDate *timeIssue = [dateFormatter dateFromString:[[dateIssueTempString componentsSeparatedByString:@"T"] objectAtIndex:1]];
                    //Convert system date to own date format
                    [dateFormatter setDateFormat:@"dd MMM,yy"];
                    tempModel.parcelReceiptDate=[dateFormatter stringFromDate:reciptDate];
                    tempModel.parcelIssueDate=[dateFormatter stringFromDate:issuedDate];
                    //Convert system time to own time format
                    [dateFormatter setDateFormat:@"HH:mm"];
                    tempModel.parcelReceiptTime=[dateFormatter stringFromDate:timeReceipt];
                    tempModel.parcelIssueTime=[dateFormatter stringFromDate:timeIssue];
                    
                    tempModel.parcelShippingType=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.shipping_type_val"];                    
                    if ([[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.status_desc"] isEqualToString:@"Issued"]) {
                        tempModel.parcelStatus=@"Collected";
                    }
                    else if ([[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.status_desc"] isEqualToString:@"Received"]) {
                        tempModel.parcelStatus=@"New Parcel";
                    }
                    else {
                        tempModel.parcelStatus=[[[parcelData objectForKey:@"entry"] objectAtIndex:i] valueForKeyPath:@"content.Record.status_desc"];
                    }
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
