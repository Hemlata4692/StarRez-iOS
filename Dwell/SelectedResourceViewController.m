//
//  SelectedResourceViewController.m
//  Dwell
//
//  Created by Ranosys on 24/01/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

#import "SelectedResourceViewController.h"
#import "ResourceModel.h"
#import "ResourceModel.h"
#import "SelectedResourceCell.h"
#import "BookResourceViewController.h"

@interface SelectedResourceViewController ()<CustomAlertDelegate> {
    
    CustomAlert *alertView;
    NSMutableArray *selectedResourcePeriodArray;
}
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (strong, nonatomic) IBOutlet UITableView *selectedResourceNamePeriodTableView;
@end

@implementation SelectedResourceViewController
@synthesize selectedResourceNameId, selectedResourceName;
@synthesize resourceNameFromDate;
@synthesize resourceNameToDate;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Booked Details";
    [super addBackgroungImage:@"Resource"];
    
    self.headerView.hidden=YES;
    self.headerTitleLabel.text=selectedResourceName;
    selectedResourcePeriodArray=[NSMutableArray new];
    [self.selectedResourceNamePeriodTableView reloadData];
    
    [myDelegate showIndicator:[Constants navigationColor]];
    [self performSelector:@selector(getResourcesNamePeriodList) withObject:nil afterDelay:.1];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self viewCustomization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - View customization
- (void)viewCustomization {

    //Add top rounded corner
    CGRect labelFrame = CGRectMake(0, 0, self.view.bounds.size.width-24, 60);
    UIBezierPath *maskPath = [UIBezierPath
                              bezierPathWithRoundedRect:labelFrame
                              byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                              cornerRadii:CGSizeMake(cornerRadius, cornerRadius)
                              ];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = labelFrame;
    maskLayer.path = maskPath.CGPath;
    self.headerView.layer.mask = maskLayer;
    //end
    
    //Draw doted line
    CAShapeLayer *shapelayer=[CAShapeLayer layer];
    UIBezierPath *path=[UIBezierPath bezierPath];
    //Draw a line
    [path moveToPoint:CGPointMake(0.0, labelFrame.size.height-5)]; //Add yourStartPoint here
    [path addLineToPoint:CGPointMake(labelFrame.size.width, labelFrame.size.height-5)];//Add yourEndPoint here
    UIColor *fill=[UIColor colorWithRed:72.0/255.0 green:73.0/255.0 blue:73.0/255.0 alpha:1.0];
    shapelayer.strokeStart=0.0;
    shapelayer.strokeColor=fill.CGColor;
    shapelayer.lineWidth=1.0f;
    shapelayer.lineJoin=kCALineJoinRound;
    shapelayer.lineDashPattern=[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:7], nil];
    shapelayer.path=path.CGPath;
    [self.headerView.layer addSublayer:shapelayer];
    //end
}
#pragma mark - end

#pragma mark - Webservice
//Get resource type list webservice
- (void)getResourcesNamePeriodList {

//    bookResourceLocationArray=[NSMutableArray new];
    if ([super checkInternetConnection]) {
        ResourceModel *resourceData=[ResourceModel sharedUser];
        resourceData.resourceFromDate=resourceNameFromDate;
        resourceData.resourceToDate=resourceNameToDate;
        resourceData.resourceTypeLocationId=selectedResourceNameId;
        [resourceData getSelectedResourceDetailOnSuccess:^(id resourceData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
                self.headerView.hidden=NO;
                selectedResourcePeriodArray=[resourceData mutableCopy];
                [self.selectedResourceNamePeriodTableView reloadData];
            });
        } onfailure:^(id error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
                if ([[error objectForKey:@"success"] isEqualToString:@"2"]) {
                    alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:5 delegate:self message:@"Something went wrong, Please try again." doneButtonText:@"Retry" cancelButtonText:@""];
                }
//                else {
//                    alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"There is not any resource type available yet." doneButtonText:@"OK" cancelButtonText:@""];
//                }
            });
        }];
    }
    else {
        [myDelegate stopIndicator];
    }
}
#pragma mark - end

#pragma mark - Tableview methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return selectedResourcePeriodArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SelectedResourceCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"SelectedResourceCell"];
    if (cell == nil) {
        cell = [[SelectedResourceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectedResourceCell"];
    }
    [cell displayDateTime:[NSString stringWithFormat:@"%@ %@",[[selectedResourcePeriodArray objectAtIndex:indexPath.row] resourceFromDate],[[selectedResourcePeriodArray objectAtIndex:indexPath.row] resourceFromTime]] endDate:[NSString stringWithFormat:@"%@ %@",[[selectedResourcePeriodArray objectAtIndex:indexPath.row] resourceToDate],[[selectedResourcePeriodArray objectAtIndex:indexPath.row] resourceToTime]]];
    
    if (indexPath.row==selectedResourcePeriodArray.count-1) {
        
        CGRect labelFrame = CGRectMake(0, 0, self.view.frame.size.width-24, cell.contentView.frame.size.height);
        UIBezierPath *maskPath = [UIBezierPath
                                  bezierPathWithRoundedRect:labelFrame
                                  byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                  cornerRadii:CGSizeMake(cornerRadius, cornerRadius)
                                  ];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        
        maskLayer.frame = labelFrame;
        maskLayer.path = maskPath.CGPath;
        
        cell.cellBackview.layer.mask = maskLayer;
    }
    else {
        DLog(@"only else");
        CGRect labelFrame = CGRectMake(0, 0, self.view.frame.size.width-24, cell.contentView.frame.size.height);
        UIBezierPath *maskPath = [UIBezierPath
                                  bezierPathWithRoundedRect:labelFrame
                                  byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                  cornerRadii:CGSizeMake(0, 0)
                                  ];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        
        maskLayer.frame = labelFrame;
        maskLayer.path = maskPath.CGPath;
        
        cell.cellBackview.layer.mask = maskLayer;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {}
#pragma mark - end

#pragma mark - UIView action
- (IBAction)addMoreResource:(UIButton *)sender {
    BookResourceViewController *objBookResource = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BookResourceViewController"];
    [self.navigationController pushViewController:objBookResource animated:YES];
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
