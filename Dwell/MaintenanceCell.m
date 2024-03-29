//
//  MaintenanceCell.m
//  Dwell
//
//  Created by Sumit on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MaintenanceCell.h"
#import "MaintenanceModel.h"
#import "UIView+RoundedCorner.h"
@implementation MaintenanceCell
@synthesize titleLabel;
@synthesize dateLabel;
@synthesize descriptionField;
@synthesize statusBackgroundVIew;
@synthesize statusLabel;
@synthesize mainBackgroundView;
@synthesize titleBgVIew;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutCellObject :(CGRect)frame {
    
    //set dynamic height of title
    titleLabel.translatesAutoresizingMaskIntoConstraints = YES;
    descriptionField.translatesAutoresizingMaskIntoConstraints = YES;
    titleBgVIew.translatesAutoresizingMaskIntoConstraints = YES;
    descriptionField.numberOfLines = 0;
    titleLabel.numberOfLines = 0;
    float width;
    if (frame.size.width<414) {
        width = frame.size.width-32;
    }
    else{
        width = frame.size.width-40;
    }
    float titleHeight=[UserDefaultManager getDynamicLabelHeight:titleLabel.text font:[UIFont handseanWithSize:16] widthValue:([UIScreen mainScreen].bounds.size.width-20)-125];
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, ([UIScreen mainScreen].bounds.size.width-20)-125, titleHeight+25);
    titleBgVIew.frame = CGRectMake(titleBgVIew.frame.origin.x, titleBgVIew.frame.origin.y, width, titleLabel.frame.size.height);
    //Set dynamic height of description label.
    
    float descriptionFieldHeight=[UserDefaultManager getDynamicLabelHeight:descriptionField.text font:[UIFont calibriNormalWithSize:19] widthValue:([UIScreen mainScreen].bounds.size.width-20)-26];
    descriptionField.frame = CGRectMake(descriptionField.frame.origin.x, titleLabel.frame.origin.y+titleLabel.frame.size.height+20, ([UIScreen mainScreen].bounds.size.width-20)-25, descriptionFieldHeight);
    //Set corner radius to main background view
    mainBackgroundView.layer.cornerRadius=cornerRadius;
    mainBackgroundView.layer.masksToBounds=YES;
    // [self.mainBackgroundView addShadowWithCornerRadius:self.mainBackgroundView color:[UIColor lightGrayColor] borderColor:[UIColor clearColor] radius:5.0f];
    statusBackgroundVIew.translatesAutoresizingMaskIntoConstraints=YES;
    statusBackgroundVIew.frame=CGRectMake(statusBackgroundVIew.frame.origin.x, descriptionField.frame.origin.y+descriptionField.frame.size.height+20, width, statusBackgroundVIew.frame.size.height);
    
    //Round bottom of status background
    UIBezierPath *statusMaskPath = [UIBezierPath bezierPathWithRoundedRect:statusBackgroundVIew.bounds
                                                         byRoundingCorners:UIRectCornerBottomLeft| UIRectCornerBottomRight
                                                               cornerRadii:CGSizeMake(5.0, 5.0)];
    //Create the shape layer and set its path
    CAShapeLayer *statusMaskLayer = [CAShapeLayer layer];
    statusMaskLayer.frame = statusBackgroundVIew.bounds;
    statusMaskLayer.path = statusMaskPath.CGPath;
    //Set the newly created shape layer as the mask for the image view's layer
    statusBackgroundVIew.layer.mask = statusMaskLayer;
    
    //Create the shape layer and set its path
    if (self.shapeLayer)
        [self.shapeLayer removeFromSuperlayer];
    
    UIBezierPath *path=[UIBezierPath bezierPath];
    //Draw a line
    [path moveToPoint:CGPointMake(10.0, titleHeight+25)]; //Add yourStartPoint here
    [path addLineToPoint:CGPointMake(frame.size.width-20, titleHeight+25)];//Add yourEndPoint here
    UIColor *fill=[UIColor colorWithRed:72.0/255.0 green:73.0/255.0 blue:73.0/255.0 alpha:1.0];
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.strokeStart=0.0;
    self.shapeLayer.strokeColor=fill.CGColor;
    self.shapeLayer.lineWidth=1.0f;
    self.shapeLayer.lineJoin=kCALineJoinRound;
    self.shapeLayer.lineDashPattern=[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:7], nil];
    self.shapeLayer.path=path.CGPath;
    [self.layer addSublayer:self.shapeLayer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayData:(MaintenanceModel *)modelData frame:(CGRect)frame {
    
    //Set NA if detail is blank
    if (modelData.detail) {
        descriptionField.text = modelData.detail;
    }
    else {
        descriptionField.text = @"NA";
    }
    //Set NA if title is blank
    if (modelData.title) {
        titleLabel.text = modelData.title;
    }
    else {
        titleLabel.text = @"NA";
    }
    [self layoutCellObject:frame];
    //Set NA if reported date is blank
    if (modelData.reportedDate) {
        dateLabel.text = modelData.reportedDate;
    }
    else {
        dateLabel.text = @"NA";
    }
    //Set NA if status is blank
    if (modelData.status) {
        statusLabel.text = modelData.status;
//        if ([modelData.status isEqualToString:@"Closed by student"]) {
//           statusLabel.text = @"Cancelled by Student";
//        }
//        else {
//            statusLabel.text = modelData.status;
//        }
    }
    else {
        statusLabel.text = @"NA";
    }
    
    //Set background color according to status
    if([modelData.status isEqualToString:@"Job Completed"]) {
        
        statusBackgroundVIew.backgroundColor = [Constants purpleBackgroundColor];
    }
    else if ([modelData.status isEqualToString:@"Awaiting for Contractor"]||[modelData.status isEqualToString:@"Awaiting for Parts"]) {
        statusBackgroundVIew.backgroundColor = [Constants redBackgroundColor];
    }
    else if ([modelData.status isEqualToString:@"Job in Progress"]) {
        statusBackgroundVIew.backgroundColor = [Constants yellowBackgroundColor];
    }
    else if ([modelData.status isEqualToString:@"Job Received"]) {
//        statusBackgroundVIew.backgroundColor = [Constants orangeBackgroundColor];//Change color
        statusBackgroundVIew.backgroundColor = [Constants skyBlueColor];
    }
    else if ([modelData.status isEqualToString:@"Job Scheduled"]) {
        statusBackgroundVIew.backgroundColor = [Constants blueBackgroundColor];
    }
    else if ([modelData.status isEqualToString:@"Please contact office"]) {
        statusBackgroundVIew.backgroundColor = [Constants oliveGreenBackgroundColor];
    }
    else if ([modelData.status isEqualToString:@"Job Submitted"]) {
        statusBackgroundVIew.backgroundColor = [Constants greenBackgroundColor];
    }
    else if ([modelData.status isEqualToString:@"Closed"]) {
        statusBackgroundVIew.backgroundColor = [Constants darkGrayBackgroundColor];
    }
    else {
        statusBackgroundVIew.backgroundColor = [Constants grayBackgroundColor];
    }
}
@end
