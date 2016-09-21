//
//  UITextField+Padding.m
//  Sure
//
//  Created by Hema on 25/03/15.
//  Copyright (c) 2015 Shivendra. All rights reserved.
//

#import "UITextField+Padding.h"

@implementation UITextField (Padding)

//Set textfield padding without side image
- (void)addTextFieldPadding: (UITextField *)textfield {
    
    UIView *rightPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    textfield.rightView = rightPadding;
    textfield.rightViewMode = UITextFieldViewModeAlways;
}

- (void)removeTextFieldPadding: (UITextField *)textfield {
    
    UIView *rightPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    textfield.rightView = rightPadding;
    textfield.rightViewMode = UITextFieldViewModeAlways;
}

//Set textfield padding with side image
- (void)addTextFieldPaddingWithoutImages: (UITextField *)textfield {
    
    UIView *leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    textfield.leftView = leftPadding;
    textfield.leftViewMode = UITextFieldViewModeAlways;    
}
@end
