//
//  ResourceTypeCell.m
//  Dwell
//
//  Created by Ranosys on 24/01/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

#import "ResourceTypeCell.h"
#import "ResourceModel.h"
@implementation ResourceTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayResourceName: (NSString *)resourceName {

    self.resourceNameBackView.layer.cornerRadius=cornerRadius;
    self.resourceNameBackView.layer.masksToBounds=YES;
    self.resourceNameLabel.font=[UIFont calibriNormalWithSize:18];
    self.resourceNameLabel.text=resourceName;
    self.resourceNameLabel.textColor=[UIColor colorWithRed:123.0/255 green:123.0/255.0 blue:123.0/255.0 alpha:1.0];
}
@end
