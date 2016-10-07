//
//  CustomAlertView.m
//  Dwell
//
//  Created by Ranosys on 14/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView
@synthesize mainView;
@synthesize alertContainerView;
@synthesize transparentView;
@synthesize alertTitle;
@synthesize alertMessage;
@synthesize alertSeparater;
@synthesize doneButton;
@synthesize cancelButton;
@synthesize alertTagValue;

- (id)initWithFrame:(CGRect)frame title:(NSString*)titleText message:(NSString*)messageText doneButtonText:(NSString*)doneButtonText cancelButtonText:(NSString*)cancelButtonText {
    
    self=[super initWithFrame:frame];
    if (self) {
        
        //Access customAlert xib
        [[NSBundle mainBundle] loadNibNamed:@"CustomAlert" owner:self options:nil];
        mainView.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        //Remove all autolayout
        [self removeAutoLayout];
        transparentView.frame=CGRectMake(0, 0, mainView.frame.size.width, mainView.frame.size.height);
        alertContainerView.frame=CGRectMake((transparentView.frame.size.width / 2) - 138.0, (transparentView.frame.size.height / 2) - 80.0, 276, 160.0);
        alertTitle.frame=CGRectMake(10, 10, alertContainerView.frame.size.width - 20, 32);
        alertSeparater.frame=CGRectMake(0, 45, alertContainerView.frame.size.width, 1);
        alertTitle.text=titleText;
        
        //If messsage is blank then alertMessage height is 0 else set dynamic height
        if ([messageText isEqualToString:@""]) {
            alertMessage.frame=CGRectMake(10, alertTitle.frame.origin.y + alertTitle.frame.size.height + 20, alertContainerView.frame.size.width - 20, 0);
            alertMessage.text=messageText;
            alertMessage.hidden=YES;
        }
        else {
            CGSize size=CGSizeMake(alertContainerView.frame.size.width - 20,165);
            CGRect textRect=[messageText
                               boundingRectWithSize:size
                               options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:[UIFont calibriNormalWithSize:17]}
                               context:nil];
            alertMessage.numberOfLines = 0;
            
            if (textRect.size.height<26) {
                textRect.size.height=25;
            }
            alertMessage.frame=CGRectMake(10, alertTitle.frame.origin.y + alertTitle.frame.size.height + 20, alertContainerView.frame.size.width - 20, textRect.size.height);
            alertMessage.text=messageText;
            alertMessage.hidden=NO;
        }
        //If show single button alert then hidden cancelButton else show cancelButton with doneButton
         cancelButton.frame=CGRectMake(0, alertMessage.frame.origin.y + alertMessage.frame.size.height + 8, 138, 50);
        if ([doneButtonText isEqualToString:@""] || [cancelButtonText isEqualToString:@""]) {
            doneButton.frame=CGRectMake(0, alertMessage.frame.origin.y + alertMessage.frame.size.height + 8, alertContainerView.frame.size.width, 50);
            cancelButton.hidden=YES;
        }
        else{
            doneButton.frame=CGRectMake(138, alertMessage.frame.origin.y + alertMessage.frame.size.height + 8, 138, 50);
            cancelButton.hidden=NO;
        }
        
        if ([cancelButtonText isEqualToString:@""]) {
            [doneButton setTitleColor:[UIColor colorWithRed:245.0/255 green:90.0/255.0 blue:90.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [doneButton setTitle:doneButtonText forState:UIControlStateNormal];
        }
        else{
            [cancelButton setTitle:cancelButtonText forState:UIControlStateNormal];
            [doneButton setTitle:doneButtonText forState:UIControlStateNormal];
        }
        
        float alertViewHeight=doneButton.frame.origin.y + doneButton.frame.size.height+1;
        alertContainerView.frame=CGRectMake((transparentView.frame.size.width / 2) - 138, (transparentView.frame.size.height / 2) - (alertViewHeight / 2), 276, alertViewHeight);
        
        alertContainerView.layer.cornerRadius=cornerRadius;
        alertContainerView.layer.masksToBounds=YES;
        
        //Set bounce animation effect
        self.alertContainerView.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                    CGAffineTransformMakeScale(0.0f, 0.0f));
        self.alertContainerView.alpha = 0.0f;
        [UIView animateWithDuration:0.2f animations:^{
            //To Frame
            self.alertContainerView.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                          CGAffineTransformMakeScale(1.1f, 1.1f));
            self.alertContainerView.alpha = 1.0f;
        } completion:^(BOOL completed) {
            [UIView animateWithDuration:0.2f animations:^{
                self.alertContainerView.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                                            CGAffineTransformMakeScale(1.0f, 1.0f));
            }];
        }];
    }
    return self;
}

- (void)removeAutoLayout {
    
    transparentView.translatesAutoresizingMaskIntoConstraints = YES;
    alertContainerView.translatesAutoresizingMaskIntoConstraints = YES;
    alertSeparater.translatesAutoresizingMaskIntoConstraints = YES;
    alertMessage.translatesAutoresizingMaskIntoConstraints = YES;
    alertTitle.translatesAutoresizingMaskIntoConstraints = YES;
    cancelButton.translatesAutoresizingMaskIntoConstraints = YES;
    doneButton.translatesAutoresizingMaskIntoConstraints = YES;
}
@end
