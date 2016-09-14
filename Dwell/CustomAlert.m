//
//  CustomAlert.m
//  Dwell
//
//  Created by Ranosys on 14/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "CustomAlert.h"

@implementation CustomAlert
@synthesize yourView;

#pragma mark - Called for simple alert and with textview
- (instancetype)initWithTitle:(NSString*)titleText tagValue:(int)tagValue delegate:(id)delegate message:(NSString*)messageText doneButtonText:(NSString*)doneButtonText cancelButtonText:(NSString*)cancelButtonText {
    
    _delegate=delegate;
    customAlertObject=[[CustomAlertView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) title:titleText message:messageText doneButtonText:doneButtonText cancelButtonText:cancelButtonText];
    customAlertObject.tag=tagValue;
    customAlertObject.mainView.backgroundColor=[UIColor clearColor];
    [customAlertObject.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [customAlertObject.doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    yourView = [[UIApplication sharedApplication] keyWindow].rootViewController.view;
    [[[UIApplication sharedApplication] keyWindow].rootViewController.view addSubview:customAlertObject.mainView];
    
    return self;
}
#pragma mark - end


#pragma mark - Remove alert view from superview
-(void)dismissAlertView{
    
    customAlertObject.mainView.hidden = YES;
    [customAlertObject.mainView removeFromSuperview];
    [customAlertObject removeFromSuperview];
}
#pragma mark - end

#pragma mark - Alert actions
- (IBAction)cancelAction:(UIButton *)sender {
    
    [_delegate customAlertDelegateAction:customAlertObject option:0];
}

- (IBAction)doneAction:(UIButton *)sender {
    
    [_delegate customAlertDelegateAction:customAlertObject option:1];
}
#pragma mark - end
@end
