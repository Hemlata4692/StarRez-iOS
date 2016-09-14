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
}

@property (strong, nonatomic) IBOutlet UITableView *sideBarTable;

@end

@implementation SidebarViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    menuItems = [[NSArray alloc]init];
    menuItems = @[@"Dashboard", @"Maintenance", @"Parcel", @"Resources", @"Events",@"Information", @"Help",@"Logout"];
//    //set background image
//    UIGraphicsBeginImageContext(self.tableView.frame.size);
//    [[UIImage imageNamed:@"bg"] drawInRect:self.tableView.bounds];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[image imageForDeviceWithName:@"bg"]]];
//    backgroundImage.frame = self.tableView.frame;
//    [self.tableView setBackgroundView:backgroundImage];
    
    [self.tableView setSeparatorColor:[UIColor colorWithRed:83.0/255.0 green:94.0/255.0 blue:114.0/255.0 alpha:1.0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return menuItems.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 140)];
    headerView.backgroundColor=[UIColor clearColor];
    // i.e. array element
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 25, 84, 84)] ;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    imgView.image=[UIImage imageNamed:@"sidebarlogo"];
    imgView.layer.cornerRadius = imgView.frame.size.width / 2;
    [headerView addSubview:imgView];
    return headerView;   // return headerLabel;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100.0;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{

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
