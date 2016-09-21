//
//  MaintenanceDetailViewController.m
//  Dwell
//
//  Created by Sumit on 21/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MaintenanceDetailViewController.h"
#import "MainatenanceModel.h"
@interface MaintenanceDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *maintenanceDetailTableView;

@end

@implementation MaintenanceDetailViewController
@synthesize maintenanceDetailTableView;
@synthesize objMainatenanceModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Maintenance Detail";
    [super addBackgroungImage:@"maintenance"];
    self.maintenanceDetailTableView.layer.cornerRadius = cornerRadius;
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
            float titleHeight=[UserDefaultManager getDynamicLabelHeight:objMainatenanceModel.title font:[UIFont handseanWithSize:14] widthValue:([UIScreen mainScreen].bounds.size.width-20)-20];
            titleLbl.frame = CGRectMake(titleLbl.frame.origin.x, titleLbl.frame.origin.y, ([UIScreen mainScreen].bounds.size.width-20)-20, titleHeight+15);
            
            CAShapeLayer *shapelayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            //draw a line
            [path moveToPoint:CGPointMake(0.0, titleLbl.frame.size.height)]; //add yourStartPoint here
            [path addLineToPoint:CGPointMake(self.view.frame.size.width, titleLbl.frame.size.height)];// add yourEndPoint here
            UIColor *fill = [UIColor blackColor];
            shapelayer.strokeStart = 0.0;
            shapelayer.strokeColor = fill.CGColor;
            shapelayer.lineWidth = 1.0f;
            shapelayer.lineJoin = kCALineJoinRound;
            shapelayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:7], nil];
            //shapelayer.lineDashPhase = 3.0f;
            shapelayer.path = path.CGPath;
            [titleLbl.layer addSublayer:shapelayer];
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
                commentsLabel.frame = CGRectMake(commentsLabel.frame.origin.x, commentsLabel.frame.origin.y, ([UIScreen mainScreen].bounds.size.width-20)-40, commentsHeight);
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
            float titleHeight=[UserDefaultManager getDynamicLabelHeight:objMainatenanceModel.title font:[UIFont handseanWithSize:14] widthValue:([UIScreen mainScreen].bounds.size.width-20)-20];
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
            return 50.0;
            break;
            
        default:
            return 50.0;
            break;
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
