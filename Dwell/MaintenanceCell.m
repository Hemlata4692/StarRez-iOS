//
//  MaintenanceCell.m
//  Dwell
//
//  Created by Sumit on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MaintenanceCell.h"
#import "MainatenanceModel.h"
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

    float titleHeight=[UserDefaultManager getDynamicLabelHeight:titleLabel.text font:[UIFont calibriNormalWithSize:20] widthValue:([UIScreen mainScreen].bounds.size.width-20)-125];
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, ([UIScreen mainScreen].bounds.size.width-20)-125, titleHeight+25);
    titleBgVIew.frame = CGRectMake(titleBgVIew.frame.origin.x, titleBgVIew.frame.origin.y, (frame.size.width-32), titleLabel.frame.size.height);
    //set dynamic height of description label.
    
    float descriptionFieldHeight=[UserDefaultManager getDynamicLabelHeight:descriptionField.text font:[UIFont calibriNormalWithSize:14] widthValue:([UIScreen mainScreen].bounds.size.width-20)-25];
    descriptionField.frame = CGRectMake(descriptionField.frame.origin.x, titleLabel.frame.origin.y+titleLabel.frame.size.height+10, ([UIScreen mainScreen].bounds.size.width-20)-25, descriptionFieldHeight);
    //Set corner radius to main background view
    [self.mainBackgroundView addShadowWithCornerRadius:self.mainBackgroundView color:[UIColor lightGrayColor] borderColor:[UIColor clearColor] radius:5.0f];
    statusBackgroundVIew.translatesAutoresizingMaskIntoConstraints=YES;
    statusBackgroundVIew.frame=CGRectMake(statusBackgroundVIew.frame.origin.x, descriptionField.frame.origin.y+descriptionField.frame.size.height+10, frame.size.width-32, statusBackgroundVIew.frame.size.height);
    
    //Round bottom of status background
    UIBezierPath *statusMaskPath = [UIBezierPath bezierPathWithRoundedRect:statusBackgroundVIew.bounds
                                                   byRoundingCorners:UIRectCornerBottomLeft| UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(5.0, 5.0)];
    // Create the shape layer and set its path
    CAShapeLayer *statusMaskLayer = [CAShapeLayer layer];
    statusMaskLayer.frame = statusBackgroundVIew.bounds;
    statusMaskLayer.path = statusMaskPath.CGPath;
    // Set the newly created shape layer as the mask for the image view's layer
    statusBackgroundVIew.layer.mask = statusMaskLayer;
    
    //Round top of the title background
    UIBezierPath *titleMaskPath = [UIBezierPath bezierPathWithRoundedRect:titleBgVIew.bounds
                                                         byRoundingCorners:UIRectCornerTopLeft| UIRectCornerTopRight
                                                               cornerRadii:CGSizeMake(5.0, 5.0)];
    // Create the shape layer and set its path
    CAShapeLayer *titleMaskLayer = [CAShapeLayer layer];
    titleMaskLayer.frame = titleBgVIew.bounds;
    titleMaskLayer.path = titleMaskPath.CGPath;
    // Set the newly created shape layer as the mask for the image view's layer
    titleBgVIew.layer.mask = titleMaskLayer;

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
        
        statusBackgroundVIew.backgroundColor = [Constants greenBackgroundColor];
    }else if ([modelData.status isEqualToString:@"Awaiting for Contractor"]||[modelData.status isEqualToString:@"Awaiting for Parts"]||[modelData.status isEqualToString:@"Job in Progress"]){
        statusBackgroundVIew.backgroundColor = [Constants yellowBackgroundColor];
    }
    else{
        statusBackgroundVIew.backgroundColor = [Constants blueBackgroundColor];
    }
    
    
}
@end
