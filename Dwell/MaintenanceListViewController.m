//
//  MaintenanceListViewController.m
//  Dwell
//
//  Created by Sumit on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MaintenanceListViewController.h"
#import "MaintenanceCell.h"
#import "MainatenanceModel.h"
#import "CustomFilterViewController.h"
#import "MaintenanceDetailViewController.h"
#import "AddNewJobViewController.h"

@interface MaintenanceListViewController ()<CustomFilterDelegate,CustomAlertDelegate>
{
   UIBarButtonItem *filterBarButton;
    CustomAlert *alertView;
    //Data structures for filter feature.
    NSMutableDictionary *parcelStatusDict;
    BOOL isSearch;
    NSMutableArray *maintenanceSearchDataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *maintenanceTable;
@property (nonatomic,retain) NSMutableArray * maintenanceArray;
@end

@implementation MaintenanceListViewController
@synthesize maintenanceTable;
@synthesize maintenanceArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Maintenance";
    //Add background image
    [super addBackgroungImage:@""];
    maintenanceArray = [[NSMutableArray alloc]init];
    [self addRightBarButtonWithImage:[UIImage imageNamed:@"filter"]];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [UserDefaultManager setValue:[NSNumber numberWithInteger:1] key:@"indexpath"];
    [myDelegate showIndicator:[Constants orangeBackgroundColor]];
    [self performSelector:@selector(getMaintenanceListService) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Add right bar filter button
- (void)addRightBarButtonWithImage:(UIImage *)buttonImage {
    
    CGRect frameimg = CGRectMake(0, 0, buttonImage.size.width+5, buttonImage.size.height+5);
    UIButton *button = [[UIButton alloc] initWithFrame:frameimg];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    filterBarButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(filterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:filterBarButton, nil];
}
//Filter button action
- (void)filterButtonAction:(id)sender {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomFilterViewController *filterViewObj =[storyboard instantiateViewControllerWithIdentifier:@"CustomFilterViewController"];
    filterViewObj.delegate=self;
    if (isSearch) {
        filterViewObj.isAllSelected=false;
    }
    else {
        filterViewObj.isAllSelected=true;
    }
    filterViewObj.filterDict=[parcelStatusDict mutableCopy];
    [filterViewObj setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:filterViewObj animated:NO completion:nil];
}

- (IBAction)addJob:(id)sender {
    
    AddNewJobViewController *objAddJob = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddNewJobViewController"];
    [self.navigationController pushViewController:objAddJob animated:YES];
}
#pragma mark - end

#pragma mark - Webservice
//Get parcel list webservice
- (void)getMaintenanceListService {
    
    isSearch = false;
    parcelStatusDict=[NSMutableDictionary new];
    if ([super checkInternetConnection]) {
        MainatenanceModel *mainatenanceData = [MainatenanceModel sharedUser];
        [mainatenanceData getMaintenanceListOnSuccess:^(id userData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
                maintenanceArray = [userData mutableCopy];
                //Get all type status in parcelStatusDict
                NSMutableArray *tempStatusKeyArray=[NSMutableArray new];
                for (int i=0; i<maintenanceArray.count; i++) {
                    tempStatusKeyArray=[[parcelStatusDict allKeys] mutableCopy];
                    if (![tempStatusKeyArray containsObject:[NSString stringWithFormat:@"%@,%@",[[maintenanceArray objectAtIndex:i] status],[[maintenanceArray objectAtIndex:i] status]]]) {
                        [parcelStatusDict setObject:@"NO" forKey:[NSString stringWithFormat:@"%@,%@",[[maintenanceArray objectAtIndex:i] status],[[maintenanceArray objectAtIndex:i] status]]];
                        [tempStatusKeyArray addObject:[NSString stringWithFormat:@"%@,%@",[[maintenanceArray objectAtIndex:i] status],[[maintenanceArray objectAtIndex:i] status]]];
                    }
                }
                //end
                [maintenanceTable reloadData];
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
#pragma mark - end

#pragma mark - Tableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (isSearch) {
        return maintenanceSearchDataArray.count;
    }
    else {
        return maintenanceArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MaintenanceCell *cell;
    NSString *simpleTableIdentifier = @"MaintenanceCell";
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[MaintenanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    //Display data according to filtered status.
    if (isSearch) {
        [cell displayData:[maintenanceSearchDataArray objectAtIndex:indexPath.row] frame:self.view.bounds];
    }
    else {
        [cell displayData:[maintenanceArray objectAtIndex:indexPath.row] frame:self.view.bounds];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainatenanceModel *objModel;
    if (isSearch)    {
    objModel= [maintenanceSearchDataArray objectAtIndex:indexPath.row];
    }
    else{
    objModel= [maintenanceArray objectAtIndex:indexPath.row];
    }
    

    float titleHeight=[UserDefaultManager getDynamicLabelHeight:[objModel title] font:[UIFont calibriNormalWithSize:20] widthValue:([UIScreen mainScreen].bounds.size.width-20)-125];
    float forwardAddressHeight=[UserDefaultManager getDynamicLabelHeight:[[maintenanceArray objectAtIndex:indexPath.row] detail] font:[UIFont calibriNormalWithSize:14] widthValue:([UIScreen mainScreen].bounds.size.width-20)-25];
    return forwardAddressHeight+titleHeight+97.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MaintenanceDetailViewController *objDetail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MaintenanceDetailViewController"];
    if (isSearch) {
        objDetail.objMainatenanceModel=[maintenanceSearchDataArray objectAtIndex:indexPath.row];
    }
    else {
        objDetail.objMainatenanceModel=[maintenanceArray objectAtIndex:indexPath.row];
    }
    [self.navigationController pushViewController:objDetail animated:YES];
}
#pragma mark - end

#pragma mark - Custom filter delegate
- (void)customFilterDelegateAction:(NSMutableDictionary*)filteredData filterString:(NSString *)filterString{
    
    if ([filterString isEqualToString:@"All"]) {
        isSearch=false;
        parcelStatusDict=[filteredData mutableCopy];
    }
    else {
        isSearch=true;
        parcelStatusDict=[filteredData mutableCopy];
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"status contains[cd] %@",filterString];
        NSArray *subPredicates = [NSArray arrayWithObjects:pred1, nil];
        NSPredicate *orPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:subPredicates];
        maintenanceSearchDataArray =[[maintenanceArray filteredArrayUsingPredicate:orPredicate] mutableCopy];
    }
    [self.maintenanceTable reloadData];
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
