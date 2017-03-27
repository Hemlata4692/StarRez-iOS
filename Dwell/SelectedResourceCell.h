//
//  SelectedResourceCell.h
//  Dwell
//
//  Created by Ranosys on 24/01/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedResourceCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *cellBackview;
@property (strong, nonatomic) IBOutlet UILabel *fromDateTime;
@property (strong, nonatomic) IBOutlet UILabel *toDateTime;

- (void)displayDateTime:(NSString *)startDate endDate:(NSString *)endDate;
@end
