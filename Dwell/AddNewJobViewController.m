//
//  AddNewJobViewController.m
//  StarrezDemo
//
//  Created by Monika Sharma on 21/09/16.
//  Copyright © 2016 Monika Sharma. All rights reserved.
//

#import "AddNewJobViewController.h"
#import "BSKeyboardControls.h"
#import "UITextField+Validations.h"
#import "Internet.h"
#import "UIView+RoundedCorner.h"
#import "MainatenanceModel.h"
@interface AddNewJobViewController ()<UITextFieldDelegate,BSKeyboardControlsDelegate>{
   
    NSArray *addNewJobTextFieldArray;
    NSMutableArray *categoryArray;
     NSMutableArray *subcategoryArray;
    CustomAlert *alertView;
    BOOL isCategoryPicker;
    int categoryPickerIndex;
    int subcategoryPickerIndex;
    
    NSString *catId;
    NSString *subCatId;
    NSString *isPresent;
    
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIView *addJobContainerView;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
@property (weak, nonatomic) IBOutlet UITextField *itemTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *causeTextField;
@property (weak, nonatomic) IBOutlet UITextField *commentsTextField;
@property (weak, nonatomic) IBOutlet UIImageView *checkboxImageView;
@property (weak, nonatomic) IBOutlet UIButton *checkboxButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

//Declare BSKeyboard variable
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *pickerToolBar;

@end

@implementation AddNewJobViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"New Job";
    //Adding textfield to keyboard controls array
    addNewJobTextFieldArray = @[self.descriptionTextField,self.causeTextField,self.commentsTextField];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:addNewJobTextFieldArray]];
    [self.keyboardControls setDelegate:self];
    
    //Add corner radius
    [self addCornerRadius];
    [myDelegate showIndicator:[Constants orangeBackgroundColor]];
    //Get category list from server.
    [self performSelector:@selector(categoryService) withObject:nil afterDelay:.1];
    categoryArray=[[NSMutableArray alloc] init];
    subcategoryArray = [[NSMutableArray alloc]init];
    
    categoryPickerIndex =-1;
    subcategoryPickerIndex = -1;
    _commentsTextField.text = @"";
    isPresent = @"0";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.pickerView.translatesAutoresizingMaskIntoConstraints=YES;
    self.pickerToolBar.translatesAutoresizingMaskIntoConstraints=YES;
}

- (void)addCornerRadius
{
    [self.saveButton.layer setCornerRadius:22];
    [self.addJobContainerView addShadowWithCornerRadius:self.addJobContainerView color:[UIColor lightGrayColor] borderColor:[UIColor whiteColor] radius:5.0f];  //Add corner radius and shadow
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Webservice

- (void)categoryService{
    
    if ([super checkInternetConnection]) {
        MainatenanceModel *mainatenanceData = [MainatenanceModel sharedUser];
        [mainatenanceData getCategoryListOnSuccess:^(id userData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                categoryArray = [userData mutableCopy];
                [myDelegate stopIndicator];
                
            });
        } onfailure:^(id error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
                if ([[error objectForKey:@"success"] isEqualToString:@"0"]) {
                    DLog(@"No record found.");
                    
                }
                else {
                    alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Something went wrong, Please try again." doneButtonText:@"OK" cancelButtonText:@""];
                }
            });
        }];
    }
}

- (void)subCategoryService :(NSString *)categoryId {
    
    if ([super checkInternetConnection]) {
        MainatenanceModel *mainatenanceData = [MainatenanceModel sharedUser];
        [UserDefaultManager setValue:categoryId key:@"categoryId"];
        [mainatenanceData getSubCategoryListOnSuccess:^(id userData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
                subcategoryArray = [userData mutableCopy];
            });
        } onfailure:^(id error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
                if ([[error objectForKey:@"success"] isEqualToString:@"0"]) {
                    DLog(@"No record found.");
                    
                }
                else {
                    alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Something went wrong, Please try again." doneButtonText:@"OK" cancelButtonText:@""];
                }
            });
        }];
    }
}

- (void)saveJob{
    
     MainatenanceModel *userData = [MainatenanceModel sharedUser];
    userData.maintenenceId =catId;
    userData.subcategoryId = subCatId;
    userData.detail =self.descriptionTextField.text;
    userData.cause = self.causeTextField.text;
    userData.commetns = self.commentsTextField.text;
    userData.isPresent = isPresent;
    if ([super checkInternetConnection]) {
        [userData saveMainatenanceJobOnSuccess:^(MainatenanceModel *userData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
                alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Your request has been submitted successfully." doneButtonText:@"OK" cancelButtonText:@""];
                
            });
        } onfailure:^(id error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
                if ([[error objectForKey:@"success"] isEqualToString:@"0"]) {
                    alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Something went wrong, Please try again." doneButtonText:@"OK" cancelButtonText:@""];
                }
                else {
                    alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Something went wrong, Please try again." doneButtonText:@"OK" cancelButtonText:@""];
                }
            });
        }];
    }
}
#pragma mark - end

#pragma mark - Keyboard control delegate
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction {
    
    UIView *view;
    view = field.superview.superview.superview;
}
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls {
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [keyboardControls.activeField resignFirstResponder];
}
#pragma mark - end

#pragma mark - Textfield delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self.keyboardControls setActiveField:textField];
    [self hidePickerWithAnimation];
    CGSize result = [[UIScreen mainScreen] bounds].size;
    //Change scrollview scrolling offset according to the screen size and current active field.
    if(result.height < 568) {
        [self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-110) animated:YES];
    } else if (result.height == 568) {
        [self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-200) animated:YES];
    } else if (result.height > 568) {
        if (textField==self.commentsTextField) {
            [self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-300) animated:YES];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == _commentsTextField)
    {
        if (range.length > 0 && [string length] == 0)
        {
            return YES;
        }
        if (textField.text.length > 40 && range.length == 0)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else if(textField == _causeTextField)
    {
        if (range.length > 0 && [string length] == 0)
        {
            return YES;
        }
        if (textField.text.length > 100 && range.length == 0)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)checkboxButtonClicked:(id)sender {
    if ([sender isSelected])
    {
        isPresent  = @"0";
        [sender setSelected:NO];
        [_checkboxImageView setImage:[UIImage imageNamed:@"checkbox.png"]];
    }
    else
    {
         isPresent  = @"1";
        [sender setSelected:YES];
        [_checkboxImageView setImage:[UIImage imageNamed:@"checkbox_selected.png"]];
    }
}
#pragma mark - end

#pragma mark - Login validation
- (BOOL)performValidationsForAddNewJob {
    
    //Apply validations for mandatory fields. Comments and tick mark are not mandatory.
    if ([self.categoryTextField isEmpty] || [self.itemTextField isEmpty]|| [self.descriptionTextField isEmpty]|| [self.causeTextField isEmpty]) {
        alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Please fill in all the required fields." doneButtonText:@"OK" cancelButtonText:@""];
        return NO;
    }
    else {
        return YES;
    }
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)selectCategoryButtonClicked:(id)sender {
    
    isCategoryPicker = YES;
    [self.keyboardControls.activeField resignFirstResponder];
    [self.pickerView setNeedsLayout];
    self.scrollView.scrollEnabled = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [self.pickerView reloadAllComponents];
    if (categoryPickerIndex>=0) {
        [self.pickerView selectRow:categoryPickerIndex inComponent:0 animated:YES];
    }
    self.pickerView.frame = CGRectMake(self.pickerView.frame.origin.x, self.view.bounds.size.height-self.pickerView.frame.size.height , self.view.bounds.size.width, self.pickerView.frame.size.height);
    self.pickerToolBar.frame = CGRectMake(self.pickerToolBar.frame.origin.x, self.pickerView.frame.origin.y-44, self.view.bounds.size.width, self.pickerToolBar.frame.size.height);
    [UIView commitAnimations];
}

- (IBAction)selectItemButtonClicked:(id)sender {
    
    isCategoryPicker = NO;
    [self.keyboardControls.activeField resignFirstResponder];
    [self.pickerView setNeedsLayout];
    self.scrollView.scrollEnabled = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [self.pickerView reloadAllComponents];
    if (categoryPickerIndex>=0) {
        [self.pickerView selectRow:subcategoryPickerIndex inComponent:0 animated:YES];
    }
    self.pickerView.frame = CGRectMake(self.pickerView.frame.origin.x, self.view.bounds.size.height-self.pickerView.frame.size.height , self.view.bounds.size.width, self.pickerView.frame.size.height);
    self.pickerToolBar.frame = CGRectMake(self.pickerToolBar.frame.origin.x, self.pickerView.frame.origin.y-44, self.view.bounds.size.width, self.pickerToolBar.frame.size.height);
    [UIView commitAnimations];
}

- (IBAction)savebuttonClicked:(id)sender {
    
    [self.keyboardControls.activeField resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    Internet *internet=[[Internet alloc] init];
    //perform add new job validations
    if([self performValidationsForAddNewJob]) {
        if (![internet start]) {
            
            [myDelegate showIndicator:nil];
            [self performSelector:@selector(saveJob) withObject:nil afterDelay:0.1];
        }
    }
}

- (IBAction)pickerToolBarDoneClicked:(id)sender {
   
    //This check determines which picker should response i.e. which field should be filled: category or subcategory.
    if (isCategoryPicker) {
        NSInteger index = [self.pickerView selectedRowInComponent:0];
        MainatenanceModel *model = [categoryArray objectAtIndex:index];
        categoryPickerIndex = (int)index;
        NSString *str=model.title;
        catId = model.maintenenceId;
        //This check avoids frequent service calling in case if we are selecting the same category.
        if (![self.categoryTextField.text isEqualToString:str]) {
           //Fetch subcategory on basis of selected category.
            self.categoryTextField.text=str;
            self.itemTextField.text = @"";
            [myDelegate showIndicator:nil];
            [self performSelector:@selector(subCategoryService:) withObject:model.maintenenceId afterDelay:0.1];
            
        }else{
            
            self.categoryTextField.text=str;
            
        }
        
        
    } else {
        //code to set value on subcategory field
        NSInteger index = [self.pickerView selectedRowInComponent:0];
        MainatenanceModel *model = [subcategoryArray objectAtIndex:index];
        subcategoryPickerIndex = (int)index;
        NSString *str=model.subcategory;
        subCatId = model.subcategoryId;
        self.itemTextField.text=str;
    }
    [self hidePickerWithAnimation];
}

#pragma mark - end

#pragma mark - Picker View methods
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
   
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,600,20)];
        pickerLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
        pickerLabel.textAlignment=NSTextAlignmentCenter;
    }
    MainatenanceModel *model;
    NSString *str;
    if (isCategoryPicker) {
    model = [categoryArray objectAtIndex:row];
        str=model.title;
    }else{
        model = [subcategoryArray objectAtIndex:row];
        str=model.subcategory;
    }
    
    pickerLabel.text=str;
    return pickerLabel;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (isCategoryPicker) {
        return categoryArray.count;
    }else{
        return subcategoryArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    [_keyboardControls.activeField resignFirstResponder];
    
    MainatenanceModel *model;
    NSString *str;
    if (isCategoryPicker) {
        model = [categoryArray objectAtIndex:row];
        str=model.title;
    }else{
        model = [subcategoryArray objectAtIndex:row];
        str=model.subcategory;
    }
    return str;
}

- (void)hidePickerWithAnimation
{
    self.scrollView.scrollEnabled = YES;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.pickerView.frame = CGRectMake(self.pickerView.frame.origin.x, 1000, self.view.bounds.size.width, self.pickerView.frame.size.height);
    self.pickerToolBar.frame = CGRectMake(self.pickerToolBar.frame.origin.x, 1000, self.view.bounds.size.width, self.pickerToolBar.frame.size.height);
    [UIView commitAnimations];
}
#pragma mark - end

#pragma mark - Custom alert delegates
- (void)customAlertDelegateAction:(CustomAlert *)customAlert option:(int)option{
    
    [alertView dismissAlertView];
}
#pragma mark - end

@end
