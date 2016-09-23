//
//  ResourceListCell.h
//  Dwell
//
//  Created by Ranosys on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ResourceModel.h"

@interface ResourceListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mainBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *resourceTitle;
@property (weak, nonatomic) IBOutlet UILabel *resourceType;
@property (weak, nonatomic) IBOutlet UILabel *fromDate;
@property (weak, nonatomic) IBOutlet UILabel *toDate;
@property (weak, nonatomic) IBOutlet UIView *resourceStatusBackGroundView;
@property (weak, nonatomic) IBOutlet UILabel *resourceStatus;

- (void)displayData:(ResourceModel *)modelData frame:(CGRect)frame;
@end
