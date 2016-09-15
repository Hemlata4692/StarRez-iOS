//
//  ViewController.m
//  Dwell
//
//  Created by Ranosys on 13/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "LoginViewController.h"
#import "BSKeyboardControls.h"
#import "UIImage+deviceSpecificMedia.h"
#import "UITextField+Validations.h"
#import "UIView+RoundedCorner.h"
#import "LoginModel.h"

@interface LoginViewController ()<BSKeyboardControlsDelegate,CustomAlertDelegate> {

    CustomAlert *alertView;
    NSArray *loginTextFieldArray;
    UITextField *currentSelectedTextField;
}

@property (strong, nonatomic) IBOutlet UIImageView *loginBackgroundImage;
@property (strong, nonatomic) IBOutlet UIScrollView *loginScrollView;
@property (strong, nonatomic) IBOutlet UIView *loginContainerView;
@property (strong, nonatomic) IBOutlet UITextField *emailIdTextfield;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
//Declare BSKeyboard variable
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;
@end

@implementation LoginViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
   
    //Hide navigation bar and status bar
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
//     [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    //Adding textfield to keyboard controls array
    loginTextFieldArray = @[self.emailIdTextfield,self.passwordTextfield];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:loginTextFieldArray]];
    [self.keyboardControls setDelegate:self];
    
    //Set background image according to device
    UIImage * tempImg =[UIImage imageNamed:@"login"];
    self.loginBackgroundImage.image=[UIImage imageNamed:[tempImg imageForDeviceWithName:@"login"]];
    
    //add corner radius
    [self addBorderCornerRadius];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Custom accessors
//add corner radius to objects
- (void)addBorderCornerRadius {
    
    [self.emailIdTextfield setCornerRadius:cornerRadius];
    [self.passwordTextfield setCornerRadius:cornerRadius];
    [self.loginButton setCornerRadius:cornerRadius];
}
#pragma mark - end

#pragma mark - Keyboard control delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction {
    
    UIView *view;
    view = field.superview.superview.superview;
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls {
    
    [self.loginScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [keyboardControls.activeField resignFirstResponder];
}
#pragma mark - end

#pragma mark - Textfield delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self.keyboardControls setActiveField:textField];
    currentSelectedTextField=textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.loginScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    //Set field position after show keyboard
    NSDictionary* info = [notification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    //Set condition according to check if current selected textfield is behind keyboard
    if (currentSelectedTextField.frame.origin.y+currentSelectedTextField.frame.size.height<([UIScreen mainScreen].bounds.size.height)-[aValue CGRectValue].size.height) {
        [self.loginScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else {
        [self.loginScrollView setContentOffset:CGPointMake(0, ((currentSelectedTextField.frame.origin.y+currentSelectedTextField.frame.size.height)- ([UIScreen mainScreen].bounds.size.height-[aValue CGRectValue].size.height))+5) animated:NO];
    }
    
    //Change content size of scroll view if current selected textfield is behind keyboard
    if ([aValue CGRectValue].size.height-([UIScreen mainScreen].bounds.size.height-(self.passwordTextfield.frame.origin.y+self.passwordTextfield.frame.size.height))>0) {
        self.loginScrollView.contentSize = CGSizeMake(0,[UIScreen mainScreen].bounds.size.height+([aValue CGRectValue].size.height-([UIScreen mainScreen].bounds.size.height-(self.passwordTextfield.frame.origin.y+self.passwordTextfield.frame.size.height))) + 60);
    }
}
#pragma mark - end

#pragma mark - Login validation
- (BOOL)performValidationsForLogin {
    
    if ([self.emailIdTextfield isEmpty] || [self.passwordTextfield isEmpty]) {
        alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Please fill in all the fields." doneButtonText:@"OK" cancelButtonText:@""];
        return NO;
    }
    else if (![self.emailIdTextfield isValidEmail]) {
        alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Invalid email address." doneButtonText:@"OK" cancelButtonText:@""];
        return NO;
    }
    else if (self.passwordTextfield.text.length!=6) {
        alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Password length must be 6 digit." doneButtonText:@"OK" cancelButtonText:@""];
        return NO;
    }
    else {
        return YES;
    }
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)login:(UIButton *)sender {
//    NSMutableDictionary*a=[NSMutableDictionary new];
//    NSMutableArray*b;
//    [a setObject:b forKey:@"a"];
    [self.keyboardControls.activeField resignFirstResponder];
    [self.loginScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    //perform login validations
    if([self performValidationsForLogin]) {
        [myDelegate showIndicator:[Constants dashboardColor]];
        [self performSelector:@selector(userLogin) withObject:nil afterDelay:.1];
    }
}
#pragma mark - end

#pragma mark - Webservice
//User login webservice called
- (void)userLogin {
    
    LoginModel *userLogin = [LoginModel sharedUser];
    userLogin.userEmailId = self.emailIdTextfield.text;
    userLogin.password = self.passwordTextfield.text;
    [userLogin loginUserOnSuccess:^(LoginModel *userData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate stopIndicator];
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [UserDefaultManager setValue:[NSNumber numberWithInteger:0] key:@"indexpath"];
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController * objReveal = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
            myDelegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            [myDelegate.window setRootViewController:objReveal];
            [myDelegate.window setBackgroundColor:[UIColor whiteColor]];
            [myDelegate.window makeKeyAndVisible];
        });
    } onfailure:^(id error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate stopIndicator];
            if ([[error objectForKey:@"success"] isEqualToString:@"0"]) {
                alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Invalid user." doneButtonText:@"OK" cancelButtonText:@""];
            }
            else {
                alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Something went wrong, Please try again." doneButtonText:@"OK" cancelButtonText:@""];
            }
        });
    }];
}
#pragma mark - end

#pragma mark - MyAlert delegates
- (void)customAlertDelegateAction:(CustomAlert *)myAlert option:(int)option{
    
    [alertView dismissAlertView];
}
#pragma mark - end
@end
