//
//  CustomFilterViewController.m
//  Dwell
//
//  Created by Ranosys on 16/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "CustomFilterViewController.h"
static int const widthValue=250;
static int heightValue=200;

@interface CustomFilterViewController (){

    NSMutableArray *filterArray;
}

@property (strong, nonatomic) IBOutlet UITableView *filterTableView;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImage;
@end

@implementation CustomFilterViewController
@synthesize filterContainverView;
@synthesize filterDict;
@synthesize isAllSelected;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    filterArray=[[filterDict allKeys] mutableCopy];
    [filterArray insertObject:@"All" atIndex:0];
    heightValue=(60*(int)filterArray.count)+15;
    [self removeAutolayout];
    [self layoutViewObjects];
    [self.filterTableView reloadData];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self showViewAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Tableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return filterArray.count;
}

//[NSString stringWithFormat:@"%@,%@",[[parcelDataArray objectAtIndex:i] parcelStatus],[[parcelDataArray objectAtIndex:i] parcelStatusId]]
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    NSString *simpleTableIdentifier=@"filterCell";
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UILabel *statusLabel=(UILabel *)[cell viewWithTag:2];
    UIImageView *checkedImage=(UIImageView *)[cell viewWithTag:1];
    
    if (indexPath.row==0) {
        statusLabel.text=[filterArray objectAtIndex:indexPath.row];
        if (isAllSelected) {
            statusLabel.textColor=[UIColor colorWithRed:0.0/255 green:116.0/255.0 blue:190.0/255.0 alpha:1.0];
            checkedImage.image=[UIImage imageNamed:@"collected"];
        }
        else {
            statusLabel.textColor=[UIColor colorWithRed:98.0/255 green:98.0/255.0 blue:98.0/255.0 alpha:1.0];
            checkedImage.image=[UIImage imageNamed:@"collection"];
        }
    }
    else {
        statusLabel.text=[[[filterArray objectAtIndex:indexPath.row] componentsSeparatedByString:@","] objectAtIndex:0];
       
        if ([[filterDict objectForKey:[filterArray objectAtIndex:indexPath.row]] isEqualToString:@"Yes"]) {
            statusLabel.textColor=[UIColor colorWithRed:0.0/255 green:116.0/255.0 blue:190.0/255.0 alpha:1.0];
            checkedImage.image=[UIImage imageNamed:@"collected"];
        }
        else {
            statusLabel.textColor=[UIColor colorWithRed:98.0/255 green:98.0/255.0 blue:98.0/255.0 alpha:1.0];
            checkedImage.image=[UIImage imageNamed:@"collection"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    for (int i=1; i<filterArray.count; i++) {
        [filterDict setObject:@"NO" forKey:[filterArray objectAtIndex:i]];
    }
    
    if (indexPath.row==0) {
        [_delegate customFilterDelegateAction:filterDict filterString:@"All"];
    }
    else {
        [filterDict setObject:@"Yes" forKey:[filterArray objectAtIndex:indexPath.row]];
        [_delegate customFilterDelegateAction:filterDict filterString:[[[filterArray objectAtIndex:indexPath.row] componentsSeparatedByString:@","] objectAtIndex:0]];
    }
    [self hideViewAnimation];
}
#pragma mark - end

#pragma mark - Show/Hide animation
- (void)hideViewAnimation {
    
    [UIView animateWithDuration:0.2f animations:^{
        //To Frame
        filterContainverView.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width-30, 57, 0, 0);
        self.arrowImage.frame=CGRectMake(-10, 0, 20, 11);
        self.filterContainverView.alpha = 0.0f;
    } completion:^(BOOL completed) {
        [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)showViewAnimation {
    
    [UIView animateWithDuration:0.2f animations:^{
        //To Frame
        filterContainverView.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width-widthValue-10, 57, widthValue, heightValue);
        self.arrowImage.frame=CGRectMake(widthValue-30, 0, 20, 11);
        self.filterContainverView.alpha = 1.0f;
    } completion:^(BOOL completed) {
    }];
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)hideFilter:(UITapGestureRecognizer *)sender {
    
    [self hideViewAnimation];
}
#pragma mark - end

#pragma mark -Custom accessors
- (void)removeAutolayout {
    
    filterContainverView.translatesAutoresizingMaskIntoConstraints=YES;
    self.filterTableView.translatesAutoresizingMaskIntoConstraints=YES;
    self.arrowImage.translatesAutoresizingMaskIntoConstraints=YES;
}

- (void)layoutViewObjects {
    
    filterContainverView.backgroundColor=[UIColor clearColor];
    filterContainverView.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width-30, 57, 0, 0);
    self.arrowImage.frame=CGRectMake(-10, 0, 20, 11);
    self.filterTableView.frame=CGRectMake(0, 11, widthValue, heightValue-16);
    self.filterTableView.layer.cornerRadius=5.0f;
    self.filterTableView.layer.masksToBounds=YES;
    filterContainverView.layer.masksToBounds=YES;
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
