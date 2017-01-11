//
//  DashboardTableViewCell.m
//  Dwell
//
//  Created by Monika Sharma on 27/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "DashboardTableViewCell.h"
#import "UIView+RoundedCorner.h"
#import "MaintenanceModel.h"
#import "ParcelModel.h"

@implementation DashboardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
//    [self layoutCellObject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)layoutCellObject:(int)selectedType {
    
    self.cellContainerView.layer.cornerRadius=cornerRadius;
    self.cellContainerView.layer.masksToBounds=YES;
    
    //Make dots below title label
//     UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:resourceStatusBackGroundView.bounds byRoundingCorners:( UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(3.0, 3.0)];
//    CAShapeLayer *maskLayer=[[CAShapeLayer alloc] init];
//    maskLayer.frame=frame;
//    maskLayer.path=maskPath.CGPath;
//    resourceStatusBackGroundView.layer.mask = maskLayer;
    CAShapeLayer *shapelayer=[CAShapeLayer layer];
    UIBezierPath *path=[UIBezierPath bezierPath];
    //Draw a line
    [path moveToPoint:CGPointMake(0.0, 44.0)]; //Add yourStartPoint here
    [path addLineToPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width-30, 44.0)];//Add yourEndPoint here
    
    UIColor *fill;
    if (selectedType==1) {
        fill=[Constants oldOrangeBackgroundColor];
    }
    else {
        fill=[Constants oldBlueBackgroundColor:1.0];
    }
    shapelayer.strokeStart=0.0;
    shapelayer.strokeColor=fill.CGColor;
    shapelayer.lineWidth=1.0f;
    shapelayer.lineJoin=kCALineJoinRound;
    shapelayer.lineDashPattern=[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:7], nil];
    shapelayer.path=path.CGPath;
    [self.cellContainerView.layer addSublayer:shapelayer];
    //[self.cellShadowBackView addShadowWithCornerRadius:self.cellShadowBackView color:[UIColor lightGrayColor] borderColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0] radius:5.0f];  //Add corner radius and shadow
}

- (void)displayData:(NSMutableArray*)dashboardData selectedType:(int)selectedType {    //Here selected type is maintenance type(1) or parcel type(2)
    
    [self layoutCellObject:selectedType];
    self.firstInformationView.hidden=NO;
    self.secondInformationView.hidden=NO;
    self.thirdInformationView.hidden=NO;
    self.noRecordAvailable.hidden=YES;
    
    self.firstInformationStatusLabel.textColor=[UIColor darkGrayColor];     //Set byDefault color is [UIColor darkGrayColor]
    self.secondInformationStatusLabel.textColor=[UIColor darkGrayColor];    //Set byDefault color is [UIColor darkGrayColor]
    self.thirdInformationStatusLabel.textColor=[UIColor darkGrayColor];     //Set byDefault color is [UIColor darkGrayColor]
    
    if (selectedType==1) {
        self.titleLabel.textColor=[Constants oldOrangeBackgroundColor];
        self.titleLabel.text=@"Maintenance";
        self.titleIcon.image=[UIImage imageNamed:@"maintenanceSideBar"];
        if (dashboardData.count==0) {
            self.noRecordAvailable.hidden=NO;
            self.noRecordAvailable.text=@"No job available.";
            self.firstInformationView.hidden=YES;
            self.secondInformationView.hidden=YES;
            self.thirdInformationView.hidden=YES;
        }
        else {
            for (int i=0; i<dashboardData.count; i++) {
                [self setMentenenceInformation:[dashboardData objectAtIndex:i] index:i];
            }
        }
    }
    else {
        self.titleLabel.text=@"Parcel";
        self.titleIcon.image=[UIImage imageNamed:@"parcelSideBar"];
        self.titleLabel.textColor=[Constants oldBlueBackgroundColor:1.0];
        
        if (dashboardData.count==0) {
            self.noRecordAvailable.hidden=NO;
            self.noRecordAvailable.text=@"No parcel available.";
            self.firstInformationView.hidden=YES;
            self.secondInformationView.hidden=YES;
            self.thirdInformationView.hidden=YES;
        }
        else {
            for (int i=0; i<dashboardData.count; i++) {
                [self setParcelInformation:[dashboardData objectAtIndex:i] index:i];
            }
        }
    }
}

- (void)setMentenenceInformation:(MaintenanceModel*)mentenenceModelData index:(int)index {

    switch (index) {
        case 0:
            //Set NA if title is nil
            if (mentenenceModelData.title) {
                self.firstInformationTitleLabel.text=mentenenceModelData.title;
            }
            else {
                self.firstInformationTitleLabel.text=@"NA";
            }
            //Set NA if reportedDate is nil
            if(mentenenceModelData.reportedDate) {
                self.firstInformationDateLabel.text=mentenenceModelData.reportedDate;
            }
            else {
                self.firstInformationDateLabel.text=@"NA";
            }
            //Set NA if status is nil
            if(mentenenceModelData.status) {
                self.firstInformationStatusLabel.text=mentenenceModelData.status;
                //Set maintenance status color according to given status
                [self setMaintenanceStatusColor:self.firstInformationStatusLabel status:mentenenceModelData.status];
            }
            else {
                self.firstInformationStatusLabel.text=@"NA";
            }
            break;
        case 1:
            //Set NA if title is nil
            if (mentenenceModelData.title) {
                self.secondInformationTitleLabel.text=mentenenceModelData.title;
            }
            else {
                self.secondInformationTitleLabel.text=@"NA";
            }
            //Set NA if reportedDate is nil
            if(mentenenceModelData.reportedDate) {
                self.secondInformationDateLabel.text=mentenenceModelData.reportedDate;
            }
            else {
                self.secondInformationDateLabel.text=@"NA";
            }
            //Set NA if status is nil
            if(mentenenceModelData.status) {
                self.secondInformationStatusLabel.text=mentenenceModelData.status;
                //Set maintenance status color according to given status
                [self setMaintenanceStatusColor:self.secondInformationStatusLabel status:mentenenceModelData.status];
            }
            else {
                self.secondInformationStatusLabel.text=@"NA";
            }
            break;
        case 2:
            //Set NA if title is nil
            if (mentenenceModelData.title) {
                self.thirdInformationTitleLabel.text=mentenenceModelData.title;
            }
            else {
                self.thirdInformationTitleLabel.text=@"NA";
            }
            //Set NA if reportedDate is nil
            if(mentenenceModelData.reportedDate) {
                self.thirdInformationDateLabel.text=mentenenceModelData.reportedDate;
            }
            else {
                self.thirdInformationDateLabel.text=@"NA";
            }
            //Set NA if status is nil
            if(mentenenceModelData.status) {
                self.thirdInformationStatusLabel.text=mentenenceModelData.status;
                //Set maintenance status color according to given status
                [self setMaintenanceStatusColor:self.thirdInformationStatusLabel status:mentenenceModelData.status];
            }
            else {
                self.thirdInformationStatusLabel.text=@"NA";
            }
            break;
        default:
            break;
    }
}

- (void)setMaintenanceStatusColor:(UILabel *)statusLabel status:(NSString *)status {
    
    //Set text color according to status
    if([status isEqualToString:@"Job Completed"]) {
        
        statusLabel.textColor = [Constants purpleBackgroundColor];
    }
    else if ([status isEqualToString:@"Awaiting for Contractor"]||[status isEqualToString:@"Awaiting for Parts"]) {
        statusLabel.textColor = [Constants redBackgroundColor];
    }
    else if ([status isEqualToString:@"Job in Progress"]) {
        statusLabel.textColor = [Constants yellowBackgroundColor];
    }
    else if ([status isEqualToString:@"Job Received"]) {
        statusLabel.textColor = [Constants orangeBackgroundColor];
    }
    else if ([status isEqualToString:@"Job Scheduled"]) {
        statusLabel.textColor = [Constants blueBackgroundColor];
    }
    else if ([status isEqualToString:@"Please contact office"]) {
        statusLabel.textColor = [Constants oliveGreenBackgroundColor];
    }
    else if([status isEqualToString:@"Job Submitted"]) {
        statusLabel.textColor = [Constants greenBackgroundColor];
    }
    else if([status isEqualToString:@"Closed"]) {
        
        statusLabel.textColor = [Constants darkGrayBackgroundColor];
    }
    else {
        statusLabel.textColor = [Constants grayBackgroundColor];
    }
}

- (void)setParcelInformation:(ParcelModel*)parcelModelData index:(int)index {
    
    switch (index) {
        case 0:
            //Set NA if title is nil
            if (parcelModelData.parcelTitle) {
                self.firstInformationTitleLabel.text=parcelModelData.parcelTitle;
            }
            else {
                self.firstInformationTitleLabel.text=@"No title available";
            }
            //Set NA if reportedDate is nil
            if(parcelModelData.parcelReceiptDate) {
                self.firstInformationDateLabel.text=parcelModelData.parcelReceiptDate;
            }
            else {
                self.firstInformationDateLabel.text=@"NA";
            }
            //Set NA if status is nil
            if(parcelModelData.parcelStatus) {
                self.firstInformationStatusLabel.text=parcelModelData.parcelStatus;
                //Set parcel status color according to given status
                [self setParcelStatusColor:self.firstInformationStatusLabel status:parcelModelData.parcelStatusId];
            }
            else {
                self.firstInformationStatusLabel.text=@"NA";
            }
            break;
        case 1:
            //Set NA if title is nil
            if (parcelModelData.parcelTitle) {
                self.secondInformationTitleLabel.text=parcelModelData.parcelTitle;
            }
            else {
                self.secondInformationTitleLabel.text=@"No title available";
            }
            //Set NA if reportedDate is nil
            if(parcelModelData.parcelReceiptDate) {
                self.secondInformationDateLabel.text=parcelModelData.parcelReceiptDate;
            }
            else {
                self.secondInformationDateLabel.text=@"NA";
            }
            //Set NA if status is nil
            if(parcelModelData.parcelStatus) {
                self.secondInformationStatusLabel.text=parcelModelData.parcelStatus;
                //Set parcel status color according to given status
                [self setParcelStatusColor:self.secondInformationStatusLabel status:parcelModelData.parcelStatusId];
            }
            else {
                self.secondInformationStatusLabel.text=@"NA";
            }
            break;
        case 2:
            //Set NA if title is nil
            if (parcelModelData.parcelTitle) {
                self.thirdInformationTitleLabel.text=parcelModelData.parcelTitle;
            }
            else {
                self.thirdInformationTitleLabel.text=@"No title available";
            }
            //Set NA if reportedDate is nil
            if(parcelModelData.parcelReceiptDate) {
                self.thirdInformationDateLabel.text=parcelModelData.parcelReceiptDate;
            }
            else {
                self.thirdInformationDateLabel.text=@"NA";
            }
            //Set NA if status is nil
            if(parcelModelData.parcelStatus) {
                self.thirdInformationStatusLabel.text=parcelModelData.parcelStatus;
                //Set parcel status color according to given status
                [self setParcelStatusColor:self.thirdInformationStatusLabel status:parcelModelData.parcelStatusId];
            }
            else {
                self.thirdInformationStatusLabel.text=@"NA";
            }
            break;
            
        default:
            break;
    }
}

- (void)setParcelStatusColor:(UILabel *)statusLabel status:(NSString *)status {
    
    //Set text color according to status
    if ([status isEqualToString:@"0"]) {
        statusLabel.textColor=[Constants greenBackgroundColor];
    }
    else if ([status isEqualToString:@"1"]) {
        statusLabel.textColor=[Constants orangeBackgroundColor];
    }
    else if ([status isEqualToString:@"2"]) {
        statusLabel.textColor=[Constants yellowBackgroundColor];
    }
    else if ([status isEqualToString:@"3"]) {
        statusLabel.textColor=[Constants blueBackgroundColor];
    }
    else {
        statusLabel.textColor=[Constants grayBackgroundColor];
    }
}
@end
