//
//  BookResourceCell.h
//  Dwell
//
//  Created by Ranosys on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookResourceCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *bookResourceContainerView;
@property (strong, nonatomic) IBOutlet UILabel *textFieldTitle;
@property (strong, nonatomic) IBOutlet UITextField *resourceTextField;
@property (strong, nonatomic) IBOutlet UIImageView *dropDownArrow;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@end
