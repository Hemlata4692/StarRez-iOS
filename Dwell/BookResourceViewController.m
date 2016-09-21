//
//  BookResourceViewController.m
//  Dwell
//
//  Created by Ranosys on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "BookResourceViewController.h"
#import "BookResourceCell.h"
#import "ParcelModel.h"
#import "ResourceModel.h"

@interface BookResourceViewController (){
    
    CustomAlert *alertView;
    NSMutableArray *bookResourceTypeArray, *bookResourceLocationArray;
    NSArray *inputFieldTitleArray;
}
@property (weak, nonatomic) IBOutlet UITableView *bookResourceFormTableView;
@end

@implementation BookResourceViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Book Resource";
    //Add background image
    [super addBackgroungImage:@"Resource"];
    bookResourceLocationArray=[NSMutableArray new];
    bookResourceTypeArray=[NSMutableArray new];
    bookResourceLocationArray=[NSMutableArray new];
    inputFieldTitleArray=@[@"RESOURCE TYPE",@"RESOURCE NAME",@"LOCATION",@"FROM",@"TO"];
    
//    [myDelegate showIndicator:[Constants greenBackgroundColor:1.0]];
//    [self performSelector:@selector(getResourceType) withObject:nil afterDelay:.1];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Webservice
//Get parcel list webservice
- (void)getResourceType {
    
//    resourceStatusDict=[NSMutableDictionary new];
    if ([super checkInternetConnection]) {
        ResourceModel *resourceData = [ResourceModel sharedUser];
        [resourceData getResourceTypeOnSuccess:^(id resourceData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
//                resourceDataArray=[resourceData mutableCopy];
//                
//                //Get all type status in resourceStatusDict
//                NSMutableArray *tempStatusKeyArray=[NSMutableArray new];
//                for (int i=0; i<resourceDataArray.count; i++) {
//                    tempStatusKeyArray=[[resourceStatusDict allKeys] mutableCopy];
//                    if (![tempStatusKeyArray containsObject:[NSString stringWithFormat:@"%@,%@",[[resourceDataArray objectAtIndex:i] resourceStatus],[[resourceDataArray objectAtIndex:i] resourceStatusId]]]) {
//                        DLog(@"%@",[NSString stringWithFormat:@"%@,%@",[[resourceDataArray objectAtIndex:i] resourceStatus],[[resourceDataArray objectAtIndex:i] resourceStatusId]]);
//                        [resourceStatusDict setObject:@"NO" forKey:[NSString stringWithFormat:@"%@,%@",[[resourceDataArray objectAtIndex:i] resourceStatus],[[resourceDataArray objectAtIndex:i] resourceStatusId]]];
//                        [tempStatusKeyArray addObject:[NSString stringWithFormat:@"%@,%@",[[resourceDataArray objectAtIndex:i] resourceStatus],[[resourceDataArray objectAtIndex:i] resourceStatusId]]];
//                    }
//                }
//                //end
//                [self.resourceListTableview reloadData];
            });
        } onfailure:^(id error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
                if ([[error objectForKey:@"success"] isEqualToString:@"2"]) {
                    alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Something went wrong, Please try again." doneButtonText:@"OK" cancelButtonText:@""];
                }
            });
        }];
    }
}
#pragma mark - end

#pragma mark - Tableview methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * headerView;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width,50.0)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont handseanWithSize:17];
    label.text = @"Book resource by filling up below form.";
    [headerView addSubview:label];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return inputFieldTitleArray.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row!=inputFieldTitleArray.count) {
        return 88.0;
    }
    else {
        return 60.0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BookResourceCell *cell;
    if (indexPath.row!=inputFieldTitleArray.count) {
        NSString *simpleTableIdentifier = @"BookResourceInputCell";
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[BookResourceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        [cell displayData:[inputFieldTitleArray mutableCopy] index:(int)indexPath.row];
    }
    else {
        NSString *simpleTableIdentifier = @"BookResourceButtonCell";
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[BookResourceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        [cell displayData:[inputFieldTitleArray mutableCopy] index:(int)indexPath.row];
    }
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    ResourceDetailViewController *objresourceDetail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ResourceDetailViewController"];
//    if (isSearch) {
//        objresourceDetail.resourceDetailData=[resourceSearchDataArray objectAtIndex:indexPath.row];
//    }
//    else {
//        objresourceDetail.resourceDetailData=[resourceDataArray objectAtIndex:indexPath.row];
//    }
//    [self.navigationController pushViewController:objresourceDetail animated:YES];
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
