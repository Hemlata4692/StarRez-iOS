//
//  SidebarViewController.m
//  SidebarDemoApp
//
//  Created by Ranosys on 06/02/15.
//  Copyright (c) 2015 Shivendra. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "UIImage+deviceSpecificMedia.h"
#import "LoginModel.h"
#import "Internet.h"

@interface SidebarViewController ()<CustomAlertDelegate>{
    
    CustomAlert *alertView;
    NSArray *menuItems;
    UIColor *labelColor;
    
    NSArray *unselectedItems;
    NSArray *selectedItems;
}

@property (strong, nonatomic) IBOutlet UITableView *sideBarTable;
@end

@implementation SidebarViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuItems = [[NSArray alloc]init];
    labelColor= [UIColor colorWithRed:120./255.0 green:42.0/255.0 blue:147.0/255.0 alpha:1.0];
//    menuItems = @[@"Dashboard", @"Parcel",@"Logout"];
     menuItems = @[@"Dashboard", @"Maintenance", @"Parcel", @"Resources", @"Events",@"Information", @"Help",@"Logout"];
    unselectedItems =@[@"dashboardUnselected",@"maintenanceUnselected",@"parcelUnselected",@"resourcesUnselected",@"eventsUnselected",@"informationUnselected",@"helpUnselected",@"logoutUnselected"];
    selectedItems =@[@"dashboardSelected",@"maintenanceSelected",@"parcelSelected",@"resourcesSelected",@"eventsSelected",@"informationSelected",@"helpSelected",@"logoutSelected"];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
}
#pragma mark - end

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return menuItems.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 120)];
    headerView.backgroundColor=[UIColor whiteColor];
    // i.e. array element
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake((headerView.frame.size.width/2)-80, 10, 160, 50)] ;
    imgView.contentMode=UIViewContentModeScaleAspectFit;
    imgView.clipsToBounds=YES;
    imgView.image=[UIImage imageNamed:@"loginLogo"];
    [headerView addSubview:imgView];
    return headerView;   // return headerLabel;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier=[menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Set selection color for cell.
    UIView *bgColorView=[[UIView alloc] init];
    bgColorView.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    [cell setSelectedBackgroundView:bgColorView];
    
    //Add left layer for selected cell.
    UILabel * cellLbl = (UILabel *)[cell.contentView viewWithTag:1];
    UIImageView * cellImage = (UIImageView *)[cell.contentView viewWithTag:21];
    
    if ([[UserDefaultManager getValue:@"indexpath"]integerValue]==indexPath.row) {
        DLog(@"index is %ld",(long)[[UserDefaultManager getValue:@"indexpath"]integerValue]);
        cellImage.image = [UIImage imageNamed:[selectedItems objectAtIndex:indexPath.row]];
        cellLbl.textColor = labelColor;
        CGRect frameL;
        frameL.origin.x = 0;
        frameL.origin.y = 0;
        frameL.size.height = 61;
        frameL.size.width = 3;
        UIButton *AlertNameLHS = [[UIButton alloc] initWithFrame:frameL];
        AlertNameLHS.backgroundColor=labelColor;
        [cell.contentView addSubview:AlertNameLHS];
        
        CAGradientLayer* gr = [CAGradientLayer layer];
        gr.frame = AlertNameLHS.frame;
        gr.colors = [NSArray arrayWithObjects:
                     (id)labelColor.CGColor
                     ,(id)labelColor.CGColor
                     , nil];
        gr.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:1],nil];
        
        [AlertNameLHS.layer insertSublayer:gr atIndex:0];
        [cell.contentView bringSubviewToFront:AlertNameLHS];
    }
    else {
        cellImage.image = [UIImage imageNamed:[unselectedItems objectAtIndex:indexPath.row]];
        cellLbl.textColor = [UIColor colorWithRed:84.0/255.0 green:84.0/255.0 blue:84.0/255.0 alpha:1.0];
        for (UIView *subview in [cell.contentView subviews]) {
            if ([subview isKindOfClass:[UIButton class]]) {
                [subview removeFromSuperview];
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row!=7) { //Not clicked on logout button
        [UserDefaultManager setValue:[NSNumber numberWithInteger:indexPath.row] key:@"indexpath"];
    }
    if (indexPath.row==7) {
        alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Are you sure you want to logout?" doneButtonText:@"Yes" cancelButtonText:@"No"];
    }
    else if (indexPath.row==4) {
        [UserDefaultManager setValue:@"Event" key:@"ScreenName"];
    }
    else if (indexPath.row==5) {
        [UserDefaultManager setValue:@"Information" key:@"ScreenName"];
    }
    else if (indexPath.row==6) {
        [UserDefaultManager setValue:@"Help" key:@"ScreenName"];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([[UserDefaultManager getValue:@"indexpath"]integerValue]==indexPath.row) {
        [cell setSelected:YES animated:NO];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    return YES;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
}

#pragma mark - Custom alert delegates
- (void)customAlertDelegateAction:(CustomAlertView *)customAlert option:(int)option{
    
    [alertView dismissAlertView];
    if (option!=0) {
        
        //Nil all userdefaultData and navigate to login screen
        [UserDefaultManager setValue:nil key:@"indexpath"];
        [UserDefaultManager setValue:nil key:@"userEmailId"];
        [UserDefaultManager setValue:nil key:@"entryId"];
        [myDelegate unrigisterForNotification];
        
        UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
        myDelegate.window.rootViewController = navigation;
    }
}
#pragma mark - end
@end
