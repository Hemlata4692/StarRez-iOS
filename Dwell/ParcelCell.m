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

- (void)layoutCellObject :(CGRect)frame {
    
    self.backgroundColor=[UIColor clearColor];
    self.contentView.backgroundColor=[UIColor clearColor];
    //Set corner radius to main background view
    mainBackgroundView.layer.cornerRadius=3;
    mainBackgroundView.layer.masksToBounds=YES;
    //Round status view from bottom sides
    parcelStatusBackGroundView.translatesAutoresizingMaskIntoConstraints=YES;
    parcelStatusBackGroundView.frame=CGRectMake(parcelStatusBackGroundView.frame.origin.x, parcelStatusBackGroundView.frame.origin.y, frame.size.width-32, parcelStatusBackGroundView.frame.size.height);
}

- (void)displayData:(ParcelModel *)modelData frame:(CGRect)frame{
    
    [self layoutCellObject:frame];
    //Check parcel title is nil
    if ((nil==modelData.parcelTitle)||[modelData.parcelTitle isEqualToString:@""]) {
        parcelTitle.text=@"    NA";
    }
    else {
        parcelTitle.text=[NSString stringWithFormat:@"    %@",modelData.parcelTitle];
    }
    //Check parcel type is nil
    if ((nil==modelData.parcelType)||[modelData.parcelType isEqualToString:@""]) {
        parcelType.text=@"NA";
    }
    else {
        parcelType.text=modelData.parcelType;
    }
    //Check parcel shipping type is nil
    if ((nil==modelData.parcelShippingType)||[modelData.parcelShippingType isEqualToString:@""]) {
        shippingType.text=@"NA";
    }
    else {
        shippingType.text=modelData.parcelShippingType;
    }
    //Check recipt date is nil
    if ((nil==modelData.parcelReceiptDate)||[modelData.parcelReceiptDate isEqualToString:@""]) {
        receiptDate.text=@"NA";
    }
    else {
        receiptDate.text=modelData.parcelReceiptDate;
    }
    //Check issued date is nil
    if ((nil==modelData.parcelIssueDate)||[modelData.parcelIssueDate isEqualToString:@""]) {
        issueDate.text=@"NA";
    }
    else {
        issueDate.text=modelData.parcelIssueDate;
    }
    //Check parcel status is nil
    if ((nil==modelData.parcelStatus)||[modelData.parcelStatus isEqualToString:@""]) {
        parcelStatus.text=@"NA";
    }
    else {
        parcelStatus.text=modelData.parcelStatus;
    }
    if ([modelData.parcelStatusId isEqualToString:@"0"]) {
        parcelStatusBackGroundView.backgroundColor=[Constants greenBackgroundColor];
    }
    else if ([modelData.parcelStatusId isEqualToString:@"1"]) {
        parcelStatusBackGroundView.backgroundColor=[Constants yellowBackgroundColor];
    }
    else if ([modelData.parcelStatusId isEqualToString:@"3"]) {
        parcelStatusBackGroundView.backgroundColor=[Constants redBackgroundColor];
    }
    else {
        parcelStatusBackGroundView.backgroundColor=[Constants yellowBackgroundColor];
    }
}
@end
