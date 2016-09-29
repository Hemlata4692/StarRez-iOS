//
//  DashboardTableViewCell.h
//  Dwell
//
//  Created by Monika Sharma on 27/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *cellContainerView;

@property (strong, nonatomic) IBOutlet UIImageView *titleIcon;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstInformationTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstInformationDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstInformationStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondInformationTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondInformationDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondInformationStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdInformationTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdInformationDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdInformationStatusLabel;
@end
