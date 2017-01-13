//
//  ResourceListViewController.m
//  Dwell
//
//  Created by Ranosys on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ResourceListViewController.h"
#import "ResourceListCell.h"
#import "ResourceDetailViewController.h"
#import "ResourceModel.h"
#import "CustomFilterViewController.h"
#import "BookResourceViewController.h"

@interface ResourceListViewController ()<CustomFilterDelegate> {
    
    CustomAlert *alertView;
    NSMutableArray *resourceDataArray;
    NSMutableArray *resourceSearchDataArray;
    UIBarButtonItem *filterBarButton;
    NSMutableDictionary *resourceStatusDict;
    BOOL isSearch;
}
@property (weak, nonatomic) IBOutlet UITableView *resourceListTableview;
@property (strong, nonatomic) IBOutlet UILabel *noRecordLabel;
@end

@implementation ResourceListViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Resource";
    resourceDataArray=[NSMutableArray new];
    resourceSearchDataArray=[NSMutableArray new];
    resourceStatusDict=[NSMutableDictionary new];
    [super addBackgroungImage:@"Resource"];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    //Set index to selected show in menu
    [UserDefaultManager setValue:[NSNumber numberWithInteger:3] key:@"indexpath"];
    self.noRecordLabel.hidden=YES;
    isSearch=false;
    [self addRightBarButtonWithImage:[UIImage imageNamed:@"filter"]];   //Add filter button in right navigation item
    filterBarButton.enabled=false;
//    [myDelegate showIndicator:[Constants oldGreenBackgroundColor:1.0]];
    [myDelegate showIndicator:[Constants navigationColor]];
    [self performSelector:@selector(getResourceListService) withObject:nil afterDelay:.1];
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
    if (isSearch) { //If filter selected
        filterViewObj.isAllSelected=false;
    }
    else {
        filterViewObj.isAllSelected=true;
    }
    filterViewObj.filterDict=[resourceStatusDict mutableCopy];
    [filterViewObj setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:filterViewObj animated:NO completion:nil];
}
#pragma mark - end

#pragma mark - Webservice
//Get resource list webservice
- (void)getResourceListService {
    
    self.noRecordLabel.hidden=YES;
    filterBarButton.enabled=false;
    resourceStatusDict=[NSMutableDictionary new];
    if ([super checkInternetConnection]) {
        ResourceModel *resourceData = [ResourceModel sharedUser];
        [resourceData getResourceListOnSuccess:^(id resourceData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
                resourceDataArray=[resourceData mutableCopy];
                
                //Set all type status in resourceStatusDict
                NSMutableArray *tempStatusKeyArray=[NSMutableArray new];
                for (int i=0; i<resourceDataArray.count; i++) {
                    tempStatusKeyArray=[[resourceStatusDict allKeys] mutableCopy];
                    if (![tempStatusKeyArray containsObject:[NSString stringWithFormat:@"%@,%@",[[resourceDataArray objectAtIndex:i] resourceStatus],[[resourceDataArray objectAtIndex:i] resourceStatusId]]]) {
                        DLog(@"%@",[NSString stringWithFormat:@"%@,%@",[[resourceDataArray objectAtIndex:i] resourceStatus],[[resourceDataArray objectAtIndex:i] resourceStatusId]]);
                        [resourceStatusDict setObject:@"NO" forKey:[NSString stringWithFormat:@"%@,%@",[[resourceDataArray objectAtIndex:i] resourceStatus],[[resourceDataArray objectAtIndex:i] resourceStatusId]]];
                        [tempStatusKeyArray addObject:[NSString stringWithFormat:@"%@,%@",[[resourceDataArray objectAtIndex:i] resourceStatus],[[resourceDataArray objectAtIndex:i] resourceStatusId]]];
                    }
                }
                //end
                filterBarButton.enabled=true;
                [self.resourceListTableview reloadData];
            });
        } onfailure:^(id error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
                if ([[error objectForKey:@"success"] isEqualToString:@"0"]) {
                    DLog(@"No record found.");
                    self.noRecordLabel.hidden=NO;
                    filterBarButton.enabled=false;
                    self.noRecordLabel.text = @"No resource available.";
                }
                else {
                    filterBarButton.enabled=false;
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
    
    if (isSearch) { //If filter selected
        return resourceSearchDataArray.count;
    }
    else {
        return resourceDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ResourceListCell *cell;
    NSString *simpleTableIdentifier = @"ResourceCell";
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[ResourceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (isSearch) { //If filter selected
        [cell displayData:[resourceSearchDataArray objectAtIndex:indexPath.row] frame:self.view.bounds];
    }
    else {
        [cell displayData:[resourceDataArray objectAtIndex:indexPath.row] frame:self.view.bounds];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ResourceDetailViewController *objresourceDetail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ResourceDetailViewController"];
    if (isSearch) { //If filter selected
        objresourceDetail.resourceDetailData=[resourceSearchDataArray objectAtIndex:indexPath.row];
    }
    else {
        objresourceDetail.resourceDetailData=[resourceDataArray objectAtIndex:indexPath.row];
    }
    [self.navigationController pushViewController:objresourceDetail animated:YES];
}
#pragma mark - end

#pragma mark - Custom filter delegate
- (void)customFilterDelegateAction:(NSMutableDictionary*)filteredData filterString:(NSString *)filterString{
    
    if ([filterString isEqualToString:@"All"]) {
        isSearch=false;
        resourceStatusDict=[filteredData mutableCopy];
    }
    else {
        isSearch=true;
        resourceStatusDict=[filteredData mutableCopy];
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"resourceStatus contains[cd] %@",filterString];
        NSArray *subPredicates = [NSArray arrayWithObjects:pred1, nil];
        NSPredicate *orPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:subPredicates];
        resourceSearchDataArray =[[resourceDataArray filteredArrayUsingPredicate:orPredicate] mutableCopy];
    }
    [self.resourceListTableview reloadData];
}
#pragma mark - end

#pragma mark - IBAction
- (IBAction)addBookResource:(UIButton *)sender {
    
    BookResourceViewController *objBookResource = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BookResourceViewController"];
    [self.navigationController pushViewController:objBookResource animated:YES];
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
