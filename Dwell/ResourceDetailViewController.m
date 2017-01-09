//
//  ResourceDetailViewController.m
//  Dwell
//
//  Created by Ranosys on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ResourceDetailViewController.h"
#import "UIView+RoundedCorner.h"

@interface ResourceDetailViewController ()
//Get view outlets
@property (strong, nonatomic) IBOutlet UIView *resourceDetailView;
@property (strong, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet UIView *mainBackgroundView;
@property (strong, nonatomic) IBOutlet UIView *backShadowView;
@property (weak, nonatomic) IBOutlet UILabel *resourceTitle;
@property (weak, nonatomic) IBOutlet UILabel *resourceType;
@property (weak, nonatomic) IBOutlet UILabel *fromDate;
@property (weak, nonatomic) IBOutlet UILabel *toDate;
@property (weak, nonatomic) IBOutlet UIView *resourceStatusBackGroundView;
@property (weak, nonatomic) IBOutlet UILabel *resourceStatus;
@property (weak, nonatomic) IBOutlet UILabel *resourceDescription;
@property (strong, nonatomic) IBOutlet UILabel *adminCommentTitle;
@property (strong, nonatomic) IBOutlet UILabel *adminComment;
@end

@implementation ResourceDetailViewController
@synthesize resourceDetailData;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"Resource Detail";
    [self layoutViewObjects];
    //Show  resource data using resource model
    [self showResourceDetailData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Custom accessors
- (void)layoutViewObjects {
    
    //Set corner radius to main background view
    [self removeAutolayout];//Remove autolayout
    [self changeViewFrame];//Change frame according to forwarding address and comment
    [self.mainBackgroundView setCornerRadius:5.0f];
    [self.backShadowView addShadowWithCornerRadius:self.backShadowView color:[UIColor lightGrayColor] borderColor:[UIColor clearColor] radius:5.0f];  //Add corner radius and shadow
}

- (void)changeViewFrame {
    
    self.resourceDetailView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    float backgroundViewHeight=0.0;//Initialize back view size
    //Get dynamic height according to resource description text
    float descriptionHeight=[UserDefaultManager getDynamicLabelHeight:resourceDetailData.resourceDescription font:[UIFont calibriNormalWithSize:16] widthValue:([UIScreen mainScreen].bounds.size.width-30)-16];
    //Get dynamic height according to resource comment text
    float commentHeight=[UserDefaultManager getDynamicLabelHeight:resourceDetailData.resourceComment font:[UIFont calibriNormalWithSize:16] widthValue:([UIScreen mainScreen].bounds.size.width-30)-16];
    self.resourceDescription.numberOfLines=0;
    self.adminComment.numberOfLines=0;
    if (descriptionHeight<21) {
        descriptionHeight=21;
    }
    //Change framing of uiview object according to text lenght
    self.resourceDescription.frame=CGRectMake(8, 208, ([UIScreen mainScreen].bounds.size.width-30)-16, descriptionHeight);
    self.adminCommentTitle.frame=CGRectMake(8, self.resourceDescription.frame.origin.y+self.resourceDescription.frame.size.height+17, 230, 21);
    //If comment height is zero set admin comment height 21(by default)
    if (commentHeight<21) {
         self.adminComment.frame=CGRectMake(8, self.adminCommentTitle.frame.origin.y+self.adminCommentTitle.frame.size.height-2, ([UIScreen mainScreen].bounds.size.width-30)-16, 21);
    }
    else {
        self.adminComment.frame=CGRectMake(8, self.adminCommentTitle.frame.origin.y+self.adminCommentTitle.frame.size.height-2, ([UIScreen mainScreen].bounds.size.width-30)-16, commentHeight);
    }
    
    if (commentHeight<55) {
        commentHeight=58;
    }
    //Change main view height according to uiview object height
    backgroundViewHeight=self.adminComment.frame.origin.y+commentHeight+48;
    self.backShadowView.frame=CGRectMake(15, 15, [UIScreen mainScreen].bounds.size.width-30, backgroundViewHeight);
    self.resourceStatusBackGroundView.frame=CGRectMake(0, self.backShadowView.frame.size.height-35, self.backShadowView.frame.size.width, 35);
    self.detailScrollView.scrollEnabled=false;
    //Scrolling is disable if view height more then screen size
    if ((backgroundViewHeight+64)>[UIScreen mainScreen].bounds.size.height) {
        self.detailScrollView.scrollEnabled=true;
        self.resourceDetailView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, backgroundViewHeight+100);
    }
}

- (void)removeAutolayout {
    
    self.resourceDetailView.translatesAutoresizingMaskIntoConstraints=YES;
    self.resourceDescription.translatesAutoresizingMaskIntoConstraints=YES;
    self.backShadowView.translatesAutoresizingMaskIntoConstraints=YES;
    self.adminComment.translatesAutoresizingMaskIntoConstraints=YES;
    self.adminCommentTitle.translatesAutoresizingMaskIntoConstraints=YES;
    self.resourceStatusBackGroundView.translatesAutoresizingMaskIntoConstraints=YES;
}

- (void)showResourceDetailData {
    
    //Check resource title is nil
    if ((nil==resourceDetailData.resourceTitle)||[resourceDetailData.resourceTitle isEqualToString:@""]) {
        self.resourceTitle.text=@"No title available";
    }
    else {
        self.resourceTitle.text=resourceDetailData.resourceTitle;
    }
    //Check resource type is nil
    if ((nil==resourceDetailData.resourceType)||[resourceDetailData.resourceType isEqualToString:@""]) {
        self.resourceType.text=@"NA";
    }
    else {
        self.resourceType.text=resourceDetailData.resourceType;
    }
    //Check fromDate is nil
    if ((nil==resourceDetailData.resourceFromDate)||[resourceDetailData.resourceFromDate isEqualToString:@""]) {
        self.fromDate.text=@"NA";
    }
    else {
        self.fromDate.text=resourceDetailData.resourceFromDate;
    }
    //Check toDate is nil
    if ((nil==resourceDetailData.resourceToDate)||[resourceDetailData.resourceToDate isEqualToString:@""]) {
        self.toDate.text=@"NA";
    }
    else {
        self.toDate.text=resourceDetailData.resourceToDate;
    }
    //Check resource status is nil
    if ((nil==resourceDetailData.resourceStatus)||[resourceDetailData.resourceStatus isEqualToString:@""]) {
        self.resourceStatus.text=@"NA";
    }
    else {
        self.resourceStatus.text=resourceDetailData.resourceStatus;
    }
    //Check resource description is nil
    if ((nil==resourceDetailData.resourceDescription)||[resourceDetailData.resourceDescription isEqualToString:@""]) {
        self.resourceDescription.text=@"NA";
    }
    else {
        self.resourceDescription.text=resourceDetailData.resourceDescription;
    }
    //Check resource comment is nil
    if ((nil==resourceDetailData.resourceComment)||[resourceDetailData.resourceComment isEqualToString:@""]) {
        self.adminComment.text=@"NA";
    }
    else {
        self.adminComment.text=resourceDetailData.resourceComment;
    }
    //Set status back color according to fetch status
    if ([resourceDetailData.resourceStatusId isEqualToString:@"0"]) {
        self.resourceStatusBackGroundView.backgroundColor=[Constants greenBackgroundColor];
    }
    else if ([resourceDetailData.resourceStatusId isEqualToString:@"1"]) {
        self.resourceStatusBackGroundView.backgroundColor=[Constants orangeBackgroundColor];
    }
    else if ([resourceDetailData.resourceStatusId isEqualToString:@"2"]) {
        self.resourceStatusBackGroundView.backgroundColor=[Constants blueBackgroundColor];
    }
    else if ([resourceDetailData.resourceStatusId isEqualToString:@"3"]) {
        self.resourceStatusBackGroundView.backgroundColor=[Constants yellowBackgroundColor];
    }
    else if ([resourceDetailData.resourceStatusId isEqualToString:@"4"]) {
        self.resourceStatusBackGroundView.backgroundColor=[Constants redBackgroundColor];
    }
    else {
        self.resourceStatusBackGroundView.backgroundColor=[Constants grayBackgroundColor];
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
