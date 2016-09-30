//
//  DashboardViewController.m
//  Dwell
//
//  Created by Shiven on 14/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "DashboardViewController.h"
#import "DashboardTableViewCell.h"
#import "MainatenanceModel.h"
#import "ParcelModel.h"

#define kCellsPerRow 4  //Set columns in per rows

@interface DashboardViewController ()<CustomAlertDelegate>{
    
    CustomAlert *alertView;
    NSArray *menuArray;
    NSArray *menuImageArray;
    BOOL isSwipeDown;
    NSMutableArray *dashboardDictKeys;
    NSMutableDictionary *dashboardDictData;
}
@property (weak, nonatomic) IBOutlet UITableView *dashboardTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *menuCollectionView;
@property (strong, nonatomic) IBOutlet UILabel *noRecordFoundLabel;
@end

@implementation DashboardViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Navigate to a screen according to push notification
    if ([[myDelegate.notificationDict objectForKey:@"isNotification"] isEqualToString:@"Yes"]) {
        [myDelegate.notificationDict setObject:@"No" forKey:@"isNotification"];
        UIViewController *profileView=[self.storyboard instantiateViewControllerWithIdentifier:[myDelegate.notificationDict objectForKey:@"toScreen"]];
        [self.navigationController pushViewController:profileView animated:NO];
        return;
    }
    self.navigationItem.title=@"Dashboard";
    //Set intiallize variables
    [self intiallizeValue];
    //View customisations
    [self removeAutolayout];
    [self viewCustomization];
    
     [myDelegate showIndicator:[Constants navigationColor]];
    [self performSelector:@selector(getDashboardlist) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - View customization
- (void)intiallizeValue {

    self.noRecordFoundLabel.hidden=YES;
    [UserDefaultManager setValue:[NSNumber numberWithInteger:0] key:@"indexpath"];
    //Menu label items
    menuArray=@[@"Maintenance",@"Parcel",@"Resources",@"Less",@"Event",@"Information",@"Help"];
     //Menu imageView items
    menuImageArray =@[@"maintenance",@"parcel",@"resources",@"downMenu",@"events",@"information",@"help"];
    //Set swipe variable initial state
    isSwipeDown=YES;//Initially already swaped down
}

- (void)removeAutolayout {
    
    //Remove autolayout
    self.menuCollectionView.translatesAutoresizingMaskIntoConstraints=YES;
    self.dashboardTableView.translatesAutoresizingMaskIntoConstraints=YES;
    DLog(@"%f,%f,%f",self.view.bounds.size.height,self.menuCollectionView.frame.size.height,self.menuCollectionView.bounds.size.height);
    //Set view frames
    self.menuCollectionView.frame=CGRectMake(0,(self.view.bounds.size.height-64)-(self.menuCollectionView.frame.size.height/2), self.view.bounds.size.width, self.menuCollectionView.frame.size.height);
    self.dashboardTableView.frame=CGRectMake(0,0, self.view.bounds.size.width,(self.view.bounds.size.height-64)-(self.menuCollectionView.frame.size.height/2)-5);
}

- (void)viewCustomization {
    
    //Set 4 cells per row in collection view
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.menuCollectionView.collectionViewLayout;
    CGFloat availableWidthForCells=CGRectGetWidth(self.menuCollectionView.frame)-flowLayout.sectionInset.left - flowLayout.sectionInset.right-flowLayout.minimumInteritemSpacing * (kCellsPerRow -1);
    CGFloat cellWidth=(availableWidthForCells/kCellsPerRow);
    flowLayout.itemSize = CGSizeMake(cellWidth, flowLayout.itemSize.height);
}
#pragma mark - end

#pragma mark - Tableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dashboardDictKeys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (dashboardDictKeys.count==2) {   //If maintenance and parcel both items exist
        if (indexPath.row==0) {
            return 60.0+([[dashboardDictData objectForKey:@"Maintenence"] count]*60.0);
        }
        else {
            return 60.0+([[dashboardDictData objectForKey:@"Parcel"] count]*60.0);
        }
    }
    else if([[dashboardDictKeys objectAtIndex:indexPath.row] isEqualToString:@"Maintenence"]) {     //If maintenance items exist
        return 60.0+([[dashboardDictData objectForKey:@"Maintenence"] count]*60.0);
    }
    else if([[dashboardDictKeys objectAtIndex:indexPath.row] isEqualToString:@"Parcel"]) {      //If parcel items exist
        return 60.0+([[dashboardDictData objectForKey:@"Parcel"] count]*60.0);
    }
    else {
        return 0.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DashboardTableViewCell *cell;
    NSString *simpleTableIdentifier=@"DashboardCell";
    cell=[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell==nil) {
        cell = [[DashboardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (dashboardDictKeys.count==2) {
        if (indexPath.row==0) {
            [cell displayData:[dashboardDictData objectForKey:@"Maintenence"] selectedType:1];
        }
        else {
            [cell displayData:[dashboardDictData objectForKey:@"Parcel"] selectedType:2];
        }
    }
    else if([[dashboardDictKeys objectAtIndex:indexPath.row] isEqualToString:@"Maintenence"]) {
        [cell displayData:[dashboardDictData objectForKey:@"Maintenence"] selectedType:1];
    }
    else if([[dashboardDictKeys objectAtIndex:indexPath.row] isEqualToString:@"Parcel"]) {
        [cell displayData:[dashboardDictData objectForKey:@"Parcel"] selectedType:2];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (dashboardDictKeys.count==2) {   //If maintenance and parcel both items exist
        if (indexPath.row==0) {
            UIViewController *objMaintenanceView=[self.storyboard instantiateViewControllerWithIdentifier:@"MaintenanceListViewController"];
            [self.navigationController pushViewController:objMaintenanceView animated:NO];
        }
        else {
            UIViewController *objParcelView=[self.storyboard instantiateViewControllerWithIdentifier:@"ParcelListViewController"];
            [self.navigationController pushViewController:objParcelView animated:NO];
        }
    }
    else if([[dashboardDictKeys objectAtIndex:indexPath.row] isEqualToString:@"Maintenence"]) {     //If maintenance items exist
        UIViewController *objMaintenanceView=[self.storyboard instantiateViewControllerWithIdentifier:@"MaintenanceListViewController"];
        [self.navigationController pushViewController:objMaintenanceView animated:NO];
    }
    else if([[dashboardDictKeys objectAtIndex:indexPath.row] isEqualToString:@"Parcel"]) {      //If parcel items exist
        UIViewController *objParcelView=[self.storyboard instantiateViewControllerWithIdentifier:@"ParcelListViewController"];
        [self.navigationController pushViewController:objParcelView animated:NO];
    }
}
#pragma mark - end

#pragma mark - Collection view methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *menuCell=[collectionView
                                      dequeueReusableCellWithReuseIdentifier:@"menuCell"
                                      forIndexPath:indexPath];
    //Display menu view items
    UILabel *menuLabel=(UILabel *)[menuCell viewWithTag:1];
    menuLabel.text=[menuArray objectAtIndex:indexPath.row];
    UIImageView *menuImage=(UIImageView *)[menuCell viewWithTag:2];
    menuImage.image = [UIImage imageNamed:[menuImageArray objectAtIndex:indexPath.row]];
    return menuCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0: {   //Clicked on maintenance menu
            UIViewController *objMaintenanceView=[self.storyboard instantiateViewControllerWithIdentifier:@"MaintenanceListViewController"];
            [self.navigationController pushViewController:objMaintenanceView animated:NO];
        }
            break;
        case 1: {   //Clicked on parcel menu
            UIViewController *objParcelView=[self.storyboard instantiateViewControllerWithIdentifier:@"ParcelListViewController"];
            [self.navigationController pushViewController:objParcelView animated:NO];
        }
            break;
        case 2: {   //Clicked on resource menu
            UIViewController *objResourceView=[self.storyboard instantiateViewControllerWithIdentifier:@"ResourceListViewController"];
            [self.navigationController pushViewController:objResourceView animated:NO];
        }
            break;
        case 3:     //Clicked on cross or arrow sign
            if (isSwipeDown) {
                [self swipeUp];
            }
            else {
                [self swipeDown];
            }
            break;
        case 4: {   //Clicked on event menu
            [UserDefaultManager setValue:@"Event" key:@"ScreenName"];
            UIViewController *objResourceView=[self.storyboard instantiateViewControllerWithIdentifier:@"InformationViewController"];
            [self.navigationController pushViewController:objResourceView animated:NO];
        }
            break;
        case 5: {   //Clicked on information menu
            [UserDefaultManager setValue:@"Information" key:@"ScreenName"];
            UIViewController *objResourceView=[self.storyboard instantiateViewControllerWithIdentifier:@"InformationViewController"];
            [self.navigationController pushViewController:objResourceView animated:NO];
        }
            break;
        case 6: {   //Clicked on help menu
            [UserDefaultManager setValue:@"Help" key:@"ScreenName"];
            UIViewController *objResourceView=[self.storyboard instantiateViewControllerWithIdentifier:@"InformationViewController"];
            [self.navigationController pushViewController:objResourceView animated:NO];
        }
            break;
        default:
            break;
    }
}
#pragma mark - end

#pragma mark - Swipe animations in menu view
- (void)swipeDown {
    
    //View animation to down
    isSwipeDown = YES;
    [UIView beginAnimations:@"animationOff" context:NULL];
    [UIView setAnimationDuration:0.5f];
    self.menuCollectionView.frame=CGRectMake(0,self.view.bounds.size.height-(self.menuCollectionView.frame.size.height/2), self.view.bounds.size.width, self.menuCollectionView.frame.size.height);
    self.dashboardTableView.frame=CGRectMake(0,0, self.view.bounds.size.width,self.view.bounds.size.height-(self.menuCollectionView.bounds.size.height/2)-5);
    [UIView commitAnimations];
}

- (void)swipeUp {
    
    //View animation to up
    isSwipeDown = NO;
    [UIView beginAnimations:@"animationOff" context:NULL];
    [UIView setAnimationDuration:0.5f];
    self.menuCollectionView.frame=CGRectMake(0,self.view.bounds.size.height-self.menuCollectionView.frame.size.height, self.view.bounds.size.width, self.menuCollectionView.frame.size.height);
    self.dashboardTableView.frame=CGRectMake(0,0, self.view.bounds.size.width,self.view.bounds.size.height-self.menuCollectionView.frame.size.height-5);
//    //For table scrolling to end
//    CGPoint offset = CGPointMake(0, self.dashboardTableView.contentSize.height-self.dashboardTableView.frame.size.height);
//    [self.dashboardTableView setContentOffset:offset animated:YES];
    [UIView commitAnimations];
}
#pragma mark - end

#pragma mark - Webservice
//Get maintenance list
- (void)getDashboardlist {
    
    dashboardDictData=[NSMutableDictionary new];
    dashboardDictKeys=[NSMutableArray new];
    if ([super checkInternetConnection]) {
        MainatenanceModel *mainatenanceData = [MainatenanceModel sharedUser];
        [mainatenanceData getMaintenanceListOnSuccess:^(id userData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableArray *tempMaintenanceArray=[NSMutableArray new];
                //Get top 3 items from list
                if ([userData count]>3) {    //if count of maintenance list is greater then 3
                    for (int i=0; i<3; i++) {
                        [tempMaintenanceArray addObject:[userData objectAtIndex:i]];
                    }
                }
                else {
                    for (int i=0; i<[userData count]; i++) {
                        [tempMaintenanceArray addObject:[userData objectAtIndex:i]];
                    }
                }
                [dashboardDictData setValue:[tempMaintenanceArray mutableCopy] forKey:@"Maintenence"];
                [dashboardDictKeys addObject:@"Maintenence"];
                [self performSelector:@selector(callParcelList) withObject:nil afterDelay:0.0];
            });
        } onfailure:^(id error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[error objectForKey:@"success"] isEqualToString:@"0"]) {
                    DLog(@"No maintenance record found.");
                    [self performSelector:@selector(callParcelList) withObject:nil afterDelay:0.0];
                }
                else {
                    [myDelegate stopIndicator];
                    [dashboardDictData removeAllObjects];
                    [dashboardDictKeys removeAllObjects];
                    alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Something went wrong, Please try again." doneButtonText:@"OK" cancelButtonText:@""];
                }
            });
        }];
    }
    else {
        [myDelegate stopIndicator];
    }
}

//Get parcel list
- (void)callParcelList {
    
    ParcelModel *parcelData = [ParcelModel sharedUser];
    [parcelData getParcelListOnSuccess:^(id userData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate stopIndicator];
            NSMutableArray *tempParcelArray=[NSMutableArray new];
            //Get top 3 items from list
            if ([userData count]>3) {   //if count of parcel list is greater then 3
                for (int i=0; i<3; i++) {
                    [tempParcelArray addObject:[userData objectAtIndex:i]];
                }
            }
            else {
                for (int i=0; i<[userData count]; i++) {
                    [tempParcelArray addObject:[userData objectAtIndex:i]];
                }
            }
            [dashboardDictKeys addObject:@"Parcel"];
            [dashboardDictData setValue:[tempParcelArray mutableCopy] forKey:@"Parcel"];
            [self.dashboardTableView reloadData];
        });
    } onfailure:^(id error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate stopIndicator];
            if ([[error objectForKey:@"success"] isEqualToString:@"0"]) {
                DLog(@"No record found.");
                if (dashboardDictKeys.count==0) {
                    self.noRecordFoundLabel.hidden=NO;
                }
                else {
                    [self.dashboardTableView reloadData];
                }
            }
            else {
                [dashboardDictData removeAllObjects];
                [dashboardDictKeys removeAllObjects];
                alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Something went wrong, Please try again." doneButtonText:@"OK" cancelButtonText:@""];
            }
        });
    }];
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
