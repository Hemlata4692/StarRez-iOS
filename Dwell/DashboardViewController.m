//
//  DashboardViewController.m
//  Dwell
//
//  Created by Shiven on 14/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "DashboardViewController.h"
#import "DashboardTableViewCell.h"
#import "MaintenanceModel.h"
#import "ParcelModel.h"

#define kCellsPerRow 4  //Set columns in per rows

@interface DashboardViewController ()<CustomAlertDelegate>{
    
    CustomAlert *alertView;
    NSArray *menuArray, *upMenuArray, *downMenuArray;
    NSArray *menuImageArray, *upMenuImageArray, *downMenuImageArray;
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
        [self.navigationController pushViewController:profileView animated:YES];
        return;
    }
    self.navigationItem.title=@"Dashboard";
    //Set intiallize variables
    [self intiallizeValue];
    //View customisations
    [self removeAutolayout];
    [self viewCustomization];
    
    [self.dashboardTableView reloadData];
//     [myDelegate showIndicator:[Constants oldDashboardColor]];
    [myDelegate showIndicator:[Constants navigationColor]];
    [self performSelector:@selector(checkRoomSpaceId) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - View customization
- (void)intiallizeValue {

    self.noRecordFoundLabel.hidden=YES;
    [super addBackgroungImage:@"Dashboard"];
    [UserDefaultManager setValue:[NSNumber numberWithInteger:0] key:@"indexpath"];
    //Menu label at down menu
    downMenuArray=@[@"Maintenance",@"Parcel",@"Resources",@"More",@"Events",@"Information",@"Help",@"Logout"];
    //Menu image at down menu
    downMenuImageArray =@[@"maintenance",@"parcel",@"resources",@"more",@"events",@"information",@"help",@"logoutDashboard"];
    //Menu label at up menu
    upMenuArray=@[@"Maintenance",@"Parcel",@"Resources",@"Less",@"Events",@"Information",@"Help",@"Logout"];
    //Menu image at up menu
    upMenuImageArray =@[@"maintenance",@"parcel",@"resources",@"downMenu",@"events",@"information",@"help",@"logoutDashboard"];
    
    menuArray=[downMenuArray copy];
    menuImageArray =[downMenuImageArray copy];
    
    //Set swipe variable initial state
    isSwipeDown=YES;//Initially already swaped down
}

- (void)removeAutolayout {
    
    //Remove autolayout
    self.menuCollectionView.translatesAutoresizingMaskIntoConstraints=YES;
    self.dashboardTableView.translatesAutoresizingMaskIntoConstraints=YES;
    DLog(@"%f,%f,%f",self.view.bounds.size.height,self.menuCollectionView.frame.size.height,self.menuCollectionView.bounds.size.height);
    //Set view frames
    self.menuCollectionView.frame=CGRectMake(0,(self.view.bounds.size.height)-(self.menuCollectionView.frame.size.height/2), self.view.bounds.size.width, self.menuCollectionView.frame.size.height);
    self.dashboardTableView.frame=CGRectMake(0,64, self.view.bounds.size.width,(self.view.bounds.size.height)-(self.menuCollectionView.frame.size.height/2)-72);//here 64(navigation height)+8(space b/w table view and collection view)=72
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)];
    headerView.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.8];
    // i.e. array element
    UILabel *userNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, [[UIScreen mainScreen] bounds].size.width-30, headerView.frame.size.height-10)] ;
    userNameLabel.text=[UserDefaultManager getValue:@"userName"];
//    userNameLabel.text=@"Hello rohit kumar modi and sunny and raja ram rohit kumar modi and sunny and raja ram";
    userNameLabel.textAlignment=NSTextAlignmentCenter;
    userNameLabel.textColor=[UIColor colorWithRed:68.0/255 green:68.0/255.0 blue:68.0/255.0 alpha:1.0];
    userNameLabel.font=[UIFont calibriNormalWithSize:14];
     userNameLabel.numberOfLines=0;
    [headerView addSubview:userNameLabel];
    return headerView;   // return headerLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dashboardDictKeys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (dashboardDictKeys.count==2) {   //If maintenance and parcel both items exist
        if (indexPath.row==0) {
            if ([[dashboardDictData objectForKey:@"Maintenance"] count]==0) {
                return 120.0;
            }
            else {
                return 60.0+([[dashboardDictData objectForKey:@"Maintenance"] count]*60.0);
            }
        }
        else {
            if ([[dashboardDictData objectForKey:@"Parcel"] count]==0) {
                return 120.0;
            }
            else {
                return 60.0+([[dashboardDictData objectForKey:@"Parcel"] count]*60.0);
            }
        }
//    }
//    else if([[dashboardDictKeys objectAtIndex:indexPath.row] isEqualToString:@"Maintenance"]) {     //If maintenance items exist
//        return 60.0+([[dashboardDictData objectForKey:@"Maintenance"] count]*60.0);
//    }
//    else if([[dashboardDictKeys objectAtIndex:indexPath.row] isEqualToString:@"Parcel"]) {      //If parcel items exist
//        return 60.0+([[dashboardDictData objectForKey:@"Parcel"] count]*60.0);
//    }
//    else {
//        return 0.0;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DashboardTableViewCell *cell;
    NSString *simpleTableIdentifier=@"DashboardCell";
    cell=[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell==nil) {
        cell = [[DashboardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
//    if (dashboardDictKeys.count==2) {
        if (indexPath.row==0) {
            [cell displayData:[dashboardDictData objectForKey:@"Maintenance"] selectedType:1];
        }
        else {
            [cell displayData:[dashboardDictData objectForKey:@"Parcel"] selectedType:2];
        }
//    }
//    else if([[dashboardDictKeys objectAtIndex:indexPath.row] isEqualToString:@"Maintenance"]) {
//        [cell displayData:[dashboardDictData objectForKey:@"Maintenance"] selectedType:1];
//    }
//    else if([[dashboardDictKeys objectAtIndex:indexPath.row] isEqualToString:@"Parcel"]) {
//        [cell displayData:[dashboardDictData objectForKey:@"Parcel"] selectedType:2];
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (dashboardDictKeys.count==2) {   //If maintenance and parcel both items exist
        if (indexPath.row==0) {
            UIViewController *objMaintenanceView=[self.storyboard instantiateViewControllerWithIdentifier:@"MaintenanceListViewController"];
            [self.navigationController pushViewController:objMaintenanceView animated:NO];
        }
        else {
            UIViewController *objParcelView=[self.storyboard instantiateViewControllerWithIdentifier:@"ParcelListViewController"];
            [self.navigationController pushViewController:objParcelView animated:NO];
        }
//    }
//    else if([[dashboardDictKeys objectAtIndex:indexPath.row] isEqualToString:@"Maintenance"]) {     //If maintenance items exist
//        UIViewController *objMaintenanceView=[self.storyboard instantiateViewControllerWithIdentifier:@"MaintenanceListViewController"];
//        [self.navigationController pushViewController:objMaintenanceView animated:NO];
//    }
//    else if([[dashboardDictKeys objectAtIndex:indexPath.row] isEqualToString:@"Parcel"]) {      //If parcel items exist
//        UIViewController *objParcelView=[self.storyboard instantiateViewControllerWithIdentifier:@"ParcelListViewController"];
//        [self.navigationController pushViewController:objParcelView animated:NO];
//    }
}
#pragma mark - end

#pragma mark - Collection view methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return menuArray.count;
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
                menuArray=[upMenuArray copy];
                menuImageArray =[upMenuImageArray copy];
                [self swipeUp];
            }
            else {
                menuArray=[downMenuArray copy];
                menuImageArray =[downMenuImageArray copy];
                [self swipeDown];
            }
            [self.menuCollectionView reloadData];
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
        case 7: {   //Clicked on logout menu
            alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Are you sure you want to logout?" doneButtonText:@"Yes" cancelButtonText:@"No"];
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
    self.dashboardTableView.frame=CGRectMake(0,64, self.view.bounds.size.width,self.view.bounds.size.height-(self.menuCollectionView.bounds.size.height/2)-72);//here 64(navigation height)+8(space b/w table view and collection view)=72
    [UIView commitAnimations];
}

- (void)swipeUp {
    
    //View animation to up
    isSwipeDown = NO;
    [UIView beginAnimations:@"animationOff" context:NULL];
    [UIView setAnimationDuration:0.5f];
    self.menuCollectionView.frame=CGRectMake(0,self.view.bounds.size.height-self.menuCollectionView.frame.size.height, self.view.bounds.size.width, self.menuCollectionView.frame.size.height);
    self.dashboardTableView.frame=CGRectMake(0,64, self.view.bounds.size.width,self.view.bounds.size.height-self.menuCollectionView.frame.size.height-72);//here 64(navigation height)+8(space b/w table view and collection view)=72
    [UIView commitAnimations];
}
#pragma mark - end

#pragma mark - Webservice
//Check room space id is exist
- (void)checkRoomSpaceId {

    dashboardDictData=[NSMutableDictionary new];
    dashboardDictKeys=[NSMutableArray new];
    if ([super checkInternetConnection]) {
        MaintenanceModel *mainatenanceData = [MaintenanceModel sharedUser];
        [mainatenanceData checkRoomSpaceOnSuccess:^(id userData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self performSelector:@selector(getDashboardlist) withObject:nil afterDelay:0.0];
            });
        } onfailure:^(id error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[error objectForKey:@"success"] isEqualToString:@"0"]) {
                    DLog(@"No maintenance record found.");
                    [dashboardDictData setValue:[NSMutableArray new] forKey:@"Maintenance"];
                    [dashboardDictKeys addObject:@"Maintenance"];
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

//Get maintenance list
- (void)getDashboardlist {
    
    if ([super checkInternetConnection]) {
        MaintenanceModel *mainatenanceData = [MaintenanceModel sharedUser];
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
                [dashboardDictData setValue:[tempMaintenanceArray mutableCopy] forKey:@"Maintenance"];
                [dashboardDictKeys addObject:@"Maintenance"];
                [self performSelector:@selector(callParcelList) withObject:nil afterDelay:0.0];
            });
        } onfailure:^(id error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[error objectForKey:@"success"] isEqualToString:@"0"]) {
                    DLog(@"No maintenance record found.");
                    [dashboardDictData setValue:[NSMutableArray new] forKey:@"Maintenance"];
                    [dashboardDictKeys addObject:@"Maintenance"];
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
                
                [dashboardDictKeys addObject:@"Parcel"];
                [dashboardDictData setValue:[NSMutableArray new] forKey:@"Parcel"];
                DLog(@"No record found.");
                [self.dashboardTableView reloadData];
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
- (void)customAlertDelegateAction:(CustomAlertView *)customAlert option:(int)option{
    if (option!=0 && customAlert.tag==2) {
        //Nil all userdefaultData and navigate to login screen
        [UserDefaultManager setValue:nil key:@"indexpath"];
        [UserDefaultManager setValue:nil key:@"userEmailId"];
        [UserDefaultManager setValue:nil key:@"entryId"];
        [myDelegate unrigisterForNotification];
        
        UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
        myDelegate.window.rootViewController = navigation;
    }
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
