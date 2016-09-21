//
//  MaintenanceCell.m
//  Dwell
//
//  Created by Sumit on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MaintenanceCell.h"
#import "MainatenanceModel.h"

@implementation MaintenanceCell
@synthesize titleLabel;
@synthesize dateLabel;
@synthesize descriptionField;
@synthesize statusBackgroundVIew;
@synthesize statusLabel;
@synthesize mainBackgroundView;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutCellObject :(CGRect)frame {
    
    //set dynamic height of title
    titleLabel.translatesAutoresizingMaskIntoConstraints = YES;
    descriptionField.translatesAutoresizingMaskIntoConstraints = YES;
    descriptionField.numberOfLines = 0;
    titleLabel.numberOfLines = 0;

    float titleHeight=[UserDefaultManager getDynamicLabelHeight:titleLabel.text font:[UIFont handseanWithSize:14] widthValue:([UIScreen mainScreen].bounds.size.width-20)-125];
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, ([UIScreen mainScreen].bounds.size.width-20)-125, titleHeight+15);

    //set dynamic height of description label.
    
    float descriptionFieldHeight=[UserDefaultManager getDynamicLabelHeight:descriptionField.text font:[UIFont calibriNormalWithSize:14] widthValue:([UIScreen mainScreen].bounds.size.width-20)-25];
    descriptionField.frame = CGRectMake(descriptionField.frame.origin.x, titleLabel.frame.origin.y+titleLabel.frame.size.height+10, ([UIScreen mainScreen].bounds.size.width-20)-25, descriptionFieldHeight);
    
    
    self.backgroundColor=[UIColor clearColor];
    self.contentView.backgroundColor=[UIColor clearColor];
    //Set corner radius to main background view
    mainBackgroundView.layer.cornerRadius=cornerRadius;
    mainBackgroundView.layer.masksToBounds=YES;
    //Round status view from bottom sides
    statusBackgroundVIew.translatesAutoresizingMaskIntoConstraints=YES;
    statusBackgroundVIew.frame=CGRectMake(statusBackgroundVIew.frame.origin.x, descriptionField.frame.origin.y+descriptionField.frame.size.height+10, frame.size.width-32, statusBackgroundVIew.frame.size.height);
    UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:statusBackgroundVIew.bounds byRoundingCorners:( UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(3.0, 3.0)];
    
    //Make dots below title label
    CAShapeLayer *maskLayer=[[CAShapeLayer alloc] init];
    maskLayer.frame=frame;
    maskLayer.path=maskPath.CGPath;
    statusBackgroundVIew.layer.mask = maskLayer;
    statusBackgroundVIew.alpha = 0.7;
    CAShapeLayer *shapelayer=[CAShapeLayer layer];
    UIBezierPath *path=[UIBezierPath bezierPath];
    //Draw a line
    [path moveToPoint:CGPointMake(0.0, titleLabel.frame.size.height)]; //Add yourStartPoint here
    [path addLineToPoint:CGPointMake(frame.size.width-40, titleLabel.frame.size.height)];//Add yourEndPoint here
    UIColor *fill=[UIColor colorWithRed:72.0/255.0 green:73.0/255.0 blue:73.0/255.0 alpha:1.0];
    shapelayer.strokeStart=0.0;
    shapelayer.strokeColor=fill.CGColor;
    shapelayer.lineWidth=1.0f;
    shapelayer.lineJoin=kCALineJoinRound;
    shapelayer.lineDashPattern=[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:7], nil];
    shapelayer.path=path.CGPath;
    [titleLabel.layer addSublayer:shapelayer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayData:(MainatenanceModel *)modelData frame:(CGRect)frame{
    
    descriptionField.text = modelData.detail;
    titleLabel.text = modelData.title;
    [self layoutCellObject:frame];
    
    dateLabel.text = modelData.reportedDate;
    if (modelData.status) {
        statusLabel.text = modelData.status;
    }else{
        statusLabel.text = @"NA";
    }
    
    if([modelData.status isEqualToString:@"Job Completed"]){
        
        statusBackgroundVIew.backgroundColor = [Constants greenBackgroundColor:1.0];
    }else if ([modelData.status isEqualToString:@"Awaiting for Contractor"]||[modelData.status isEqualToString:@"Awaiting for Parts"]||[modelData.status isEqualToString:@"Job in Progress"]){
        statusBackgroundVIew.backgroundColor = [Constants yellowBackgroundColor:1.0];
    }
    else{
     statusBackgroundVIew.backgroundColor = [Constants blueBackgroundColor];
    }
    
    
}
@end
