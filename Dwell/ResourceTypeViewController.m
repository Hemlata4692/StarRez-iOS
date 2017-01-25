//
//  ResourceTypeViewController.m
//  Dwell
//
//  Created by Ranosys on 24/01/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

#import "ResourceTypeViewController.h"
#import "ResourceModel.h"
#import "ResourceModel.h"
#import "ResourceTypeCell.h"
#import "SelectedResourceViewController.h"

@interface ResourceTypeViewController ()<CustomAlertDelegate> {
    
    CustomAlert *alertView;
}
@property (strong, nonatomic) IBOutlet UITableView *resourceNameTableView;
@end

@implementation ResourceTypeViewController
@synthesize resourceNameListArray;
@synthesize resourceNameFromDate;
@synthesize resourceNameToDate;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Book a Resource";
    [super addBackgroungImage:@"Resource"];
    [self.resourceNameTableView reloadData];
//    resourceData.resourceTypeLocationId=[[bookResourceLocationArray objectAtIndex:lastSelectedResourceLocation] resourceTypeLocationId];
//    str=[[bookResourceLocationArray objectAtIndex:row] resourceLocationDescription];
    
//    [myDelegate showIndicator:[Constants navigationColor]];
//    [self performSelector:@selector(getResourcesTypeList) withObject:nil afterDelay:.1];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Webservice
////Get resource type list webservice
//- (void)getResourcesTypeList {
//    
//    bookResourceTypeArray=[NSMutableArray new];
//    bookResourceLocationArray=[NSMutableArray new];
//    if ([super checkInternetConnection]) {
//        ResourceModel *resourceData=[ResourceModel sharedUser];
//        [resourceData getSelectedResourceDetailOnSuccess:^(id resourceTypeData) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [myDelegate stopIndicator];
//                bookResourceTypeArray=[resourceTypeData mutableCopy];
//            });
//        } onfailure:^(id error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [myDelegate stopIndicator];
//                if ([[error objectForKey:@"success"] isEqualToString:@"2"]) {
//                    alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:5 delegate:self message:@"Something went wrong, Please try again." doneButtonText:@"Retry" cancelButtonText:@""];
//                }
//                else {
//                    alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"There is not any resource type available yet." doneButtonText:@"OK" cancelButtonText:@""];
//                }
//            });
//        }];
//    }
//    else {
//        [myDelegate stopIndicator];
//    }
//}
#pragma mark - end

#pragma mark - Tableview methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return resourceNameListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ResourceTypeCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"ResourceNameCell"];
    if (cell == nil) {
        cell = [[ResourceTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ResourceNameCell"];
    }
    [cell displayResourceName:[[resourceNameListArray objectAtIndex:indexPath.row] resourceLocationDescription]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    SelectedResourceViewController *objResourceName = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectedResourceViewController"];
    objResourceName.selectedResourceNameId=[[resourceNameListArray objectAtIndex:indexPath.row] resourceTypeLocationId];
    objResourceName.selectedResourceName=[[resourceNameListArray objectAtIndex:indexPath.row] resourceLocationDescription];
    objResourceName.resourceNameFromDate=resourceNameFromDate;
    objResourceName.resourceNameToDate=resourceNameToDate;
    [self.navigationController pushViewController:objResourceName animated:YES];
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
