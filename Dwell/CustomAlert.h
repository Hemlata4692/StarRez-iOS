//
//  CustomAlert.h
//  Dwell
//
//  Created by Ranosys on 14/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomAlertView.h"

@protocol CustomAlertDelegate <NSObject>
@optional
- (void) customAlertDelegateAction:(CustomAlertView*)alertView option:(int)option;
- (void) OncallDelegateMethod;
@end

@interface CustomAlert : NSObject{
    id <CustomAlertDelegate> _delegate;
    CustomAlertView *customAlertObject;
}
@property (nonatomic,strong) id delegate;

-(void)dismissAlertView;
- (instancetype)initWithTitle:(NSString*)titleText tagValue:(int)tagValue delegate:(id)delegate message:(NSString*)messageText doneButtonText:(NSString*)doneButtonText cancelButtonText:(NSString*)cancelButtonText;
@property(nonatomic,retain)UIView *yourView;

@end