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
    [self layoutCellObject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)layoutCellObject {
    
    self.cellContainerView.layer.cornerRadius=5.0f;
    self.cellContainerView.layer.masksToBounds=YES;
    [self.cellShadowBackView addShadowWithCornerRadius:self.cellShadowBackView color:[UIColor lightGrayColor] borderColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0] radius:5.0f];  //Add corner radius and shadow
}

- (void)displayData:(NSMutableArray*)dashboardData selectedType:(int)selectedType {    //Here selected type is maintenance type(1) or parcel type(2)
    
    self.firstInformationStatusLabel.textColor=[UIColor darkGrayColor];     //Set byDefault color is [UIColor darkGrayColor]
    self.secondInformationStatusLabel.textColor=[UIColor darkGrayColor];    //Set byDefault color is [UIColor darkGrayColor]
    self.thirdInformationStatusLabel.textColor=[UIColor darkGrayColor];     //Set byDefault color is [UIColor darkGrayColor]
    if (selectedType==1) {
        self.titleLabel.text=@"Maintenance";
        self.titleIcon.image=[UIImage imageNamed:@"maintenanceUnselected"];
        for (int i=0; i<dashboardData.count; i++) {
            [self setMentenenceInformation:[dashboardData objectAtIndex:i] index:i];
        }
    }
    else {
        self.titleLabel.text=@"Parcel";
        self.titleIcon.image=[UIImage imageNamed:@"parcelUnselected"];
        for (int i=0; i<dashboardData.count; i++) {
            [self setParcelInformation:[dashboardData objectAtIndex:i] index:i];
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

    if([status isEqualToString:@"Job Completed"]) {
        statusLabel.textColor = [Constants greenBackgroundColor];
    }
    else if ([status isEqualToString:@"Awaiting for Contractor"]||[status isEqualToString:@"Awaiting for Parts"]||[status isEqualToString:@"Job in Progress"]) {
        statusLabel.textColor = [Constants yellowBackgroundColor];
    }
    else {
        statusLabel.textColor = [Constants blueBackgroundColor];
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
                self.firstInformationTitleLabel.text=@"NA";
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
                [self setParcelStatusColor:self.firstInformationStatusLabel status:parcelModelData.parcelStatus];
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
                self.secondInformationTitleLabel.text=@"NA";
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
                [self setParcelStatusColor:self.secondInformationStatusLabel status:parcelModelData.parcelStatus];
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
                self.thirdInformationTitleLabel.text=@"NA";
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
                [self setParcelStatusColor:self.thirdInformationStatusLabel status:parcelModelData.parcelStatus];
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
    
    if ([status isEqualToString:@"0"]) {
        statusLabel.textColor=[Constants greenBackgroundColor];
    }
    else if ([status isEqualToString:@"1"]) {
        statusLabel.textColor=[Constants yellowBackgroundColor];
    }
    else if ([status isEqualToString:@"3"]) {
        statusLabel.textColor=[Constants redBackgroundColor];
    }
    else {
        statusLabel.textColor=[Constants yellowBackgroundColor];
    }
}
@end
