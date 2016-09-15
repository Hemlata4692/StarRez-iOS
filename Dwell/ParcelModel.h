//
//  ParcelModel.h
//  Dwell
//
//  Created by Ranosys on 15/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParcelModel : NSObject

@property (strong, nonatomic) NSString *parcelTitle;
@property (strong, nonatomic) NSString *parcelType;
@property (strong, nonatomic) NSString *parcelReceiptDate;
@property (strong, nonatomic) NSString *parcelShippingType;
@property (strong, nonatomic) NSString *parcelIssueDate;
@property (strong, nonatomic) NSString *parcelStatus;
@property (strong, nonatomic) NSString *parcelForwardingAddress;
@property (strong, nonatomic) NSString *parcelTrackingNo;
@property (strong, nonatomic) NSString *parcelComment;
@property (strong, nonatomic) NSString *parcelID;

+ (instancetype)sharedUser;
//Parcel listing with detail
- (void)getParcelListOnSuccess:(void (^)(id))success onfailure:(void (^)(id))failure;
@end
