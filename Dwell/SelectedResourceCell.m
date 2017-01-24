//
//  SelectedResourceCell.m
//  Dwell
//
//  Created by Ranosys on 24/01/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

#import "SelectedResourceCell.h"

@implementation SelectedResourceCell
@synthesize cellBackview;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayDateTime:(NSString *)startDate endDate:(NSString *)endDate {

    self.fromDateTime.text=startDate;
    self.toDateTime.text=endDate;
}
@end
