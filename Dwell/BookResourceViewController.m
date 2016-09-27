//
//  BookResourceViewController.m
//  Dwell
//
//  Created by Ranosys on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "BookResourceViewController.h"
#import "ParcelModel.h"
#import "ResourceModel.h"
#import "UIView+RoundedCorner.h"
#import "UITextField+Validations.h"
#import "AvailableResourceViewController.h"
#import "UIView+Toast.h"

float const pickerViewHeight=260.0; //Set picker view height with toolbar height

@interface BookResourceViewController ()<UITextFieldDelegate, CustomAlertDelegate> {
    
    CustomAlert *alertView;
    NSMutableArray *bookResourceTypeArray, *bookResourceLocationArray;
    int currentFieldIndex;
    int lastSelectedResourceType,lastSelectedResourceLocation;
    UIBarButtonItem *pickerPreviousBarButton, *pickerNextBarButton,*textfieldPreviousBarButton, *textfieldNextBarButton,*dateTimePreviousBarButton, *dateTimeNextBarButton;
    UIToolbar *textFieldToolbar,*dateTimeToolbar;
}

@property (strong, nonatomic) IBOutlet UIScrollView *bookResourceScrollView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *bookResourceContainerView;
@property (strong, nonatomic) IBOutlet UITextField *sourceTypeField;
@property (strong, nonatomic) IBOutlet UITextField *sourceNameField;
@property (strong, nonatomic) IBOutlet UITextField *locationField;
@property (strong, nonatomic) IBOutlet UITextField *fromDateField;
@property (strong, nonatomic) IBOutlet UITextField *fromTimeField;
@property (strong, nonatomic) IBOutlet UITextField *toDateField;
@property (strong, nonatomic) IBOutlet UITextField *toTimeField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;

@property (strong, nonatomic) IBOutlet UIToolbar *toolBarView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *resourcePickerView;
@end

@implementation BookResourceViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Book Resource";
    [self removeAutolayout];  //Remove pickerView autolayouts
    [self initializeVaribles];  //initialize variables and customize objects
    [self addToolBarItems]; //Add textfield and dateTime tool bar view
    [self.bookResourceContainerView addShadowWithCornerRadius:self.bookResourceContainerView color:[UIColor lightGrayColor] borderColor:[UIColor whiteColor] radius:5.0f];  //Add corner radius and shadow
    //Call resource type service
    [myDelegate showIndicator:[Constants navigationColor]];
    [self performSelector:@selector(getResourcesTypeList) withObject:nil afterDelay:.1];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self hideResourcePickerView];
    [self.resourcePickerView setNeedsLayout];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Custom accessors
- (void)initializeVaribles {
    
    lastSelectedResourceType=-1;
    lastSelectedResourceLocation=-1;
    self.datePickerView.backgroundColor = [UIColor colorWithRed:(215.0/255.0) green:(215.0/255.0) blue:(215.0/255.0) alpha:1.0f];
    [self.datePickerView setMinimumDate:[NSDate date]];
    self.searchButton.layer.cornerRadius=22.0;
    self.searchButton.layer.masksToBounds=YES;
    
    if (580>([UIScreen mainScreen].bounds.size.height-64)) {
        self.mainView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 580.0);
    }
    else {
        self.mainView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
    }
    
    [self doneHandling];
}

- (void)textfieldScrollHandling:(float)keyboardHeight currentTextField:(UITextField*)currentTextField {
    
    DLog(@"%f,%f,%f",currentTextField.frame.origin.y+currentTextField.frame.size.height+15,([UIScreen mainScreen].bounds.size.height-64),([UIScreen mainScreen].bounds.size.height-64)-keyboardHeight);
    //Set condition according to check if current selected textfield is behind keyboard
    if (currentTextField.frame.origin.y+currentTextField.frame.size.height+15<([UIScreen mainScreen].bounds.size.height-64)-keyboardHeight) {
        [self.bookResourceScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else {
        [self.bookResourceScrollView setContentOffset:CGPointMake(0, ((currentTextField.frame.origin.y+currentTextField.frame.size.height+15)- ([UIScreen mainScreen].bounds.size.height-64-keyboardHeight))+5) animated:NO];
    }
    //Change content size of scroll view if current selected textfield is behind keyboard
    if (keyboardHeight-([UIScreen mainScreen].bounds.size.height-64-(self.toTimeField.frame.origin.y+self.toTimeField.frame.size.height))>0) {
        self.bookResourceScrollView.contentSize = CGSizeMake(0,[UIScreen mainScreen].bounds.size.height+(keyboardHeight-([UIScreen mainScreen].bounds.size.height-(self.toTimeField.frame.origin.y+self.toTimeField.frame.size.height))) + 60);
    }
}

//Toolbar done handling
- (void)doneHandling {
    
    self.bookResourceScrollView.contentSize=CGSizeMake(0,self.mainView.frame.size.height);
    [self.bookResourceScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)addToolBarItems {
    
    UIBarButtonItem *flexableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //Add other pickerView toolbar items
    UIBarButtonItem *pickerDoneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    pickerPreviousBarButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:105 target:self action:@selector(selectPreviousField)];
    pickerNextBarButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:106 target:self action:@selector(selectNextField)];
    //Add source name pickerView toolbar items
    UIBarButtonItem *textFieldDoneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    textfieldPreviousBarButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:105 target:self action:@selector(selectPreviousField)];
    textfieldNextBarButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:106 target:self action:@selector(selectNextField)];
    
    //Add date time pickerView toolbar items
    UIBarButtonItem *dateTimeDoneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    dateTimePreviousBarButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:105 target:self action:@selector(selectPreviousField)];
    dateTimeNextBarButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:106 target:self action:@selector(selectNextField)];
    fixedSpace.width = 22.0;//Add fixed space b/w next and previous tool bar item
    //Add other pickerview toolbar items
    [self.toolBarView setItems:[NSArray arrayWithObjects:pickerPreviousBarButton,fixedSpace,pickerNextBarButton,flexableItem,pickerDoneItem, nil]];
    //Initialize adn add textfield toolbar items
    textFieldToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44.0)];
    [textFieldToolbar setItems:[NSArray arrayWithObjects:textfieldPreviousBarButton,fixedSpace,textfieldNextBarButton,flexableItem,textFieldDoneItem, nil]];
    self.sourceNameField.inputAccessoryView=textFieldToolbar;
    
    //Initialize adn add date time pickerView toolbar items
    dateTimeToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 1000, [[UIScreen mainScreen] bounds].size.width, 44.0)];
    [dateTimeToolbar setItems:[NSArray arrayWithObjects:dateTimePreviousBarButton,fixedSpace,dateTimeNextBarButton,flexableItem,dateTimeDoneItem, nil]];
    [self.view addSubview:dateTimeToolbar];
}

- (void)removeAutolayout {
    
    self.datePickerView.translatesAutoresizingMaskIntoConstraints=YES;
    self.toolBarView.translatesAutoresizingMaskIntoConstraints=YES;
    self.resourcePickerView.translatesAutoresizingMaskIntoConstraints=YES;
    self.mainView.translatesAutoresizingMaskIntoConstraints=YES;
}
#pragma mark - end

#pragma mark - Hide/Show pickerView
- (void)showDatePickerView {

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.datePickerView.frame = CGRectMake(self.datePickerView.frame.origin.x, [[UIScreen mainScreen] bounds].size.height - self.datePickerView.frame.size.height-64, [[UIScreen mainScreen] bounds].size.width, self.datePickerView.frame.size.height);
    dateTimeToolbar.frame = CGRectMake(0, self.datePickerView.frame.origin.y-44, [[UIScreen mainScreen] bounds].size.width, dateTimeToolbar.frame.size.height);
    [UIView commitAnimations];
}

- (void)hideDatePickerView {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.datePickerView.frame=CGRectMake(0, 1000, [[UIScreen mainScreen] bounds].size.width, self.datePickerView.frame.size.height);
    dateTimeToolbar.frame=CGRectMake(0, 1000, [[UIScreen mainScreen] bounds].size.width, dateTimeToolbar.frame.size.height);
    [UIView commitAnimations];
}

- (void)showResourcePickerView:(int)selectedIndex {
    
    [self.resourcePickerView selectRow:selectedIndex inComponent:0 animated:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.resourcePickerView.frame=CGRectMake(self.resourcePickerView.frame.origin.x, [[UIScreen mainScreen] bounds].size.height - self.resourcePickerView.frame.size.height-64, [[UIScreen mainScreen] bounds].size.width, self.resourcePickerView.frame.size.height);
    self.toolBarView.frame=CGRectMake(0, self.resourcePickerView.frame.origin.y-44, [[UIScreen mainScreen] bounds].size.width, self.toolBarView.frame.size.height);
    [UIView commitAnimations];
    [self.resourcePickerView reloadAllComponents];
}

- (void)hideResourcePickerView {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.resourcePickerView.frame=CGRectMake(0, 1000, [[UIScreen mainScreen] bounds].size.width, self.resourcePickerView.frame.size.height);
    self.toolBarView.frame=CGRectMake(0, 1000, [[UIScreen mainScreen] bounds].size.width, self.toolBarView.frame.size.height);
    [UIView commitAnimations];
}
#pragma mark - end

#pragma mark - Picker view methods
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel) {
       
        pickerLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen] bounds].size.width,20)];
        pickerLabel.font = [UIFont calibriNormalWithSize:17];
        pickerLabel.textAlignment=NSTextAlignmentCenter;
    }
    NSString *str;
    if (currentFieldIndex==2) {
         str=[[bookResourceLocationArray objectAtIndex:row] resourceLocationDescription];
    }
    else if (currentFieldIndex==0) {
         str=[[bookResourceTypeArray objectAtIndex:row] resourceTypeDescription];
    }
    pickerLabel.text=str;
    return pickerLabel;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (currentFieldIndex==2) {
        return bookResourceLocationArray.count;
    }
    else if (currentFieldIndex==0) {
        return bookResourceTypeArray.count;
    }
    else {
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *str=@"";
    if (currentFieldIndex==2) {
        str=[[bookResourceLocationArray objectAtIndex:row] resourceLocationDescription];
    }
    else if (currentFieldIndex==1) {
        str=[[bookResourceTypeArray objectAtIndex:row] resourceTypeDescription];
    }
    return str;
}
#pragma mark - end

#pragma mark - Webservice
//Get resource type list webservice
- (void)getResourcesTypeList {
    
    bookResourceTypeArray=[NSMutableArray new];
    bookResourceLocationArray=[NSMutableArray new];
    if ([super checkInternetConnection]) {
        ResourceModel *resourceData=[ResourceModel sharedUser];
        [resourceData getResourceTypeOnSuccess:^(id resourceTypeData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
                bookResourceTypeArray=[resourceTypeData mutableCopy];
            });
        } onfailure:^(id error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
                if ([[error objectForKey:@"success"] isEqualToString:@"2"]) {
                    alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Something went wrong, Please try again." doneButtonText:@"OK" cancelButtonText:@""];
                }
            });
        }];
    }
    else {
        [myDelegate stopIndicator];
    }
}

//Get location list according to selected resource type webservice
- (void)getLocationList {
    
    bookResourceLocationArray=[NSMutableArray new];
    if ([super checkInternetConnection]) {
        ResourceModel *resourceData=[ResourceModel sharedUser];
        resourceData.resourceTypeLocationId=[[bookResourceTypeArray objectAtIndex:lastSelectedResourceType] resourceTypeLocationId];
        [resourceData getLocationListOnSuccess:^(id locationData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
                bookResourceLocationArray=[locationData mutableCopy];
            });
        } onfailure:^(id error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myDelegate stopIndicator];
                if ([[error objectForKey:@"success"] isEqualToString:@"2"]) {
                    alertView=[[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Something went wrong, Please try again." doneButtonText:@"OK" cancelButtonText:@""];
                }
            });
        }];
    }
    else {
        [myDelegate stopIndicator];
    }
}

- (void)searchService {
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm a"];
    NSDate *fromDateTimeTemp=[dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@",self.fromDateField.text,self.fromTimeField.text]];
    NSDate *toDateTimeTemp=[dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@",self.toDateField.text,self.toTimeField.text]];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
    ResourceModel *resourceData=[ResourceModel sharedUser];
    resourceData.resourceFromDate=[dateFormat stringFromDate:fromDateTimeTemp];
    resourceData.resourceToDate=[dateFormat stringFromDate:toDateTimeTemp];
    resourceData.resourceId=[[bookResourceTypeArray objectAtIndex:lastSelectedResourceType] resourceId];
//    resourceData.resourceFromDate=@"2016-09-22T12:00:00"; //Set for testing purpose
//    resourceData.resourceToDate=@"2016-09-22T13:00:00";   //Set for testing purpose
    resourceData.resourceDescription=self.sourceNameField.text;
    [resourceData getBookedResourcesOnSuccess:^(id availableResourceData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate stopIndicator];
            if ([availableResourceData count]!=0) {
                AvailableResourceViewController *objAvailableResource = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AvailableResourceViewController"];
                objAvailableResource.availableResourceData=[availableResourceData mutableCopy];
                objAvailableResource.selectedFromDataTime=resourceData.resourceFromDate;
                objAvailableResource.selectedToDataTime=resourceData.resourceToDate;
                objAvailableResource.selectedResourceId=resourceData.resourceId;
                [self.navigationController pushViewController:objAvailableResource animated:YES];
            }
            else {
                alertView=[[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"No resources available for this name or time range." doneButtonText:@"OK" cancelButtonText:@""];
            }
        });
    } onfailure:^(id error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myDelegate stopIndicator];
            if ([[error objectForKey:@"success"] isEqualToString:@"2"]) {
                alertView=[[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Something went wrong, Please try again." doneButtonText:@"OK" cancelButtonText:@""];
            }
        });
    }];
}
#pragma mark - end

#pragma mark - Textfield delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    currentFieldIndex=1;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self doneHandling];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    //Set field position after show keyboard
    NSDictionary* info = [notification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    //Textfield scroll handling
    [self textfieldScrollHandling:[aValue CGRectValue].size.height currentTextField:self.sourceNameField];
}
#pragma mark - end

#pragma mark - Textfield navigation
//Moving one input field to another field
- (void)navigateTextFields:(int)selectType {
    
    //Initially set enabled all toolbar items
    pickerPreviousBarButton.enabled=true;
    pickerNextBarButton.enabled=true;
    dateTimeNextBarButton.enabled=true;
    dateTimePreviousBarButton.enabled=true;
    if (currentFieldIndex==0) { //Resource type
        
        [self.view endEditing:YES];
        [self hideDatePickerView];
        if (bookResourceTypeArray.count!=0) {
            pickerPreviousBarButton.enabled=false;
            pickerNextBarButton.enabled=true;
            [self showResourcePickerView:(lastSelectedResourceType==-1?0:lastSelectedResourceType)];    //Use tenary operator to check value is -1 or not
            [self textfieldScrollHandling:pickerViewHeight currentTextField:self.sourceTypeField];
        }
    }
    else if (currentFieldIndex==1) {    //Resource name
        [self hideResourcePickerView];
        [self hideDatePickerView];
        [self.sourceNameField becomeFirstResponder];
    }
    else if (currentFieldIndex==2) {    //Resource location
        [self.view endEditing:YES];
        [self hideDatePickerView];
        if (bookResourceLocationArray.count!=0) {
            [self showResourcePickerView:(lastSelectedResourceLocation==-1?0:lastSelectedResourceLocation)];    //Use tenary operator to check value is -1 or not
            [self textfieldScrollHandling:pickerViewHeight currentTextField:self.locationField];
        }
        else {  //If location array is blank then hide picker view if it is showing
            [self hideResourcePickerView];
            if (![self.sourceTypeField.text isEqualToString:@""]) {
                [self.view makeToast:@"Please set first resource type field"];
            }
            else {
                [self.view makeToast:@"No location available"];
            }
        }
    }
    else if (currentFieldIndex==3) {    //Resource from date
        [self.view endEditing:YES];
        [self hideResourcePickerView];
        self.datePickerView.datePickerMode=UIDatePickerModeDate;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        NSDate *date;
        if (![self.fromDateField.text isEqualToString:@""]) {
            date = [dateFormat dateFromString:self.fromDateField.text];
        }
        else {
            date = [NSDate date];
        }
        [self.datePickerView setDate:date];
        
        [self showDatePickerView];
        [self textfieldScrollHandling:pickerViewHeight currentTextField:self.fromDateField];
    }
    else if (currentFieldIndex==4) {    //Resource from time
        [self.view endEditing:YES];
        [self hideResourcePickerView];
        if ([self.fromDateField.text isEqualToString:@""]) {
            [self.view makeToast:@"Please set first fromDate"];
        }
        else {
            self.datePickerView.datePickerMode=UIDatePickerModeTime;
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm"];
            //Set seconds zero in current date
            NSTimeInterval time = floor([[dateFormat dateFromString:[dateFormat stringFromDate:[NSDate date]]] timeIntervalSinceReferenceDate] / 60.0) * 60.0;
            NSDate *date;
            DLog(@"%@,%@,%@",[dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@",self.fromDateField.text,[[self.fromTimeField.text componentsSeparatedByString:@" "] objectAtIndex:0]]],[[self.fromTimeField.text componentsSeparatedByString:@" "] objectAtIndex:0],[NSDate dateWithTimeIntervalSinceReferenceDate:time]);
            if (![self.fromTimeField.text isEqualToString:@""]&&([[dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@",self.fromDateField.text,[[self.fromTimeField.text componentsSeparatedByString:@" "] objectAtIndex:0]]] compare:[NSDate dateWithTimeIntervalSinceReferenceDate:time]]!=NSOrderedAscending)) {//if([startDate compare: endDate] == NSOrderedDescending) // if start is later in time than end
                [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm a"];
                date = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@",self.fromDateField.text,self.fromTimeField.text]];
            }
            else {
                date = [NSDate date];
            }
            [self.datePickerView setDate:date];
            
            [self showDatePickerView];
            [self textfieldScrollHandling:pickerViewHeight currentTextField:self.fromTimeField];
        }
    }
    else if (currentFieldIndex==5) {    //Resource to date
        [self.view endEditing:YES];
        [self hideResourcePickerView];
        self.datePickerView.datePickerMode=UIDatePickerModeDate;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        NSDate *date;
        if (![self.toDateField.text isEqualToString:@""]) {
            date = [dateFormat dateFromString:self.toDateField.text];
        }
        else {
            date = [NSDate date];
        }
        [self.datePickerView setDate:date];
        
        [self showDatePickerView];
        [self textfieldScrollHandling:pickerViewHeight currentTextField:self.toDateField];
    }
    else if (currentFieldIndex==6) {    //Resource to time
        [self.view endEditing:YES];
        [self hideResourcePickerView];
        if ([self.toDateField.text isEqualToString:@""]) {
            [self.view makeToast:@"Please set first toDate"];
        }
        else {
            dateTimeNextBarButton.enabled=false;
            dateTimePreviousBarButton.enabled=true;
            self.datePickerView.datePickerMode=UIDatePickerModeTime;
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm"];
            NSTimeInterval time = floor([[dateFormat dateFromString:[dateFormat stringFromDate:[NSDate date]]] timeIntervalSinceReferenceDate] / 60.0) * 60.0;
            NSDate *date;
            DLog(@"%@,%@,%@",[dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@",self.toDateField.text,[[self.toTimeField.text componentsSeparatedByString:@" "] objectAtIndex:0]]],[[self.toTimeField.text componentsSeparatedByString:@" "] objectAtIndex:0],[NSDate dateWithTimeIntervalSinceReferenceDate:time]);
            if (![self.toTimeField.text isEqualToString:@""]&&([[dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@",self.toDateField.text,[[self.toTimeField.text componentsSeparatedByString:@" "] objectAtIndex:0]]] compare:[NSDate dateWithTimeIntervalSinceReferenceDate:time]]!=NSOrderedAscending)) {//if([startDate compare: endDate] == NSOrderedDescending) // if start is later in time than end
                [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm a"];
                date = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@",self.toDateField.text,self.toTimeField.text]];
            }
            else {
                date = [NSDate date];
            }
            [self.datePickerView setDate:date];
            [self showDatePickerView];
            [self textfieldScrollHandling:pickerViewHeight currentTextField:self.toTimeField];
        }
    }
}
#pragma mark - end

#pragma mark - IBActions
- (void)selectPreviousField {
    
    currentFieldIndex=currentFieldIndex-1;
    [self navigateTextFields:-1];
}

- (void)selectNextField {
    currentFieldIndex=currentFieldIndex+1;
    [self navigateTextFields:1];
}

- (void)doneButtonPressed:(id)sender {
    
    if (currentFieldIndex==0) {
        [self hideResourcePickerView];
        NSInteger index = [self.resourcePickerView selectedRowInComponent:0];
        NSString *str=[[bookResourceTypeArray objectAtIndex:index] resourceTypeDescription];
        self.sourceTypeField.text=str;
        if (lastSelectedResourceType!=(int)index) {
            lastSelectedResourceType=(int)index;
            [myDelegate showIndicator:[Constants navigationColor]];
            [self performSelector:@selector(getLocationList) withObject:nil afterDelay:.1];
        }
    }
    else if (currentFieldIndex==1) {
        [self.view endEditing:YES];
    }
    else if (currentFieldIndex==2) {
        [self hideResourcePickerView];
        NSInteger index = [self.resourcePickerView selectedRowInComponent:0];
        NSString *str=[[bookResourceLocationArray objectAtIndex:index] resourceLocationDescription];
        self.locationField.text=str;
        lastSelectedResourceLocation=(int)index;
    }
    else if (currentFieldIndex==3) {
        [self hideDatePickerView];
        
        NSDate *date = self.datePickerView.date;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        DLog(@"%@",[dateFormat stringFromDate:date]);
        self.fromDateField.text=[dateFormat stringFromDate:date];
    }
    else if (currentFieldIndex==4) {
        [self hideDatePickerView];
        NSDate *date = self.datePickerView.date;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"hh:mm a"];
        DLog(@"%@",[dateFormat stringFromDate:date]);
        self.fromTimeField.text=[dateFormat stringFromDate:date];
    }
    else if (currentFieldIndex==5) {
        [self hideDatePickerView];
        
        NSDate *date = self.datePickerView.date;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        DLog(@"%@",[dateFormat stringFromDate:date]);
        self.toDateField.text=[dateFormat stringFromDate:date];
    }
    else if (currentFieldIndex==6) {
        [self hideDatePickerView];
        NSDate *date = self.datePickerView.date;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"hh:mm a"];
        //        [dateFormat setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
        DLog(@"%@",[dateFormat stringFromDate:date]);
        self.toTimeField.text=[dateFormat stringFromDate:date];
    }
    [self doneHandling];
}

- (IBAction)sourceType:(UIButton *)sender {
    currentFieldIndex=0;
    [self navigateTextFields:0];
}

- (IBAction)location:(UIButton *)sender {
    currentFieldIndex=2;
    [self navigateTextFields:0];
}

- (IBAction)fromDate:(UIButton *)sender {
    currentFieldIndex=3;
    [self navigateTextFields:0];
}

- (IBAction)fromTime:(UIButton *)sender {
    currentFieldIndex=4;
    [self navigateTextFields:0];
}

- (IBAction)todate:(UIButton *)sender {
    currentFieldIndex=5;
    [self navigateTextFields:0];
}

- (IBAction)toTime:(UIButton *)sender {
    currentFieldIndex=6;
    [self navigateTextFields:0];
}

- (IBAction)search:(UIButton *)sender {
    
    [self.view endEditing:YES];
    [self hideResourcePickerView];
    [self hideDatePickerView];
    [self doneHandling];
    //Perform login validations
    if([self performValidationsForSearch]) {
        if ([super checkInternetConnection]) {
            [myDelegate showIndicator:[Constants navigationColor]];
            [self performSelector:@selector(searchService) withObject:nil afterDelay:.1];
        }
    }
}
#pragma mark - end

#pragma mark - Perform validation for search action
- (BOOL)performValidationsForSearch {

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm"];
    //Set time with zero seconds
    NSTimeInterval time = floor([[dateFormat dateFromString:[dateFormat stringFromDate:[NSDate date]]] timeIntervalSinceReferenceDate] / 60.0) * 60.0;
    NSDate *fromDateTime=[dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@",self.fromDateField.text,[[self.fromTimeField.text componentsSeparatedByString:@" "] objectAtIndex:0]]];
    NSDate *toDateTime=[dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@",self.toDateField.text,[[self.toTimeField.text componentsSeparatedByString:@" "] objectAtIndex:0]]];
    //Get time differece between from and to date time
    float timeDifferenceInSecond=[[self timeLeftSinceDate:fromDateTime toDateTime:toDateTime] floatValue];
    DLog(@"%f",timeDifferenceInSecond/3600.0);
    
    if ([self.sourceTypeField isEmpty]||[self.locationField isEmpty]||[self.fromDateField isEmpty]||[self.fromTimeField isEmpty]||[self.toTimeField isEmpty]||[self.toDateField isEmpty]) { //If fields are empty and source name field is optional
         alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Please fill in all the required fields." doneButtonText:@"OK" cancelButtonText:@""];
        return false;
    }
    else if ([fromDateTime compare:[NSDate dateWithTimeIntervalSinceReferenceDate:time]]==NSOrderedAscending) { //If fromDateTime field value is less than current dateTime
        alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"From date is not less than current date time." doneButtonText:@"OK" cancelButtonText:@""];
        return false;
    }
    else if ([toDateTime compare:[NSDate dateWithTimeIntervalSinceReferenceDate:time]]==NSOrderedAscending) {   //If toDateTime field value is less than current dateTime
        alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"To date is not less than current date time" doneButtonText:@"OK" cancelButtonText:@""];
        return false;
    }
    else if(timeDifferenceInSecond<0.0){    //If selected dateTime(fromDateTime and toDateTime) difference is less than 0 means toDateTIme is less than fromDateTime
        alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Please select correct date time" doneButtonText:@"OK" cancelButtonText:@""];
        return false;
    }
    else if(timeDifferenceInSecond==0.0){   //If selected dateTime(fromDateTime and toDateTime) difference is 0 means toDateTIme is equal to fromDateTime
        alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Can't select same date time" doneButtonText:@"OK" cancelButtonText:@""];
        return false;
    }
    else if((timeDifferenceInSecond/3600.0)<[[[bookResourceTypeArray objectAtIndex:lastSelectedResourceType] resourceTypeMinHour] floatValue]){  //If selected dateTime(fromDateTime and toDateTime) difference is less than selected resource minimum hour
        alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Can't select same date time" doneButtonText:@"OK" cancelButtonText:@""];
        return false;
    }
    else if((timeDifferenceInSecond/3600.0)>[[[bookResourceTypeArray objectAtIndex:lastSelectedResourceType] resourceTypeMaxHour] floatValue]){ //If selected dateTime(fromDateTime and toDateTime) difference is greater than selected resource maximum hour
        alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Can't select same date time" doneButtonText:@"OK" cancelButtonText:@""];
        return false;
    }
    return true;
}

- (NSString*)timeLeftSinceDate:(NSDate *)fromDateTime toDateTime:(NSDate *)toDateTime {
    
    NSString *timeLeft = @"";
    NSInteger seconds = [fromDateTime timeIntervalSinceDate:toDateTime];
        timeLeft =[NSString stringWithFormat: @"%ld", (long)seconds*-1];
    return timeLeft;
}
#pragma mark - end

#pragma mark - Custom alert delegates
- (void)customAlertDelegateAction:(CustomAlert *)customAlert option:(int)option{
    
    [alertView dismissAlertView];
}
#pragma mark - end
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
