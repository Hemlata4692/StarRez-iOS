//
//  MaintenanceDetailViewController.m
//  Dwell
//
//  Created by Sumit on 21/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MaintenanceDetailViewController.h"
#import "MainatenanceModel.h"
@interface MaintenanceDetailViewController ()<CustomAlertDelegate>
{
  CustomAlert *alertView;
}
@property (weak, nonatomic) IBOutlet UITableView *maintenanceDetailTableView;

@end

@implementation MaintenanceDetailViewController
@synthesize maintenanceDetailTableView;
@synthesize objMainatenanceModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Maintenance Detail";
    [super addBackgroungImage:@""];
    self.maintenanceDetailTableView.layer.cornerRadius = 3;
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Tableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TitleCell"] ;
                
            }
            UILabel *titleLbl = (UILabel *)[cell.contentView viewWithTag:1];
            titleLbl.text = objMainatenanceModel.title;
            //calcualte dynamic height of title label
            float titleHeight=[UserDefaultManager getDynamicLabelHeight:objMainatenanceModel.title font:[UIFont calibriNormalWithSize:20] widthValue:([UIScreen mainScreen].bounds.size.width-20)-20];
            titleLbl.frame = CGRectMake(titleLbl.frame.origin.x, titleLbl.frame.origin.y, ([UIScreen mainScreen].bounds.size.width-20)-20, titleHeight+15);
            //round top of the label
            CGRect labelFrame = CGRectMake(0, 0, self.view.frame.size.width-34, titleHeight+20);
            UIView *bgView = (UILabel *)[cell.contentView viewWithTag:11];
            bgView.translatesAutoresizingMaskIntoConstraints = YES;
            bgView.frame = CGRectMake(0, 0, labelFrame.size.width, labelFrame.size.height);
            UIBezierPath *maskPath = [UIBezierPath
                                      bezierPathWithRoundedRect:labelFrame
                                      byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                      cornerRadii:CGSizeMake(5, 5)
                                      ];
            
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            
            maskLayer.frame = labelFrame;
            maskLayer.path = maskPath.CGPath;
            
            bgView.layer.mask = maskLayer;
            return cell;
            break;
        }
        case 1:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"InfoCell"] ;
                
            }
            UILabel * reportedDate = (UILabel *)[cell.contentView viewWithTag:2];
            reportedDate.text = objMainatenanceModel.reportedDate;
            UILabel * closedDate = (UILabel *)[cell.contentView viewWithTag:3];
            closedDate.text = objMainatenanceModel.completedDate;
            UILabel * status = (UILabel *)[cell.contentView viewWithTag:4];
            status.text = objMainatenanceModel.status;
            UILabel * category = (UILabel *)[cell.contentView viewWithTag:5];
            category.text = objMainatenanceModel.category;
            
            return cell;
            break;
        }
        case 2:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DescriptionCell"];
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DescriptionCell"] ;
                
            }
            UILabel *descriptionLabel = (UILabel *)[cell.contentView viewWithTag:6];
            descriptionLabel.numberOfLines = 0;
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = YES;
            descriptionLabel.text = objMainatenanceModel.detail;
            float descriptionHeight=[UserDefaultManager getDynamicLabelHeight:descriptionLabel.text font:[UIFont calibriNormalWithSize:14] widthValue:([UIScreen mainScreen].bounds.size.width-20)-40];
            descriptionLabel.frame = CGRectMake(descriptionLabel.frame.origin.x, descriptionLabel.frame.origin.y, ([UIScreen mainScreen].bounds.size.width-20)-40, descriptionHeight);
            return cell;
            break;
        }
        case 3:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CauseCell"];
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CauseCell"] ;
                
            }
            UILabel *causeLabel = (UILabel *)[cell.contentView viewWithTag:7];
            causeLabel.numberOfLines = 0;
            causeLabel.translatesAutoresizingMaskIntoConstraints = YES;
            if (objMainatenanceModel.cause) {
                causeLabel.text = objMainatenanceModel.cause;
                float causeHeight=[UserDefaultManager getDynamicLabelHeight:causeLabel.text font:[UIFont calibriNormalWithSize:14] widthValue:([UIScreen mainScreen].bounds.size.width-20)-40];
                causeLabel.frame = CGRectMake(causeLabel.frame.origin.x, causeLabel.frame.origin.y, ([UIScreen mainScreen].bounds.size.width-20)-40, causeHeight);
            }else{
                causeLabel.frame = CGRectMake(causeLabel.frame.origin.x, causeLabel.frame.origin.y, ([UIScreen mainScreen].bounds.size.width-20)-40, 30);
                causeLabel.text = @"NA";
            }
            
            return cell;
            break;
        }
        case 4:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentsCell"];
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CommentsCell"] ;
                
            }
            UILabel *commentsLabel = (UILabel *)[cell.contentView viewWithTag:8];
            commentsLabel.numberOfLines = 0;
            commentsLabel.translatesAutoresizingMaskIntoConstraints = YES;
            if (objMainatenanceModel.commetns) {
                commentsLabel.text = objMainatenanceModel.commetns;
                float commentsHeight=[UserDefaultManager getDynamicLabelHeight:commentsLabel.text font:[UIFont calibriNormalWithSize:14] widthValue:([UIScreen mainScreen].bounds.size.width-20)-40];
                commentsLabel.frame = CGRectMake(commentsLabel.frame.origin.x, commentsLabel.frame.origin.y-5, ([UIScreen mainScreen].bounds.size.width-20)-40, commentsHeight);
            }else{
                commentsLabel.frame = CGRectMake(commentsLabel.frame.origin.x, commentsLabel.frame.origin.y, ([UIScreen mainScreen].bounds.size.width-20)-40, 30);
                commentsLabel.text = @"NA";
            }
            return cell;
            break;
        }
        case 5:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AgreeCell"];
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"AgreeCell"] ;
                
            }
            return cell;
            break;
        }
        case 6:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell"];
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ButtonCell"] ;
                
            }
            
            CGRect labelFrame = CGRectMake(0, 0, self.view.frame.size.width-34, cell.contentView.frame.size.height);
            UILabel *closeLabel = (UILabel *)[cell.contentView viewWithTag:10];
            closeLabel.translatesAutoresizingMaskIntoConstraints = YES;
            closeLabel.frame = CGRectMake(0, 0, labelFrame.size.width, cell.contentView.frame.size.height);
            UIBezierPath *maskPath = [UIBezierPath
                                      bezierPathWithRoundedRect:labelFrame
                                      byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                      cornerRadii:CGSizeMake(5, 5)
                                      ];
            
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            
            maskLayer.frame = labelFrame;
            maskLayer.path = maskPath.CGPath;
            
            closeLabel.layer.mask = maskLayer;
            if ([objMainatenanceModel.status isEqualToString:@"Closed by student"]) {
                
                cell.alpha = 0.7;
                closeLabel.alpha = 0.7;
            }else{
                cell.alpha = 1.0;
                closeLabel.alpha = 1.0;
            }
            //cell.contentView.layer.cornerRadius = cornerRadius;
            return cell;
            break;
        }
            
        default:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TitleCell"] ;
                
            }
            return cell;
            break;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            float titleHeight=[UserDefaultManager getDynamicLabelHeight:objMainatenanceModel.title font:[UIFont calibriNormalWithSize:20] widthValue:([UIScreen mainScreen].bounds.size.width-20)-20];
            return titleHeight+20;
            break;
        }
        case 1:
            return 157.0;
            break;
        case 2:
        {
            float descriptionHeight=[UserDefaultManager getDynamicLabelHeight:objMainatenanceModel.detail font:[UIFont calibriNormalWithSize:14] widthValue:([UIScreen mainScreen].bounds.size.width-20)-40];
            return descriptionHeight+40;
            break;
        }
        case 3:
        {
            if (objMainatenanceModel.cause) {
                float causeHeight=[UserDefaultManager getDynamicLabelHeight:objMainatenanceModel.cause font:[UIFont calibriNormalWithSize:14] widthValue:([UIScreen mainScreen].bounds.size.width-20)-40];
                return causeHeight+40;
            }
            else{
                
                return 60;
            }
            
        }
            break;
        case 4:
            if (objMainatenanceModel.commetns) {
                float commentsHeight=[UserDefaultManager getDynamicLabelHeight:objMainatenanceModel.commetns font:[UIFont calibriNormalWithSize:14] widthValue:([UIScreen mainScreen].bounds.size.width-20)-40];
                return commentsHeight+45;
            }
            else{
                
                return 60;
            }
            break;
        case 5:
            return 70.0;
            break;
        case 6:
            return 35.0;
            break;
            
        default:
            return 30.0;
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==6 && !([objMainatenanceModel.status isEqualToString:@"Closed by student"])) {
        
        [myDelegate showIndicator:[Constants orangeBackgroundColor]];
        [self performSelector:@selector(cancelService) withObject:nil afterDelay:.1];
    }
}
#pragma mark - end

#pragma mark - Webservice

- (void)categoryService{
    
    if ([super checkInternetConnection]) {
        MainatenanceModel *mainatenanceData = [MainatenanceModel sharedUser];
        [mainatenanceData getCategoryListOnSuccess:^(id userData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
                
            });
        } onfailure:^(id error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
                if ([[error objectForKey:@"success"] isEqualToString:@"0"]) {
                    DLog(@"No record found.");
                    
                }
                else {
                    alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Something went wrong, Please try again." doneButtonText:@"OK" cancelButtonText:@""];
                }
            });
        }];
    }
}

- (void)cancelService{
    
    [UserDefaultManager setValue:objMainatenanceModel.maintenenceId key:@"maintainId"];
    if ([super checkInternetConnection]) {
        MainatenanceModel *mainatenanceData = [MainatenanceModel sharedUser];
        [mainatenanceData cancelServiceOnSuccess:^(id userData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
               alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"This maintenance request has been closed successfully." doneButtonText:@"OK" cancelButtonText:@""];
                objMainatenanceModel.status = @"Closed by student";
                [maintenanceDetailTableView reloadData];
            });
        } onfailure:^(id error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
                if ([[error objectForKey:@"success"] isEqualToString:@"0"]) {
                    DLog(@"No record found.");
                    
                }
                else {
                    alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Something went wrong, Please try again." doneButtonText:@"OK" cancelButtonText:@""];
                }
            });
        }];
    }
}
#pragma mark - end

#pragma mark - Custom alert delegates
- (void)customAlertDelegateAction:(CustomAlert *)customAlert option:(int)option{
    
    [alertView dismissAlertView];
}
#pragma mark - end
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
