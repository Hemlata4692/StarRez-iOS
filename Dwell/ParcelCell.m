//
//  ParcelCell.m
//  Dwell
//
//  Created by Shiven on 15/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ParcelCell.h"

@implementation ParcelCell
@synthesize parcelTitle;
@synthesize separatorView;
@synthesize parcelTypeTitle;
@synthesize parcelType;
@synthesize receiptDateTitle;
@synthesize receiptDate;
@synthesize shippingTypeTitle;
@synthesize shippingType;
@synthesize issueDateTitle;
@synthesize issueDate;
@synthesize parcelStatusBackGroundView;
@synthesize parcelStatus;
@synthesize mainBackgroundView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutCellObject{
    
    mainBackgroundView.layer.cornerRadius = 5.0;
}

- (void)displayData : (NSDictionary *)dataDict{
    
    [self layoutCellObject];
    
}
@end
