//
//  ParcelDetailViewController.m
//  Dwell
//
//  Created by Shiven on 15/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ParcelDetailViewController.h"

@interface ParcelDetailViewController ()
@property (strong, nonatomic) IBOutlet UIView *parcelDetailView;
@property (strong, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet UIView *mainBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *parcelTitle;
@property (weak, nonatomic) IBOutlet UILabel *parcelTypeTitle;
@property (weak, nonatomic) IBOutlet UILabel *parcelType;
@property (weak, nonatomic) IBOutlet UILabel *receiptDateTitle;
@property (weak, nonatomic) IBOutlet UILabel *receiptDate;
@property (weak, nonatomic) IBOutlet UILabel *shippingTypeTitle;
@property (weak, nonatomic) IBOutlet UILabel *shippingType;
@property (weak, nonatomic) IBOutlet UILabel *issueDateTitle;
@property (weak, nonatomic) IBOutlet UILabel *issueDate;
@property (weak, nonatomic) IBOutlet UIView *parcelStatusBackGroundView;
@property (weak, nonatomic) IBOutlet UILabel *parcelStatus;
@property (weak, nonatomic) IBOutlet UILabel *forwardAddressTitle;
@property (weak, nonatomic) IBOutlet UILabel *forwardAddress;
@property (weak, nonatomic) IBOutlet UILabel *trackingNoTitle;
@property (weak, nonatomic) IBOutlet UILabel *trackingNo;
@property (strong, nonatomic) IBOutlet UILabel *adminCommentTitle;
@property (strong, nonatomic) IBOutlet UILabel *adminComment;
@end

@implementation ParcelDetailViewController
@synthesize parcelDetailData;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"Parcel Detail";
    [super addBackgroungImage:@"Parcel"];
    [self layoutViewObjects];
    [self showParcelDetailData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark -Custom accessors
- (void)layoutViewObjects {
    
    //Set corner radius to main background view
    self.mainBackgroundView.layer.cornerRadius=cornerRadius;
    self.mainBackgroundView.layer.masksToBounds=YES;
    //Make dots below title label
    CAShapeLayer *shapelayer=[CAShapeLayer layer];
    UIBezierPath *path=[UIBezierPath bezierPath];
    //Draw a line
    [path moveToPoint:CGPointMake(0.0,_parcelTitle.frame.size.height)]; //Add yourStartPoint here
    [path addLineToPoint:CGPointMake(self.view.frame.size.width-20, _parcelTitle.frame.size.height)];//Add yourEndPoint here
    UIColor *fill=[UIColor colorWithRed:72.0/255.0 green:73.0/255.0 blue:73.0/255.0 alpha:1.0];
    shapelayer.strokeStart=0.0;
    shapelayer.strokeColor=fill.CGColor;
    shapelayer.lineWidth=1.0f;
    shapelayer.lineJoin=kCALineJoinRound;
    shapelayer.lineDashPattern=[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:7], nil];
    shapelayer.path=path.CGPath;
    [_parcelTitle.layer addSublayer:shapelayer];
    
    [self removeAutolayout];//Remove autolayout
    [self changeViewFrame];//Change frame according to forwarding address and comment
}

- (void)changeViewFrame {
 
    self.parcelDetailView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    float backgroundViewHeight=0.0;//Initialize back view size
    float forwardAddressHeight=[self getDynamicLabelHeight:parcelDetailData.parcelForwardingAddress font:[UIFont calibriNormalWithSize:16] widthValue:([UIScreen mainScreen].bounds.size.width-20)-130];
    float commentHeight=[self getDynamicLabelHeight:parcelDetailData.parcelComment font:[UIFont calibriNormalWithSize:16] widthValue:([UIScreen mainScreen].bounds.size.width-20)-16];
    self.forwardAddress.numberOfLines=0;
    self.adminComment.numberOfLines=0;
    if (forwardAddressHeight<21) {
        self.forwardAddress.frame=CGRectMake(8, 216, ([UIScreen mainScreen].bounds.size.width-20)-138, 21);
    }
    else {
        self.forwardAddress.frame=CGRectMake(8, self.forwardAddressTitle.frame.origin.y+self.forwardAddressTitle.frame.size.height+8, ([UIScreen mainScreen].bounds.size.width-20)-138, forwardAddressHeight);
    }
    self.adminCommentTitle.frame=CGRectMake(8, self.forwardAddress.frame.origin.y+self.forwardAddress.frame.size.height+17, 230, 21);
    self.adminComment.frame=CGRectMake(8, self.adminCommentTitle.frame.origin.y+self.adminCommentTitle.frame.size.height+8, ([UIScreen mainScreen].bounds.size.width-20)-16, commentHeight);
    
    if (commentHeight<55) {
        commentHeight=58;
    }
    backgroundViewHeight=self.adminComment.frame.origin.y+commentHeight+48;
    self.mainBackgroundView.frame=CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, backgroundViewHeight);
    self.parcelStatusBackGroundView.frame=CGRectMake(0, self.mainBackgroundView.frame.size.height-40, self.mainBackgroundView.frame.size.width, 40);
    self.detailScrollView.scrollEnabled=false;
    if ((backgroundViewHeight+64)>[UIScreen mainScreen].bounds.size.height) {
        self.detailScrollView.scrollEnabled=true;
        self.parcelDetailView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, backgroundViewHeight+100);
    }
}

- (void)removeAutolayout {
    self.parcelDetailView.translatesAutoresizingMaskIntoConstraints=YES;
    self.forwardAddress.translatesAutoresizingMaskIntoConstraints=YES;
    self.mainBackgroundView.translatesAutoresizingMaskIntoConstraints=YES;
    self.adminComment.translatesAutoresizingMaskIntoConstraints=YES;
    self.adminCommentTitle.translatesAutoresizingMaskIntoConstraints=YES;
    self.parcelStatusBackGroundView.translatesAutoresizingMaskIntoConstraints=YES;
}

- (void)showParcelDetailData {
    
    self.parcelTitle.text=parcelDetailData.parcelTitle;
    self.parcelType.text=parcelDetailData.parcelType;
    //Check recipt date is nil
    if ((nil==parcelDetailData.parcelReceiptDate)||[parcelDetailData.parcelReceiptDate isEqualToString:@""]) {
        self.receiptDate.text=@"NA";
    }
    else {
        self.receiptDate.text=parcelDetailData.parcelReceiptDate;
    }
    self.shippingType.text=parcelDetailData.parcelShippingType;
    //Check issued date is nil
    if ((nil==parcelDetailData.parcelIssueDate)||[parcelDetailData.parcelIssueDate isEqualToString:@""]) {
        self.issueDate.text=@"NA";
    }
    else {
        self.issueDate.text=parcelDetailData.parcelIssueDate;
    }
    self.parcelStatus.text=parcelDetailData.parcelStatus;
    self.forwardAddress.text=parcelDetailData.parcelForwardingAddress;
    self.trackingNo.text=parcelDetailData.parcelTrackingNo;
    self.adminComment.text=parcelDetailData.parcelComment;
    self.parcelStatus.text=parcelDetailData.parcelStatus;
    if ([parcelDetailData.parcelStatusId isEqualToString:@"0"]) {
        self.parcelStatusBackGroundView.backgroundColor=[Constants resourceColor:0.6];
    }
    else if ([parcelDetailData.parcelStatusId isEqualToString:@"1"]) {
        self.parcelStatusBackGroundView.backgroundColor=[Constants eventColor:0.6];
    }
    else if ([parcelDetailData.parcelStatusId isEqualToString:@"3"]) {
        self.parcelStatusBackGroundView.backgroundColor=[Constants returnedColor:0.6];
    }
    else {
        self.parcelStatusBackGroundView.backgroundColor=[Constants eventColor:0.6];
    }
}
#pragma mark - end

#pragma mark - Get dynamic height according to string
- (float)getDynamicLabelHeight:(NSString *)text font:(UIFont *)font widthValue:(float)widthValue{
    
    CGSize size = CGSizeMake(widthValue,1000);
    CGRect textRect=[text
                     boundingRectWithSize:size
                     options:NSStringDrawingUsesLineFragmentOrigin
                     attributes:@{NSFontAttributeName:font}
                     context:nil];
    return textRect.size.height;
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
