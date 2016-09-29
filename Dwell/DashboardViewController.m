//
//  DashboardViewController.m
//  Dwell
//
//  Created by Shiven on 14/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "DashboardViewController.h"
#import "DashboardTableViewCell.h"
#define kCellsPerRow 4  //Set columns in per rows

@interface DashboardViewController (){
    
    NSArray *menuArray;
    NSArray *menuImageArray;
    BOOL isSwipeDown;
}
@property (weak, nonatomic) IBOutlet UITableView *dashboardTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *menuCollectionView;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - View customization
- (void)intiallizeValue {

    [UserDefaultManager setValue:[NSNumber numberWithInteger:0] key:@"indexpath"];
    //Menu view items
    menuArray=@[@"Maintenance",@"Parcel",@"Resources",@"Less",@"Event",@"Information",@"Help"];
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
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DashboardTableViewCell *cell;
    NSString *simpleTableIdentifier=@"DashboardCell";
    cell=[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell==nil) {
        cell = [[DashboardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    return cell;
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
        case 3: //Clicked on cross or arrow sign
            if (isSwipeDown) {
                [self swipeUp];
            }
            else {
                [self swipeDown];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
