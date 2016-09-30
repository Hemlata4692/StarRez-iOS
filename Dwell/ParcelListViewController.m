//
//  ParcelListViewController.m
//  Dwell
//
//  Created by Shiven on 14/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ParcelListViewController.h"
#import "ParcelCell.h"
#import "ParcelDetailViewController.h"
#import "ParcelModel.h"
#import "CustomFilterViewController.h"

@interface ParcelListViewController ()<CustomFilterDelegate,CustomAlertDelegate> {

    CustomAlert *alertView;
    NSMutableArray *parcelDataArray;
     NSMutableArray *parcelSearchDataArray;
    UIBarButtonItem *filterBarButton;
    NSMutableDictionary *parcelStatusDict;
    BOOL isSearch;
}
@property (weak, nonatomic) IBOutlet UITableView *parcelListTableview;
@property (strong, nonatomic) IBOutlet UILabel *noRecordLabel;
@end

@implementation ParcelListViewController
@synthesize parcelListTableview;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UserDefaultManager setValue:[NSNumber numberWithInteger:2] key:@"indexpath"];
    self.navigationItem.title=@"Parcel List";
    self.noRecordLabel.hidden=YES;
    isSearch=false;
    parcelDataArray=[NSMutableArray new];
    parcelSearchDataArray=[NSMutableArray new];
    parcelStatusDict=[NSMutableDictionary new];
    [myDelegate showIndicator:[Constants blueBackgroundColor]];
    [self addRightBarButtonWithImage:[UIImage imageNamed:@"filter"]];
    [self performSelector:@selector(getParcelListService) withObject:nil afterDelay:.1];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

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
#pragma mark - end

#pragma mark - Webservice
//Get parcel list webservice
- (void)getParcelListService {
    
    parcelStatusDict=[NSMutableDictionary new];
    if ([super checkInternetConnection]) {
        ParcelModel *parcelData = [ParcelModel sharedUser];
        [parcelData getParcelListOnSuccess:^(id userData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
                parcelDataArray=[userData mutableCopy];
                
                //Get all type status in parcelStatusDict
                NSMutableArray *tempStatusKeyArray=[NSMutableArray new];
                for (int i=0; i<parcelDataArray.count; i++) {
                    tempStatusKeyArray=[[parcelStatusDict allKeys] mutableCopy];
                    if (![tempStatusKeyArray containsObject:[[parcelDataArray objectAtIndex:i] parcelStatusId]]) {
                        [parcelStatusDict setObject:@"NO" forKey:[NSString stringWithFormat:@"%@,%@",[[parcelDataArray objectAtIndex:i] parcelStatus],[[parcelDataArray objectAtIndex:i] parcelStatusId]]];
                        [tempStatusKeyArray addObject:[NSString stringWithFormat:@"%@,%@",[[parcelDataArray objectAtIndex:i] parcelStatus],[[parcelDataArray objectAtIndex:i] parcelStatusId]]];
                    }
                }
                //end
                [parcelListTableview reloadData];
            });
        } onfailure:^(id error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
                if ([[error objectForKey:@"success"] isEqualToString:@"0"]) {
                    DLog(@"No record found.");
                    self.noRecordLabel.hidden=NO;
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
        return parcelSearchDataArray.count;
    }
    else {
        return parcelDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ParcelCell *cell;
    NSString *simpleTableIdentifier = @"ParcelCell";
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[ParcelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (isSearch) {
        [cell displayData:[parcelSearchDataArray objectAtIndex:indexPath.row] frame:self.view.bounds];
    }
    else {
        [cell displayData:[parcelDataArray objectAtIndex:indexPath.row] frame:self.view.bounds];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ParcelDetailViewController *objParcelDetail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ParcelDetailViewController"];
    if (isSearch) {
        objParcelDetail.parcelDetailData=[parcelSearchDataArray objectAtIndex:indexPath.row];
    }
    else {
        objParcelDetail.parcelDetailData=[parcelDataArray objectAtIndex:indexPath.row];
    }
    [self.navigationController pushViewController:objParcelDetail animated:YES];
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
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"parcelStatus contains[cd] %@",filterString];
        NSArray *subPredicates = [NSArray arrayWithObjects:pred1, nil];
        NSPredicate *orPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:subPredicates];
        parcelSearchDataArray =[[parcelDataArray filteredArrayUsingPredicate:orPredicate] mutableCopy];
    }
    [self.parcelListTableview reloadData];
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
