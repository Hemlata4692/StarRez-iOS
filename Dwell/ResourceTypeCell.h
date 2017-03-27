//
//  ResourceTypeCell.h
//  Dwell
//
//  Created by Ranosys on 24/01/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResourceTypeCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *resourceNameBackView;
@property (strong, nonatomic) IBOutlet UILabel *resourceNameLabel;

- (void)displayResourceName: (NSString *)resourceName;
@end
