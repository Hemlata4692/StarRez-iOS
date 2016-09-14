//
//  CustomAlertView.h
//  Dwell
//
//  Created by Ranosys on 14/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlertView : UIView

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *transparentView;
@property (strong, nonatomic) IBOutlet UIView *alertContainerView;
@property (strong, nonatomic) IBOutlet UILabel *alertTitle;
@property (strong, nonatomic) IBOutlet UILabel *alertSeparater;
@property (strong, nonatomic) IBOutlet UILabel *alertMessage;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

-(id)initWithFrame:(CGRect)frame title:(NSString*)titleText message:(NSString*)messageText doneButtonText:(NSString*)doneButtonText cancelButtonText:(NSString*)cancelButtonText;
@end
