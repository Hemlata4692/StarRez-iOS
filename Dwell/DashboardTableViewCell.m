//
//  DashboardTableViewCell.m
//  Dwell
//
//  Created by Monika Sharma on 27/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "DashboardTableViewCell.h"
#import "UIView+RoundedCorner.h"
#import "MainatenanceModel.h"
#import "ParcelModel.h"

@implementation DashboardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    [self layoutCellObject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)layoutCellObject {
    
    [self.cellContainerView addShadowWithCornerRadius:self.cellContainerView color:[UIColor lightGrayColor] borderColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0] radius:5.0f];  //Add corner radius and shadow
}

- (void)displayData:(NSMutableDictionary*)dashboardData selectedType:(int)selectedType {//Here selected type is parcel type(1) or maintenence type(2)
    
    
}
//- (void)setMentenenceInformation:()
@end
