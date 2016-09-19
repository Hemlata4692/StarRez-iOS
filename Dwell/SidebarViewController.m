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


@interface SidebarViewController (){
    NSArray *menuItems;
    NSArray *labelColor;
}

@property (strong, nonatomic) IBOutlet UITableView *sideBarTable;

@end

@implementation SidebarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuItems = [[NSArray alloc]init];
    labelColor= [[NSArray alloc]init];
    menuItems = @[@"Dashboard", @"Parcel",@"Logout"];
    labelColor= @[[Constants dashboardColor],[Constants parcelColor]];
    // menuItems = @[@"Dashboard", @"Maintenance", @"Parcel", @"Resources", @"Events",@"Information", @"Help",@"Logout"];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return menuItems.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 140)];
    headerView.backgroundColor=[UIColor whiteColor];
    // i.e. array element
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 84, 84)] ;
    imgView.contentMode=UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds=YES;
    imgView.image=[UIImage imageNamed:@"sidebarlogo"];
    imgView.layer.cornerRadius=imgView.frame.size.width / 2;
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
    if ([[UserDefaultManager getValue:@"indexpath"]integerValue]==indexPath.row) {
        DLog(@"index is %ld",(long)[[UserDefaultManager getValue:@"indexpath"]integerValue]);
        CGRect frameL;
        frameL.origin.x = 0;
        frameL.origin.y = 0;
        frameL.size.height = 61;
        frameL.size.width = 5;
        UIButton *AlertNameLHS = [[UIButton alloc] initWithFrame:frameL];
        AlertNameLHS.backgroundColor=[labelColor objectAtIndex:indexPath.row];
        [cell.contentView addSubview:AlertNameLHS];
        
        CAGradientLayer* gr = [CAGradientLayer layer];
        gr.frame = AlertNameLHS.frame;
        gr.colors = [NSArray arrayWithObjects:
                     (id)[[labelColor objectAtIndex:indexPath.row] CGColor]
                     ,(id)[[labelColor objectAtIndex:indexPath.row] CGColor]
                     , nil];
        gr.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:1],nil];
        
        [AlertNameLHS.layer insertSublayer:gr atIndex:0];
        [cell.contentView bringSubviewToFront:AlertNameLHS];
    }
    else {
        for (UIView *subview in [cell.contentView subviews]) {
            if ([subview isKindOfClass:[UIButton class]]) {
                [subview removeFromSuperview];
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 100.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [UserDefaultManager setValue:[NSNumber numberWithInteger:indexPath.row] key:@"indexpath"];
    if (indexPath.row==2) {
        [UserDefaultManager setValue:nil key:@"indexpath"];
        [UserDefaultManager setValue:nil key:@"userEmailId"];
        [UserDefaultManager setValue:nil key:@"entryId"];
        [myDelegate unrigisterForNotification];
        
        UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
        myDelegate.window.rootViewController = navigation;
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
    
    //    if (![[UserDefaultManager getValue:@"isDriverProfileCompleted"] isEqualToString:@"True"])
    //    {
    //        return NO;
    //    }
    //    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //    if (indexPath.row == 11||indexPath.row == 10||indexPath.row == 9||indexPath.row == 6||indexPath.row == 4|| indexPath.row == 8||indexPath.row == 3|| indexPath.row == 7| indexPath.row == 5||indexPath.row == 12)
    //    {
    //        return NO;
    //    }
    
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
}
@end
