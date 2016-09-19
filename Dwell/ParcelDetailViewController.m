//
//  ParcelDetailViewController.m
//  Dwell
//
//  Created by Shiven on 15/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ParcelDetailViewController.h"

@interface ParcelDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *mainBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *parcelTitle;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
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
@property (weak, nonatomic) IBOutlet UITextView *adminComments;

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
    
    //Change frame of forwardAddress label and main background view
    self.forwardAddress.translatesAutoresizingMaskIntoConstraints=YES;
    self.mainBackgroundView.translatesAutoresizingMaskIntoConstraints=YES;
    float forwardAddressHeight=[self getDynamicLabelHeight:parcelDetailData.parcelForwardingAddress font:[UIFont calibriNormalWithSize:16] widthValue:([UIScreen mainScreen].bounds.size.width-20)-130];
    self.mainBackgroundView.frame=CGRectMake(10, 64, [UIScreen mainScreen].bounds.size.width-20, 390);
    if (forwardAddressHeight<21) {
        self.forwardAddress.frame=CGRectMake(8, 216, ([UIScreen mainScreen].bounds.size.width-20)-130, 21);
    }
    else {
        self.forwardAddress.frame=CGRectMake(8, 216, ([UIScreen mainScreen].bounds.size.width-20)-130, forwardAddressHeight);
        self.mainBackgroundView.frame=CGRectMake(10, 64, [UIScreen mainScreen].bounds.size.width-20, 390+(forwardAddressHeight-21));
    }
}

- (void)showParcelDetailData {
    
    self.parcelTitle.text=parcelDetailData.parcelTitle;
    self.parcelType.text=parcelDetailData.parcelType;
    self.receiptDate.text=parcelDetailData.parcelReceiptDate;
    self.shippingType.text=parcelDetailData.parcelShippingType;
    self.issueDate.text=parcelDetailData.parcelIssueDate;
    self.parcelStatus.text=parcelDetailData.parcelStatus;
    self.forwardAddress.text=parcelDetailData.parcelForwardingAddress;
    self.trackingNo.text=parcelDetailData.parcelTrackingNo;
    self.adminComments.text=parcelDetailData.parcelComment;
    if ([parcelDetailData.parcelStatusId isEqualToString:@"0"]) {
        self.parcelStatus.text=@"Collected";
        self.parcelStatusBackGroundView.backgroundColor=[Constants resourceColor:1.0];
    }
    else if ([parcelDetailData.parcelStatusId isEqualToString:@"1"]) {
        self.parcelStatus.text=@"Parcel for Collection";
        self.parcelStatusBackGroundView.backgroundColor=[Constants eventColor:1.0];
    }
    else if ([parcelDetailData.parcelStatusId isEqualToString:@"3"]) {
        self.parcelStatus.text=parcelDetailData.parcelStatus;
        self.parcelStatusBackGroundView.backgroundColor=[Constants returnedColor:1.0];
    }
    else {
        self.parcelStatus.text=parcelDetailData.parcelStatus;
        self.parcelStatusBackGroundView.backgroundColor=[Constants eventColor:1.0];
    }
}
#pragma mark - end

#pragma mark - Get dynamic height according to string
- (float)getDynamicLabelHeight:(NSString *)text font:(UIFont *)font widthValue:(float)widthValue{
    
    CGSize size = CGSizeMake(widthValue,55);
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
