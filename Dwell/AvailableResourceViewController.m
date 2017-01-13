//
//  AvailableResourceViewController.m
//  Dwell
//
//  Created by Ranosys on 26/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "AvailableResourceViewController.h"
#import "CustomFilterViewController.h"
#import "UIView+RoundedCorner.h"
#import "CustomAlertView.h"
#import "ResourceListViewController.h"

@interface AvailableResourceViewController ()<CustomFilterDelegate> {

    CustomAlert *alertView;
    int selectedResource;
}

@property (strong, nonatomic) IBOutlet UIScrollView *availableResourceScrollView;
@property (strong, nonatomic) IBOutlet UIView *availableResourceMainView;
@property (strong, nonatomic) IBOutlet UITableView *availableResourceTableView;
@end

@implementation AvailableResourceViewController
@synthesize availableResourceData;
@synthesize selectedToDataTime;
@synthesize selectedFromDataTime;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.navigationItem.title = @"Book Resource";
    selectedResource=0;
    [super addBackgroungImage:@"Resource"];
    //View customization and add shadow with corner radius
    [self viewCustomization];
    self.availableResourceTableView.scrollEnabled=false;
    // Do any additional setup after loading the view.
}

#pragma mark - Custom accessors
- (void)viewCustomization {
    
    [self removeAutolayout];
    DLog(@"%f,%f",[UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.height-64);
    //Set view height according to table view array data
    if(([UIScreen mainScreen].bounds.size.height-94)>(((availableResourceData.count)*70.0)+50.0)) {
        self.availableResourceMainView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-94);
    }
    else {
        self.availableResourceMainView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ((availableResourceData.count)*70.0)+50.0);
    }
    
//    [self.availableResourceMainView addShadowWithCornerRadius:self.availableResourceMainView color:[UIColor lightGrayColor] borderColor:[UIColor whiteColor] radius:5.0f];  //Add corner radius and shadow
//    self.availableResourceTableView.layer.masksToBounds=YES;
//    self.availableResourceTableView.layer.cornerRadius=5.0f;
}

- (void)removeAutolayout {
    
    self.availableResourceMainView.translatesAutoresizingMaskIntoConstraints=YES;
}
#pragma mark - end

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Tableview methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return availableResourceData.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        return 50.0;        //Set first index height
    }
    else {
        return 70.0;    //Set other index height
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
//    NSString *simpleTableIdentifier = @"AvailableResourceCell";
    
    if (indexPath.row==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AvailableResourceTitleCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AvailableResourceTitleCell"];
        }
        UILabel *title=(UILabel*)[cell viewWithTag:1];
//        title.font=[UIFont calibriBoldWithSize:18];
        title.text=@"Available Resources";
//        title.textColor=[UIColor colorWithRed:84.0/255 green:84.0/255.0 blue:84.0/255.0 alpha:1.0];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AvailableResourceCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AvailableResourceCell"];
        }
        UILabel *title=(UILabel*)[cell viewWithTag:1];
        UIView *titleBackView=(UIView*)[cell viewWithTag:2];
        titleBackView.layer.cornerRadius=cornerRadius;
        titleBackView.layer.masksToBounds=YES;
        title.font=[UIFont calibriNormalWithSize:18];
        title.text=[[availableResourceData objectAtIndex:(int)indexPath.row-1] resourceDescription];
        title.textColor=[UIColor colorWithRed:123.0/255 green:123.0/255.0 blue:123.0/255.0 alpha:1.0];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   if (indexPath.row!=0) {
        selectedResource=(int)indexPath.row-1;
        alertView = [[CustomAlert alloc] initWithTitle:[[availableResourceData objectAtIndex:(int)indexPath.row-1] resourceDescription] tagValue:3 delegate:self message:@"Do you want to request this resource?" doneButtonText:@"Yes" cancelButtonText:@"No"];
   }
}
#pragma mark - end

#pragma mark - Custom alert delegates
- (void)customAlertDelegateAction:(CustomAlertView *)customAlert option:(int)option{
    
    [alertView dismissAlertView];
    if ((customAlert.alertTagValue==3)&&(option==1)) {
//        [myDelegate showIndicator:[Constants oldGreenBackgroundColor:1.0]];
        [myDelegate showIndicator:[Constants navigationColor]];
        [self performSelector:@selector(setRequestResourceService) withObject:nil afterDelay:.1];
    }
    else if (customAlert.alertTagValue==10) {
        for (id controller in [self.navigationController viewControllers])
        {
            if ([controller isKindOfClass:[ResourceListViewController class]])
            {
                [self.navigationController popToViewController:controller animated:YES];
                break;
            }
        }
    }
}

- (void)setRequestResourceService {

    ResourceModel *resourceData=[ResourceModel sharedUser];
    resourceData.resourceFromDate=selectedFromDataTime;
    resourceData.resourceToDate=selectedToDataTime;
    resourceData.resourceId=[[availableResourceData objectAtIndex:selectedResource] resourceId];
    [resourceData setRequestResourceOnSuccess:^(id availableResourceData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate stopIndicator];
            alertView=[[CustomAlert alloc] initWithTitle:@"Alert" tagValue:10 delegate:self message:@"New resource has been booked successfully." doneButtonText:@"OK" cancelButtonText:@""];
            
        });
    } onfailure:^(id error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate stopIndicator];
            alertView=[[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Something went wrong, Please try again." doneButtonText:@"OK" cancelButtonText:@""];
        });
    }];
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
