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
    mainBackgroundView.layer.cornerRadius=cornerRadius;
    mainBackgroundView.layer.masksToBounds=YES;
    //Round status view from bottom sides
    parcelStatusBackGroundView.translatesAutoresizingMaskIntoConstraints=YES;
    parcelStatusBackGroundView.frame=CGRectMake(parcelStatusBackGroundView.frame.origin.x, parcelStatusBackGroundView.frame.origin.y, frame.size.width-32, parcelStatusBackGroundView.frame.size.height);
    UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:parcelStatusBackGroundView.bounds byRoundingCorners:( UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(3.0, 3.0)];
    
    //Make dots below title label
    CAShapeLayer *maskLayer=[[CAShapeLayer alloc] init];
    maskLayer.frame=frame;
    maskLayer.path=maskPath.CGPath;
    parcelStatusBackGroundView.layer.mask = maskLayer;
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
    parcelTitle.text=modelData.parcelTitle;
    parcelType.text=modelData.parcelType;
    receiptDate.text=modelData.parcelReceiptDate;
    shippingType.text=modelData.parcelShippingType;
    issueDate.text=modelData.parcelIssueDate;
    parcelStatus.text=modelData.parcelStatus;
    if ([modelData.parcelStatusId isEqualToString:@"0"]) {
        parcelStatusBackGroundView.backgroundColor=[Constants greenBackgroundColor:0.6];
    }
    else if ([modelData.parcelStatusId isEqualToString:@"1"]) {
        parcelStatusBackGroundView.backgroundColor=[Constants yellowBackgroundColor:0.6];
    }
    else if ([modelData.parcelStatusId isEqualToString:@"3"]) {
        parcelStatusBackGroundView.backgroundColor=[Constants redBackgroundColor:0.6];
    }
    else {
         parcelStatusBackGroundView.backgroundColor=[Constants yellowBackgroundColor:0.6];
    }
}
@end
