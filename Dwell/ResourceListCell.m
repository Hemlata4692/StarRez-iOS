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
    [self.mainBackgroundView setCornerRadius:5.0f];
    [backShadowView addShadowWithCornerRadius:backShadowView color:[UIColor lightGrayColor] borderColor:[UIColor clearColor] radius:5.0f];  //Add corner radius and shadow
}

- (void)displayData:(ResourceModel *)modelData frame:(CGRect)frame{
    
    [self layoutCellObject:frame];
    //Check resource title is nil
    if ((nil==modelData.resourceTitle)||[modelData.resourceTitle isEqualToString:@""]) {
        resourceTitle.text=@"NA";
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
        resourceStatusBackGroundView.backgroundColor=[Constants skyBlueColor];
    }
    else if ([modelData.resourceStatusId isEqualToString:@"1"]) {
        resourceStatusBackGroundView.backgroundColor=[Constants redBackgroundColor];
    }
    else if ([modelData.resourceStatusId isEqualToString:@"2"]) {
        resourceStatusBackGroundView.backgroundColor=[Constants yellowBackgroundColor];
    }
    else if ([modelData.resourceStatusId isEqualToString:@"3"]) {
        resourceStatusBackGroundView.backgroundColor=[Constants yellowBackgroundColor];
    }
    else {
        resourceStatusBackGroundView.backgroundColor=[Constants cancelColor];
    }
}
@end