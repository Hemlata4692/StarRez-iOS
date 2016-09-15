//
//  ParcelListViewController.m
//  Dwell
//
//  Created by Shiven on 14/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ParcelListViewController.h"
#import "ParcelCell.h"
#import "ParcelModel.h"

@interface ParcelListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *parcelListTableview;

@end

@implementation ParcelListViewController
@synthesize parcelListTableview;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Parcel";
    //Add background image
    [super addBackgroungImage:@"Parcel"];
    [myDelegate showIndicator:[Constants parcelColor]];
    [self performSelector:@selector(getParcelListService) withObject:nil afterDelay:.1];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mak - end

#pragma mark - Webservice
//User login webservice called
- (void)getParcelListService {
    
    ParcelModel *parcelData = [ParcelModel sharedUser];
    [parcelData getParcelListOnSuccess:^(id userData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate stopIndicator];
        });
    } onfailure:^(id error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate stopIndicator];
            if ([[error objectForKey:@"success"] isEqualToString:@"0"]) {
//                alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"User does not exist in the system." doneButtonText:@"OK" cancelButtonText:@""];
            }
            else {
//                alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Something went wrong, Please try again." doneButtonText:@"OK" cancelButtonText:@""];
            }
        });
    }];
}
#pragma mark - end

#pragma mark - Tableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ParcelCell *cell ;
    NSString *simpleTableIdentifier = @"ParcelCell";
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[ParcelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    [cell displayData:nil frame:self.view.bounds];
    
    return cell;
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
