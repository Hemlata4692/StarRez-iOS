//
//  ParcelService.m
//  Dwell
//
//  Created by Ranosys on 15/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ParcelService.h"

@implementation ParcelService

#pragma mark - Get parcel list data
- (void)getParcelList:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    NSString *parameters = [NSString stringWithFormat:@"SELECT ep.[EntryParcelID], pt.[Description] as parcel_type_val, st.[Description] as shipping_type_val, ep.[AddressTypeID],ep.[ParcelStatusEnum], ps.[Description] AS status_desc, ep.[IssueDate] , ep.[ReceiptDate], ep.[TrackingNumber], ep.[Comments] , at.[Description] AS address_val, ep.[Description] FROM [EntryParcel] AS ep LEFT JOIN [ParcelStatusEnum] AS ps ON ps.[ParcelStatusEnum] = ep.[ParcelStatusEnum] LEFT JOIN [ParcelType] AS pt ON pt.[ParcelTypeID] = ep.[ParcelTypeID] LEFT JOIN [ShippingType] AS st ON st.[ShippingTypeID] = ep.[ShippingTypeID] LEFT JOIN [AddressType] as at ON at.[AddressTypeID] = ep.[AddressTypeID] WHERE ep.[EntryID] = '%@' ORDER BY ep.[DateModified] DESC",[UserDefaultManager getValue:@"entryId"]];
    DLog(@"request dict %@",parameters);
    [super post:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end
@end
