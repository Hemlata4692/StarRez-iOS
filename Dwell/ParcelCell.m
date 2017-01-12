//
//  ParcelCell.m
//  Dwell
//
//  Created by Shiven on 15/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ParcelCell.h"
#import "UIView+RoundedCorner.h"

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
@synthesize shadowBackView;

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
    mainBackgroundView.layer.cornerRadius=cornerRadius;
    mainBackgroundView.layer.masksToBounds=YES;
//    [shadowBackView addShadowWithCornerRadius:shadowBackView color:[UIColor lightGrayColor] borderColor:[UIColor clearColor] radius:5.0f];  //Add corner radius and shadow
    //Make dots below title label
    CAShapeLayer *shapelayer=[CAShapeLayer layer];
    UIBezierPath *path=[UIBezierPath bezierPath];
    //Draw a line
    [path moveToPoint:CGPointMake(0.0, parcelTitle.frame.size.height)]; //Add yourStartPoint here
    [path addLineToPoint:CGPointMake(frame.size.width-40, parcelTitle.frame.size.height)];//Add yourEndPoint here
    UIColor *fill=[UIColor colorWithRed:72.0/255.0 green:73.0/255.0 blue:73.0/255.0 alpha:1.0];
    shapelayer.strokeStart=0.0;
    shapelayer.strokeColor=fill.CGColor;
    shapelayer.lineWidth=1.0f;
    shapelayer.lineJoin=kCALineJoinRound;
    shapelayer.lineDashPattern=[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:7], nil];
    shapelayer.path=path.CGPath;
    [parcelTitle.layer addSublayer:shapelayer];
}

- (void)displayData:(ParcelModel *)modelData frame:(CGRect)frame{
    
    [self layoutCellObject:frame];
    //Check parcel title is nil
    if ((nil==modelData.parcelTitle)||[modelData.parcelTitle isEqualToString:@""]) {
        parcelTitle.text=@"  No title available";
    }
    else {
        parcelTitle.text=[NSString stringWithFormat:@"  %@",modelData.parcelTitle];
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
        parcelStatusBackGroundView.backgroundColor=[Constants orangeBackgroundColor];
    }
    else if ([modelData.parcelStatusId isEqualToString:@"2"]) {
        parcelStatusBackGroundView.backgroundColor=[Constants yellowBackgroundColor];
    }
    else if ([modelData.parcelStatusId isEqualToString:@"3"]) {
//        parcelStatusBackGroundView.backgroundColor=[Constants blueBackgroundColor];
        parcelStatusBackGroundView.backgroundColor=[Constants redBackgroundColor];//Change color
    }
    else {
        parcelStatusBackGroundView.backgroundColor=[Constants grayBackgroundColor];
    }
}
@end
