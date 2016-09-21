//
//  BookResourceCell.m
//  Dwell
//
//  Created by Ranosys on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "BookResourceCell.h"
#import "UITextField+Padding.h"

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

- (void)displayData:(NSMutableArray *)dataArray index:(int)index {

    [self viewLayout:dataArray index:index];
    if (index<(dataArray.count)) {
        if (index==1) {
            
        }
        else {
            
        }
    }
    
}

- (void)viewLayout:(NSMutableArray *)dataArray index:(int)index {

    if (index==(dataArray.count)) {
        searchButton.layer.cornerRadius=22.0;
        searchButton.layer.masksToBounds=YES;
    }
    else {
        if (index!=1) {
            [resourceTextField addTextFieldPadding:resourceTextField];
        }
        bookResourceContainerView.layer.cornerRadius=cornerRadius;
        bookResourceContainerView.layer.masksToBounds=YES;
        
    }
    
   
}

@end
