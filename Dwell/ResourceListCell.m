//
//  ResourceListCell.m
//  Dwell
//
//  Created by Ranosys on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ResourceListCell.h"
#import "UIView+RoundedCorner.h"

@implementation ResourceListCell
@synthesize resourceTitle;
@synthesize resourceType;
@synthesize fromDate;
@synthesize toDate;
@synthesize resourceStatusBackGroundView;
@synthesize resourceStatus;
@synthesize mainBackgroundView;
@synthesize backShadowView;

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
    [self.mainBackgroundView setCornerRadius:10.0f];
//    [backShadowView addShadowWithCornerRadius:backShadowView color:[UIColor lightGrayColor] borderColor:[UIColor clearColor] radius:5.0f];  //Add corner radius and shadow
    //Round status view from bottom sides
    resourceStatusBackGroundView.translatesAutoresizingMaskIntoConstraints=YES;
    resourceStatusBackGroundView.frame=CGRectMake(resourceStatusBackGroundView.frame.origin.x, resourceStatusBackGroundView.frame.origin.y, frame.size.width-30, resourceStatusBackGroundView.frame.size.height);
    UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:resourceStatusBackGroundView.bounds byRoundingCorners:( UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(3.0, 3.0)];
    
    //Make dots below title label
    CAShapeLayer *maskLayer=[[CAShapeLayer alloc] init];
    maskLayer.frame=frame;
    maskLayer.path=maskPath.CGPath;
    resourceStatusBackGroundView.layer.mask = maskLayer;
    CAShapeLayer *shapelayer=[CAShapeLayer layer];
    UIBezierPath *path=[UIBezierPath bezierPath];
    //Draw a line
    [path moveToPoint:CGPointMake(0.0, resourceTitle.frame.size.height)]; //Add yourStartPoint here
    [path addLineToPoint:CGPointMake(frame.size.width-40, resourceTitle.frame.size.height)];//Add yourEndPoint here
    UIColor *fill=[UIColor colorWithRed:72.0/255.0 green:73.0/255.0 blue:73.0/255.0 alpha:1.0];
    shapelayer.strokeStart=0.0;
    shapelayer.strokeColor=fill.CGColor;
    shapelayer.lineWidth=1.0f;
    shapelayer.lineJoin=kCALineJoinRound;
    shapelayer.lineDashPattern=[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:7], nil];
    shapelayer.path=path.CGPath;
    [resourceTitle.layer addSublayer:shapelayer];
}

- (void)displayData:(ResourceModel *)modelData frame:(CGRect)frame{
    
    [self layoutCellObject:frame];
    //Check resource title is nil
    if ((nil==modelData.resourceTitle)||[modelData.resourceTitle isEqualToString:@""]) {
        resourceTitle.text=@"No title available";
    }
    else {
        resourceTitle.text=modelData.resourceTitle;
    }
    //Check resource type is nil
    if ((nil==modelData.resourceType)||[modelData.resourceType isEqualToString:@""]) {
        resourceType.text=@"NA";
    }
    else {
        resourceType.text=modelData.resourceType;
    }
    //Check fromDate is nil
    if ((nil==modelData.resourceFromDate)||[modelData.resourceFromDate isEqualToString:@""]) {
        fromDate.text=@"NA";
    }
    else {
        fromDate.text=modelData.resourceFromDate;
    }
    //Check toDate is nil
    if ((nil==modelData.resourceToDate)||[modelData.resourceToDate isEqualToString:@""]) {
        toDate.text=@"NA";
    }
    else {
        toDate.text=modelData.resourceToDate;
    }
    //Check resource status is nil
    if ((nil==modelData.resourceStatus)||[modelData.resourceStatus isEqualToString:@""]) {
        resourceStatus.text=@"NA";
    }
    else {
        resourceStatus.text=modelData.resourceStatus;
    }
    
    //Set status back color according to fetch status
    if ([modelData.resourceStatusId isEqualToString:@"0"]) {
        resourceStatusBackGroundView.backgroundColor=[Constants greenBackgroundColor];
    }
    else if ([modelData.resourceStatusId isEqualToString:@"1"]) {
        resourceStatusBackGroundView.backgroundColor=[Constants orangeBackgroundColor];
    }
    else if ([modelData.resourceStatusId isEqualToString:@"2"]) {
        resourceStatusBackGroundView.backgroundColor=[Constants blueBackgroundColor];
    }
    else if ([modelData.resourceStatusId isEqualToString:@"3"]) {
        resourceStatusBackGroundView.backgroundColor=[Constants yellowBackgroundColor];
    }
    else if ([modelData.resourceStatusId isEqualToString:@"4"]) {
        resourceStatusBackGroundView.backgroundColor=[Constants redBackgroundColor];
    }
    else {
        resourceStatusBackGroundView.backgroundColor=[Constants grayBackgroundColor];
    }
}
@end
