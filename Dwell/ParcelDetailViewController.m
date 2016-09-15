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
    
    self.title = @"Parcel Detail";
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
    if ([parcelDetailData.parcelStatus isEqualToString:@"Received"]) {
        self.parcelStatus.text=@"Collected";
        self.parcelStatusBackGroundView.backgroundColor=[Constants resourceColor];
    }
    else if ([parcelDetailData.parcelStatus isEqualToString:@"Issued"]) {
        self.parcelStatus.text=@"Parcel for Collection";
        self.parcelStatusBackGroundView.backgroundColor=[Constants eventColor];
    }
    else if ([parcelDetailData.parcelStatus isEqualToString:@"Returned"]) {
        self.parcelStatus.text=parcelDetailData.parcelStatus;
        self.parcelStatusBackGroundView.backgroundColor=[Constants resourceColor];
    }
    else {
        self.parcelStatus.text=parcelDetailData.parcelStatus;
        self.parcelStatusBackGroundView.backgroundColor=[Constants resourceColor];
    }
}

#pragma mark -Custom accessors
- (void)layoutViewObjects{

    //set corner radius to main background view
    _mainBackgroundView.layer.cornerRadius = cornerRadius;
    
    //Round status view from bottom sides
    _parcelStatusBackGroundView.translatesAutoresizingMaskIntoConstraints = YES;
    _parcelStatusBackGroundView.frame = CGRectMake(_parcelStatusBackGroundView.frame.origin.x, _parcelStatusBackGroundView.frame.origin.y, self.view.frame.size.width-18, _parcelStatusBackGroundView.frame.size.height);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_parcelStatusBackGroundView.bounds byRoundingCorners:( UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0, 5.0)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.frame;
    maskLayer.path  = maskPath.CGPath;
    _parcelStatusBackGroundView.layer.mask = maskLayer;
    
    //Make dots below title label
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    //draw a line
    [path moveToPoint:CGPointMake(0.0, _parcelTitle.frame.size.height)]; //add yourStartPoint here
    [path addLineToPoint:CGPointMake(self.view.frame.size.width-18, _parcelTitle.frame.size.height)];// add yourEndPoint here
    UIColor *fill = [UIColor colorWithRed:72.0/255.0 green:73.0/255.0 blue:73.0/255.0 alpha:1.0];
    shapelayer.strokeStart = 0.0;
    shapelayer.strokeColor = fill.CGColor;
    shapelayer.lineWidth = 1.0f;
    shapelayer.lineJoin = kCALineJoinRound;
    shapelayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:7], nil];
    //shapelayer.lineDashPhase = 3.0f;
    shapelayer.path = path.CGPath;
    [_parcelTitle.layer addSublayer:shapelayer];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
