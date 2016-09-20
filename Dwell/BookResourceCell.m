//
//  BookResourceCell.m
//  Dwell
//
//  Created by Ranosys on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "BookResourceCell.h"

@implementation BookResourceCell
@synthesize bookResourceContainerView;
@synthesize textFieldTitle;
@synthesize resourceTextField;
@synthesize dropDownArrow;
@synthesize searchButton;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
