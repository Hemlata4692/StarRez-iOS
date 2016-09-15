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

- (void)layoutCellObject :(CGRect)frame{
    
    mainBackgroundView.layer.cornerRadius = cornerRadius;
    parcelStatusBackGroundView.translatesAutoresizingMaskIntoConstraints = YES;
    parcelStatusBackGroundView.frame = CGRectMake(parcelStatusBackGroundView.frame.origin.x, parcelStatusBackGroundView.frame.origin.y, frame.size.width-32, parcelStatusBackGroundView.frame.size.height);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:parcelStatusBackGroundView.bounds byRoundingCorners:( UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(3.0, 3.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = frame;
    maskLayer.path  = maskPath.CGPath;
    parcelStatusBackGroundView.layer.mask = maskLayer;
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    //draw a line
    [path moveToPoint:CGPointMake(0.0, parcelTitle.frame.size.height)]; //add yourStartPoint here
    [path addLineToPoint:CGPointMake(frame.size.width-40, parcelTitle.frame.size.height)];// add yourEndPoint here
    UIColor *fill = [UIColor colorWithRed:72.0/255.0 green:73.0/255.0 blue:73.0/255.0 alpha:1.0];
    shapelayer.strokeStart = 0.0;
    shapelayer.strokeColor = fill.CGColor;
    shapelayer.lineWidth = 1.0f;
    shapelayer.lineJoin = kCALineJoinRound;
    shapelayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:7], nil];
    //shapelayer.lineDashPhase = 3.0f;
    shapelayer.path = path.CGPath;
    [parcelTitle.layer addSublayer:shapelayer];
}

- (void)displayData:(ParcelModel *)modelData frame:(CGRect)frame{
    
    [self layoutCellObject:frame];
    parcelTitle.text=modelData.parcelTitle;
    parcelType.text=modelData.parcelType;
    receiptDate.text=modelData.parcelReceiptDate;
    shippingType.text=modelData.parcelShippingType;
    issueDate.text=modelData.parcelIssueDate;
    if ([modelData.parcelStatus isEqualToString:@"Received"]) {
       parcelStatus.text=@"Collected";
        parcelStatusBackGroundView.backgroundColor=[Constants resourceColor];
    }
    else if ([modelData.parcelStatus isEqualToString:@"Issued"]) {
        parcelStatus.text=@"Parcel for Collection";
        parcelStatusBackGroundView.backgroundColor=[Constants eventColor];
    }
    else if ([modelData.parcelStatus isEqualToString:@"Returned"]) {
        parcelStatus.text=modelData.parcelStatus;
         parcelStatusBackGroundView.backgroundColor=[Constants resourceColor];
    }
    else {
        parcelStatus.text=modelData.parcelStatus;
         parcelStatusBackGroundView.backgroundColor=[Constants resourceColor];
    }
}
@end
