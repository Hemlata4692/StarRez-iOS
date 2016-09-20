//
//  BookResourceViewController.m
//  Dwell
//
//  Created by Ranosys on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "BookResourceViewController.h"
#import "BookResourceCell.h"
#import "ParcelModel.h"
#import "ResourceModel.h"

@interface BookResourceViewController (){
    
    CustomAlert *alertView;
    NSMutableArray *bookResourceTypeArray, *bookResourceLocationArray;
}
@property (weak, nonatomic) IBOutlet UITableView *bookResourceFormTableView;
@end

@implementation BookResourceViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Book Resource";
    //Add background image
    [super addBackgroungImage:@"Resource"];
    bookResourceLocationArray=[NSMutableArray new];
    bookResourceTypeArray=[NSMutableArray new];
    bookResourceLocationArray=[NSMutableArray new];
    [myDelegate showIndicator:[Constants greenBackgroundColor:1.0]];
//    [self performSelector:@selector(getResourceType) withObject:nil afterDelay:.1];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Webservice
//Get parcel list webservice
- (void)getResourceType {
    
//    resourceStatusDict=[NSMutableDictionary new];
    if ([super checkInternetConnection]) {
        ResourceModel *resourceData = [ResourceModel sharedUser];
        [resourceData getResourceTypeOnSuccess:^(id resourceData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
//                resourceDataArray=[resourceData mutableCopy];
//                
//                //Get all type status in resourceStatusDict
//                NSMutableArray *tempStatusKeyArray=[NSMutableArray new];
//                for (int i=0; i<resourceDataArray.count; i++) {
//                    tempStatusKeyArray=[[resourceStatusDict allKeys] mutableCopy];
//                    if (![tempStatusKeyArray containsObject:[NSString stringWithFormat:@"%@,%@",[[resourceDataArray objectAtIndex:i] resourceStatus],[[resourceDataArray objectAtIndex:i] resourceStatusId]]]) {
//                        DLog(@"%@",[NSString stringWithFormat:@"%@,%@",[[resourceDataArray objectAtIndex:i] resourceStatus],[[resourceDataArray objectAtIndex:i] resourceStatusId]]);
//                        [resourceStatusDict setObject:@"NO" forKey:[NSString stringWithFormat:@"%@,%@",[[resourceDataArray objectAtIndex:i] resourceStatus],[[resourceDataArray objectAtIndex:i] resourceStatusId]]];
//                        [tempStatusKeyArray addObject:[NSString stringWithFormat:@"%@,%@",[[resourceDataArray objectAtIndex:i] resourceStatus],[[resourceDataArray objectAtIndex:i] resourceStatusId]]];
//                    }
//                }
//                //end
//                [self.resourceListTableview reloadData];
            });
        } onfailure:^(id error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
                if ([[error objectForKey:@"success"] isEqualToString:@"2"]) {
                    alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Something went wrong, Please try again." doneButtonText:@"OK" cancelButtonText:@""];
                }
            });
        }];
    }
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
