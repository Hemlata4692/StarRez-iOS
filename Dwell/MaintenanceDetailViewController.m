//
//  MaintenanceDetailViewController.m
//  Dwell
//
//  Created by Sumit on 21/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MaintenanceDetailViewController.h"
#import "MaintenanceModel.h"
#import "CustomAlertView.h"
#import "UIImageView+WebCache.h"

@interface MaintenanceDetailViewController ()<CustomAlertDelegate> {
    
    CustomAlert *alertView;
    int indexCount;
    float rowHeight;
    NSMutableArray *maintenanceImageArray;
}
@property (weak, nonatomic) IBOutlet UITableView *maintenanceDetailTableView;
@end

@implementation MaintenanceDetailViewController
@synthesize maintenanceDetailTableView;
@synthesize objMainatenanceModel;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"Maintenance Detail";
    [super addBackgroungImage:@""];
    self.maintenanceDetailTableView.layer.cornerRadius=3;
    //Fetch image ids
    [myDelegate showIndicator:[Constants navigationColor]];
    [self performSelector:@selector(getMaintenanceListService) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Webservice
//Get parcel list webservice
- (void)getMaintenanceListService {
    
    maintenanceImageArray=[NSMutableArray new];
    if ([super checkInternetConnection]) {
        MaintenanceModel *mainatenanceData = [MaintenanceModel sharedUser];
        [mainatenanceData getMaintenanceImageIdOnSuccess:objMainatenanceModel.maintenanceId success:^(id userData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
                if ([userData count]>0) {
                    maintenanceImageArray=[userData mutableCopy];
                    [self.maintenanceDetailTableView reloadData];
                }
            });
        } onfailure:^(id error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
                
                alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Something went wrong, Please try again." doneButtonText:@"OK" cancelButtonText:@""];
            });
        }];
    }
    else {
        [myDelegate stopIndicator];
    }
}
#pragma mark - end

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
            //Calculate dynamic height of title label
            float titleHeight=[UserDefaultManager getDynamicLabelHeight:objMainatenanceModel.title font:[UIFont calibriNormalWithSize:20] widthValue:([UIScreen mainScreen].bounds.size.width-30)-16];
            titleLbl.frame = CGRectMake(titleLbl.frame.origin.x, titleLbl.frame.origin.y, ([UIScreen mainScreen].bounds.size.width-30), titleHeight+15);
            //Round top of the label
            CGRect labelFrame = CGRectMake(0, 0, self.view.frame.size.width-30, titleHeight+20);
            UIView *bgView = (UIView *)[cell.contentView viewWithTag:11];
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
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"InfoCell"];
            }
            UILabel * reportedDate = (UILabel *)[cell.contentView viewWithTag:2];
            reportedDate.text = objMainatenanceModel.reportedDate;
            UILabel * closedDate = (UILabel *)[cell.contentView viewWithTag:3];
            if (objMainatenanceModel.completedDate==nil) {
                closedDate.text=@"NA";
            }
            else {
                closedDate.text = objMainatenanceModel.completedDate;
            }
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
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DescriptionCell"];
            }
            UILabel *descriptionLabel = (UILabel *)[cell.contentView viewWithTag:6];
            descriptionLabel.numberOfLines = 0;
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = YES;
            descriptionLabel.text = objMainatenanceModel.detail;
            float descriptionHeight=[UserDefaultManager getDynamicLabelHeight:descriptionLabel.text font:[UIFont calibriNormalWithSize:15] widthValue:([UIScreen mainScreen].bounds.size.width-30)-16];
           // descriptionLabel.backgroundColor = [UIColor redColor];
            descriptionLabel.frame = CGRectMake(descriptionLabel.frame.origin.x, descriptionLabel.frame.origin.y+3, ([UIScreen mainScreen].bounds.size.width-30)-16, descriptionHeight);
            return cell;
            break;
        }
        case 3:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CauseCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CauseCell"];
            }
            UILabel *causeLabel = (UILabel *)[cell.contentView viewWithTag:7];
            causeLabel.numberOfLines = 0;
            causeLabel.translatesAutoresizingMaskIntoConstraints = YES;
            if (objMainatenanceModel.cause) {
                causeLabel.text = objMainatenanceModel.cause;
                float causeHeight=[UserDefaultManager getDynamicLabelHeight:causeLabel.text font:[UIFont calibriNormalWithSize:15] widthValue:([UIScreen mainScreen].bounds.size.width-30)-16];
                causeLabel.frame = CGRectMake(causeLabel.frame.origin.x, causeLabel.frame.origin.y+3, ([UIScreen mainScreen].bounds.size.width-30)-16, causeHeight);
            }else{
                causeLabel.frame = CGRectMake(causeLabel.frame.origin.x, causeLabel.frame.origin.y+3, ([UIScreen mainScreen].bounds.size.width-30)-16, 30);
                causeLabel.text = @"NA";
            }
            return cell;
            break;
        }
        case 4:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentsCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CommentsCell"];
            }
            UILabel *commentsLabel = (UILabel *)[cell.contentView viewWithTag:8];
            commentsLabel.numberOfLines = 0;
            commentsLabel.translatesAutoresizingMaskIntoConstraints = YES;
            if (objMainatenanceModel.commetns) {
                commentsLabel.text = objMainatenanceModel.commetns;
                float commentsHeight=[UserDefaultManager getDynamicLabelHeight:commentsLabel.text font:[UIFont calibriNormalWithSize:15] widthValue:([UIScreen mainScreen].bounds.size.width-30)-16];
                commentsLabel.frame = CGRectMake(commentsLabel.frame.origin.x, commentsLabel.frame.origin.y, ([UIScreen mainScreen].bounds.size.width-30)-16, commentsHeight);
            }else{
                commentsLabel.frame = CGRectMake(commentsLabel.frame.origin.x, commentsLabel.frame.origin.y-5, ([UIScreen mainScreen].bounds.size.width-30)-16, 30);
                commentsLabel.text = @"NA";
            }
            return cell;
            break;
        }
        case 5:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectionViewCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CollectionViewCell"] ;
            }
            //Load image collection view if image ids exist
            if (maintenanceImageArray.count>0) {
                UICollectionView *imageCollectionView=(UICollectionView*)[cell viewWithTag:15];
                [imageCollectionView reloadData];
            }
            return cell;
            break;
        }
        case 6:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ButtonCell"];
            }
            CGRect labelFrame = CGRectMake(0, 0, self.view.frame.size.width-30, cell.contentView.frame.size.height);
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
            //Set dynamic height of cell according to title
            float titleHeight=[UserDefaultManager getDynamicLabelHeight:objMainatenanceModel.title font:[UIFont calibriNormalWithSize:20] widthValue:([UIScreen mainScreen].bounds.size.width-30)-16];
            return titleHeight+20;
            break;
        }
        case 1:
            return 140.0;
            break;
        case 2:
        {
            //Set dynamic height of cell according to detail
            float descriptionHeight=[UserDefaultManager getDynamicLabelHeight:objMainatenanceModel.detail font:[UIFont calibriNormalWithSize:15] widthValue:([UIScreen mainScreen].bounds.size.width-30)-16];
            return descriptionHeight+40;
            break;
        }
        case 3:
        {
            if (objMainatenanceModel.cause) {
                //Set dynamic height of cell according to cause
                float causeHeight=[UserDefaultManager getDynamicLabelHeight:objMainatenanceModel.cause font:[UIFont calibriNormalWithSize:15] widthValue:([UIScreen mainScreen].bounds.size.width-30)-16];
                return causeHeight+40;
            }
            else {
                return 60;
            }
        }
            break;
        case 4:
            if (objMainatenanceModel.commetns) {
                //Set dynamic height of cell according to comments
                float commentsHeight=[UserDefaultManager getDynamicLabelHeight:objMainatenanceModel.commetns font:[UIFont calibriNormalWithSize:15] widthValue:([UIScreen mainScreen].bounds.size.width-30)-16];
                return commentsHeight+45;
            }
            else {
                return 90;
            }
            break;
        case 5:
            if (maintenanceImageArray.count==0) {
                return 0.0;
            }
            else {
                return 120.0;
            }
            break;
        case 6:
            return 35.0;
            break;
            
        default:
            return 30.0;
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==6 && !([objMainatenanceModel.status isEqualToString:@"Closed by student"])) {
        
        alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:3 delegate:self message:@"Are you sure to close this request?" doneButtonText:@"Yes" cancelButtonText:@"No"];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect cellSize = cell.frame;
    if (indexCount<7) {
        rowHeight = rowHeight+cellSize.size.height;
        indexCount++;
        [self addShadowToTableview];//Set table view shadow
    }
    DLog(@"cellSize is %f and index: %ld",cellSize.size.height,(long)indexPath.row);
}

- (void)addShadowToTableview {
    
    maintenanceDetailTableView.layer.shadowPath = nil;
    CGRect frame = maintenanceDetailTableView.frame;
    frame.origin.y = -5;
    frame.origin.x = 0.0;
    frame.size.width = self.view.bounds.size.width-33;
    frame.size.height = rowHeight;
    UIBezierPath *shadowPath2 = [UIBezierPath bezierPathWithRect:frame];
    maintenanceDetailTableView.layer.masksToBounds = NO;
    maintenanceDetailTableView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    maintenanceDetailTableView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    maintenanceDetailTableView.layer.shadowOpacity = 0.5f;
    maintenanceDetailTableView.layer.shadowPath = shadowPath2.CGPath;
}
#pragma mark - end

#pragma mark - Collection view methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return maintenanceImageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *imageCell=[collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"ImageCell"
                                    forIndexPath:indexPath];
    UIImageView *maintenanceImage=(UIImageView*)[imageCell viewWithTag:16];
    //Add authenticaiton to get image in (SDWebImageManager.m->init method->add httpHeader in _imageDownloader)
    [maintenanceImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://starrez.centurionstudents.co.uk/StarRezREST/services/photo/RecordAttachment/%@",[maintenanceImageArray objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    maintenanceImage.layer.borderColor=[UIColor colorWithRed:200.0/255 green:200.0/255.0 blue:200.0/255.0 alpha:1.0].CGColor;
    maintenanceImage.layer.borderWidth=1.0f;
    
    return imageCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"%d",(int)indexPath.row);
}
#pragma mark - end

#pragma mark - Webservice

- (void)categoryService {
    
    if ([super checkInternetConnection]) {
        MaintenanceModel *mainatenanceData = [MaintenanceModel sharedUser];
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
    else {
        [myDelegate stopIndicator];
    }
}

- (void)cancelService{
    
    [UserDefaultManager setValue:objMainatenanceModel.maintenanceId key:@"maintainId"];
    if ([super checkInternetConnection]) {
        MaintenanceModel *mainatenanceData = [MaintenanceModel sharedUser];
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
                    DLog(@"No record found.");                }
                else {
                    alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Something went wrong, Please try again." doneButtonText:@"OK" cancelButtonText:@""];
                }
            });
        }];
    }
    else {
        [myDelegate stopIndicator];
    }
}
#pragma mark - end

#pragma mark - Custom alert delegates
- (void)customAlertDelegateAction:(CustomAlertView *)customAlert option:(int)option{
    
    [alertView dismissAlertView];
    if ((customAlert.alertTagValue==3)&&(option==1)) {
        //Retry service call
        [myDelegate showIndicator:[Constants navigationColor]];
        [self performSelector:@selector(cancelService) withObject:nil afterDelay:.1];
    }
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
