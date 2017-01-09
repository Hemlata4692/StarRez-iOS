//
//  MaintenanceCell.h
//  Dwell
//
//  Created by Sumit on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MaintenanceModel;
@interface MaintenanceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionField;
@property (weak, nonatomic) IBOutlet UIView *statusBackgroundVIew;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *mainBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *titleBgVIew;

- (void)displayData:(MaintenanceModel *)modelData frame:(CGRect)frame;
@end
