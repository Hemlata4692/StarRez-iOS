//
//  BookResourceViewController.m
//  Dwell
//
//  Created by Ranosys on 20/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "BookResourceViewController.h"
#import "BookResourceCell.h"
#import "ParcelModel.h"
#import "ResourceModel.h"

@interface BookResourceViewController ()<UITextFieldDelegate>{
    
    CustomAlert *alertView;
    NSMutableArray *bookResourceTypeArray, *bookResourceLocationArray;
    NSArray *inputFieldTitleArray;
    int currentFieldIndex;
    int lastSelectedResourceType,lastSelectedResourceLocation;
    UIBarButtonItem *pickerPreviousBarButton, *pickerNextBarButton,*textfieldPreviousBarButton, *textfieldNextBarButton;
    UIToolbar *textFieldToolbar;
}
@property (weak, nonatomic) IBOutlet UITableView *bookResourceFormTableView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBarView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *resourcePickerView;
@end

@implementation BookResourceViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Book Resource";
    //Add background image
    [super addBackgroungImage:@"Resource"];
    bookResourceLocationArray=[NSMutableArray new];
    
    lastSelectedResourceType=-1;
    lastSelectedResourceLocation=-1;
    bookResourceLocationArray=[NSMutableArray new];
    inputFieldTitleArray=@[@"RESOURCE TYPE",@"RESOURCE NAME",@"LOCATION",@"FROM",@"TO"];
    [self removePickerViewAutolayout];
    [self hideDatePickerView];
    [self hideResourcePickerView];
    [self addToolBarItems];
    self.datePickerView.backgroundColor = [UIColor colorWithRed:(215.0/255.0) green:(215.0/255.0) blue:(215.0/255.0) alpha:1.0f];
    [self.datePickerView setMinimumDate:[NSDate date]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [myDelegate showIndicator:[Constants greenBackgroundColor:1.0]];
    [self performSelector:@selector(getResourcesTypeList) withObject:nil afterDelay:.1];
    // Do any additional setup after loading the view.
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
//    self.toolBarView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [[UIScreen mainScreen] bounds].size.width, self.toolBarView.frame.size.height);
    NSDictionary* info = [notification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.2];
//    self.toolBarView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-[aValue CGRectValue].size.height-44, [[UIScreen mainScreen] bounds].size.width, self.toolBarView.frame.size.height);
//    [UIView commitAnimations];
//    CGPoint center= toolbarTextField.center;
//    CGPoint rootViewPoint = [toolbarTextField.superview convertPoint:center toView:fieldTableView];
//    //Not working in multiple cell case
//    //    if (!tableViewAreadyShow) {
//    //        tableViewAreadyShow=true;
//    //        self.fieldTableView.translatesAutoresizingMaskIntoConstraints=YES;
//    //        self.fieldTableView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-[aValue CGRectValue].size.height);
//    //    }
//    keyBoardHeight=[aValue CGRectValue].size.height;
//    if (rootViewPoint.y+toolbarTextField.frame.size.height<([UIScreen mainScreen].bounds.size.height-64)-[aValue CGRectValue].size.height) {
//        [self.fieldTableView setContentOffset:CGPointMake(0, 0) animated:YES];
//    }
//    else {
//        [self.fieldTableView setContentOffset:CGPointMake(0, (rootViewPoint.y+toolbarTextField.frame.size.height)- ([UIScreen mainScreen].bounds.size.height-64-[aValue CGRectValue].size.height)) animated:YES];
//    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3];
   
//    self.toolBarView.frame = CGRectMake(0, 1000, [[UIScreen mainScreen] bounds].size.width, self.toolBarView.frame.size.height);
//    [UIView commitAnimations];
    //Not working in multiple cell case
    //    self.fieldTableView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
    
//    NSLog(@"%f,%f",(self.fieldTableView.contentOffset.y),self.view.frame.size.height-keyBoardHeight);
//    if ((self.fieldTableView.contentOffset.y)>self.view.frame.size.height-keyBoardHeight) {
//        [self.fieldTableView setContentOffset:CGPointMake(0, self.fieldTableView.contentOffset.y-keyBoardHeight) animated:YES];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

- (void)addToolBarItems {
    
    UIBarButtonItem *pickerDoneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    UIBarButtonItem *textFieldDoneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    UIBarButtonItem *flexableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    pickerPreviousBarButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:105 target:self action:@selector(selectPreviousField)];
    pickerNextBarButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:106 target:self action:@selector(selectNextField)];
    
   textfieldPreviousBarButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:105 target:self action:@selector(selectPreviousField)];
  textfieldNextBarButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:106 target:self action:@selector(selectNextField)];
    fixedSpace.width = 22.0;
    [self.toolBarView setItems:[NSArray arrayWithObjects:pickerPreviousBarButton,fixedSpace,pickerNextBarButton,flexableItem,pickerDoneItem, nil]];
    textFieldToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44.0)];
    [textFieldToolbar setItems:[NSArray arrayWithObjects:textfieldPreviousBarButton,fixedSpace,textfieldNextBarButton,flexableItem,textFieldDoneItem, nil]];
}

- (void)selectPreviousField {
    
    currentFieldIndex=currentFieldIndex-1;
    if (currentFieldIndex==0) {
        [self.view endEditing:YES];
        [self hideDatePickerView];
        if (bookResourceTypeArray.count!=0) {
            pickerPreviousBarButton.enabled=false;
            pickerNextBarButton.enabled=true;
            [self showResourcePickerView:(lastSelectedResourceType==-1?0:lastSelectedResourceType)];
        }
    }
    else if (currentFieldIndex==2) {
        [self.view endEditing:YES];
        [self hideDatePickerView];
        if (bookResourceLocationArray.count!=0) {
            [self showResourcePickerView:lastSelectedResourceLocation];
        }
    }
    else if (currentFieldIndex==3) {
        [self.view endEditing:YES];
        [self hideResourcePickerView];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm a"];
         NSIndexPath *indexPath=[NSIndexPath indexPathForRow:currentFieldIndex inSection:0];
        BookResourceCell *cell=(BookResourceCell *)[self.bookResourceFormTableView cellForRowAtIndexPath:indexPath];
        NSDate *date;
        if (![cell.resourceTextField.text isEqualToString:@""]) {
            date = [dateFormat dateFromString:cell.resourceTextField.text];
        }
        else {
            date = [NSDate date];
        }
        [_datePickerView setDate:date];
        
        [self showDatePickerView];
    }
    else if (currentFieldIndex==4) {
        [self.view endEditing:YES];
        pickerPreviousBarButton.enabled=true;
        pickerNextBarButton.enabled=false;
        [self hideResourcePickerView];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
         NSIndexPath *indexPath=[NSIndexPath indexPathForRow:currentFieldIndex inSection:0];
        BookResourceCell *cell=(BookResourceCell *)[self.bookResourceFormTableView cellForRowAtIndexPath:indexPath];
        NSDate *date;
        if (![cell.resourceTextField.text isEqualToString:@""]) {
            date = [dateFormat dateFromString:cell.resourceTextField.text];
        }
        else {
            date = [NSDate date];
        }
        [_datePickerView setDate:date];
        [self showDatePickerView];
    }
    [self.view endEditing:YES];
//    CGPoint center= toolbarTextField.center;
//    CGPoint rootViewPoint = [toolbarTextField.superview convertPoint:center toView:fieldTableView];
//    NSIndexPath *indexPath = [fieldTableView indexPathForRowAtPoint:rootViewPoint];
//    FieldTableViewCell *maincell = [fieldTableView cellForRowAtIndexPath:indexPath];
//    [maincell.textfield resignFirstResponder];
////    if (indexPath.row>0) {
//        NSIndexPath *newIndexPath1 = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
//        maincell = [fieldTableView cellForRowAtIndexPath:newIndexPath1];
//        [maincell.textfield becomeFirstResponder];
////    }
}

- (void)selectNextField {
    currentFieldIndex=currentFieldIndex+1;
    if (currentFieldIndex==0) {
        [self.view endEditing:YES];
        [self hideDatePickerView];
        if (bookResourceTypeArray.count!=0) {
            pickerPreviousBarButton.enabled=false;
            pickerNextBarButton.enabled=true;
            [self showResourcePickerView:(lastSelectedResourceType==-1?0:lastSelectedResourceType)];
        }
    }
    else if (currentFieldIndex==1) {
        [self.view endEditing:YES];
        [self hideResourcePickerView];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:currentFieldIndex inSection:0];
        BookResourceCell *cell=(BookResourceCell *)[self.bookResourceFormTableView cellForRowAtIndexPath:indexPath];
        cell.resourceTextField.delegate=self;
        [cell.resourceTextField  becomeFirstResponder];
    }
    else if (currentFieldIndex==2) {
        [self.view endEditing:YES];
        [self hideDatePickerView];
        if (bookResourceLocationArray.count!=0) {
            [self showResourcePickerView:lastSelectedResourceLocation];
        }
    }
    else if (currentFieldIndex==3) {
        [self.view endEditing:YES];
        [self hideResourcePickerView];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm a"];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:currentFieldIndex inSection:0];
        BookResourceCell *cell=(BookResourceCell *)[self.bookResourceFormTableView cellForRowAtIndexPath:indexPath];
        NSDate *date;
        if (![cell.resourceTextField.text isEqualToString:@""]) {
            date = [dateFormat dateFromString:cell.resourceTextField.text];
        }
        else {
            date = [NSDate date];
        }
        [_datePickerView setDate:date];
        
        [self showDatePickerView];
    }
    else if (currentFieldIndex==4) {
        [self.view endEditing:YES];
        pickerPreviousBarButton.enabled=true;
        pickerNextBarButton.enabled=false;
        [self hideResourcePickerView];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:currentFieldIndex inSection:0];
        BookResourceCell *cell=(BookResourceCell *)[self.bookResourceFormTableView cellForRowAtIndexPath:indexPath];
        NSDate *date;
        if (![cell.resourceTextField.text isEqualToString:@""]) {
            date = [dateFormat dateFromString:cell.resourceTextField.text];
        }
        else {
            date = [NSDate date];
        }
        [_datePickerView setDate:date];
        [self showDatePickerView];
    }
    [self.view endEditing:YES];
}

- (void)doneButtonPressed:(id)sender {
    
    if (currentFieldIndex==0) {
        [self hideResourcePickerView];
        NSInteger index = [self.resourcePickerView selectedRowInComponent:0];
        NSString *str=[[bookResourceTypeArray objectAtIndex:index] resourceTypeDescription];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:currentFieldIndex inSection:0];
        BookResourceCell *cell=(BookResourceCell *)[self.bookResourceFormTableView cellForRowAtIndexPath:indexPath];
        cell.resourceTextField.text=str;
        if (lastSelectedResourceType!=(int)index) {
            lastSelectedResourceType=(int)index;
            [myDelegate showIndicator:[Constants greenBackgroundColor:1.0]];
            [self performSelector:@selector(getLocationList) withObject:nil afterDelay:.1];
        }
    }
    else if (currentFieldIndex==1) {
        [self.view endEditing:YES];
    }
    else if (currentFieldIndex==2) {
        [self hideResourcePickerView];
        NSInteger index = [self.resourcePickerView selectedRowInComponent:0];
        NSString *str=[[bookResourceLocationArray objectAtIndex:index] resourceTypeDescription];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:currentFieldIndex inSection:0];
        BookResourceCell *cell=(BookResourceCell *)[self.bookResourceFormTableView cellForRowAtIndexPath:indexPath];
        cell.resourceTextField.text=str;
        lastSelectedResourceLocation=(int)index;
    }
    else if (currentFieldIndex==3) {
        [self hideDatePickerView];
        
        NSDate *date = self.datePickerView.date;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm a"];
//        [dateFormat setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
        DLog(@"%@",[dateFormat stringFromDate:date]);
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:currentFieldIndex inSection:0];
        BookResourceCell *cell=(BookResourceCell *)[self.bookResourceFormTableView cellForRowAtIndexPath:indexPath];
        cell.resourceTextField.text=[dateFormat stringFromDate:date];
//        selectedDate = [dateFormat stringFromDate:date];
    }
    else if (currentFieldIndex==4) {
        [self hideDatePickerView];
        NSDate *date = self.datePickerView.date;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm a"];
        //        [dateFormat setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
        DLog(@"%@",[dateFormat stringFromDate:date]);
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:currentFieldIndex inSection:0];
        BookResourceCell *cell=(BookResourceCell *)[self.bookResourceFormTableView cellForRowAtIndexPath:indexPath];
        cell.resourceTextField.text=[dateFormat stringFromDate:date];
    }
}

- (void)removePickerViewAutolayout {

    self.datePickerView.translatesAutoresizingMaskIntoConstraints=YES;
    self.toolBarView.translatesAutoresizingMaskIntoConstraints=YES;
    self.resourcePickerView.translatesAutoresizingMaskIntoConstraints=YES;
}

- (void)showDatePickerView {

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.datePickerView.frame = CGRectMake(self.datePickerView.frame.origin.x, [[UIScreen mainScreen] bounds].size.height - self.datePickerView.frame.size.height, [[UIScreen mainScreen] bounds].size.width, self.datePickerView.frame.size.height);
    self.toolBarView.frame = CGRectMake(0, self.datePickerView.frame.origin.y-44, [[UIScreen mainScreen] bounds].size.width, self.toolBarView.frame.size.height);
    [UIView commitAnimations];
}

- (void)hideDatePickerView {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.datePickerView.frame = CGRectMake(0, 1000, [[UIScreen mainScreen] bounds].size.width, self.datePickerView.frame.size.height);
    self.toolBarView.frame = CGRectMake(0, 1000, [[UIScreen mainScreen] bounds].size.width, self.toolBarView.frame.size.height);
    [UIView commitAnimations];
}

- (void)showResourcePickerView:(int)selectedIndex {
    
    [self.resourcePickerView selectRow:selectedIndex inComponent:0 animated:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.resourcePickerView.frame = CGRectMake(self.resourcePickerView.frame.origin.x, [[UIScreen mainScreen] bounds].size.height -  self.resourcePickerView.frame.size.height, [[UIScreen mainScreen] bounds].size.width, self.resourcePickerView.frame.size.height);
    self.toolBarView.frame = CGRectMake(0, self.resourcePickerView.frame.origin.y-44, [[UIScreen mainScreen] bounds].size.width, self.toolBarView.frame.size.height);
    [UIView commitAnimations];
    [self.resourcePickerView reloadAllComponents];
}

- (void)hideResourcePickerView {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.resourcePickerView.frame = CGRectMake(0, 1000, [[UIScreen mainScreen] bounds].size.width, self.resourcePickerView.frame.size.height);
    self.toolBarView.frame = CGRectMake(0, 1000, [[UIScreen mainScreen] bounds].size.width, self.toolBarView.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark - Picker view methods
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen] bounds].size.width,20)];
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


#pragma mark - Webservice
//Get resource type list webservice
- (void)getResourcesTypeList {
    
    bookResourceTypeArray=[NSMutableArray new];
    if ([super checkInternetConnection]) {
        ResourceModel *resourceData = [ResourceModel sharedUser];
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
        ResourceModel *resourceData = [ResourceModel sharedUser];
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
                    alertView = [[CustomAlert alloc] initWithTitle:@"Alert" tagValue:2 delegate:self message:@"Something went wrong, Please try again." doneButtonText:@"OK" cancelButtonText:@""];
                }
            });
        }];
    }
    else {
        [myDelegate stopIndicator];
    }
}
#pragma mark - end

#pragma mark - Tableview methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * headerView;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width,50.0)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont handseanWithSize:17];
    label.text = @"Book resource by filling up below form.";
    [headerView addSubview:label];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return inputFieldTitleArray.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row!=inputFieldTitleArray.count) {
        return 88.0;
    }
    else {
        return 60.0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BookResourceCell *cell;
    if (indexPath.row!=inputFieldTitleArray.count) {
        NSString *simpleTableIdentifier = @"BookResourceInputCell";
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[BookResourceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        if (indexPath.row==1) {
            cell.resourceTextField.inputAccessoryView = textFieldToolbar;
        }
        else {
            cell.resourceTextField.inputAccessoryView = nil;
        }
        [cell displayData:[inputFieldTitleArray mutableCopy] index:(int)indexPath.row];
    }
    else {
        NSString *simpleTableIdentifier = @"BookResourceButtonCell";
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[BookResourceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        [cell displayData:[inputFieldTitleArray mutableCopy] index:(int)indexPath.row];
        [cell.searchButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    }
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    currentFieldIndex=(int)indexPath.row;
    if (indexPath.row==0) {
        [self.view endEditing:YES];
        [self hideDatePickerView];
        if (bookResourceTypeArray.count!=0) {
            pickerPreviousBarButton.enabled=false;
            pickerNextBarButton.enabled=true;
            [self showResourcePickerView:(lastSelectedResourceType==-1?0:lastSelectedResourceType)];
        }
    }
    else if (indexPath.row==2) {
        [self.view endEditing:YES];
        [self hideDatePickerView];
        if (bookResourceLocationArray.count!=0) {
            [self showResourcePickerView:lastSelectedResourceLocation];
        }
    }
    else if (indexPath.row==3) {
        [self.view endEditing:YES];
        [self hideResourcePickerView];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm a"];
        BookResourceCell *cell=(BookResourceCell *)[self.bookResourceFormTableView cellForRowAtIndexPath:indexPath];
        NSDate *date;
        if (![cell.resourceTextField.text isEqualToString:@""]) {
           date = [dateFormat dateFromString:cell.resourceTextField.text];
        }
        else {
            date = [NSDate date];
        }
        [_datePickerView setDate:date];
        
        [self showDatePickerView];
    }
    else if (indexPath.row==4) {
        [self.view endEditing:YES];
        pickerPreviousBarButton.enabled=true;
        pickerNextBarButton.enabled=false;
        [self hideResourcePickerView];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        BookResourceCell *cell=(BookResourceCell *)[self.bookResourceFormTableView cellForRowAtIndexPath:indexPath];
        NSDate *date;
        if (![cell.resourceTextField.text isEqualToString:@""]) {
            date = [dateFormat dateFromString:cell.resourceTextField.text];
        }
        else {
            date = [NSDate date];
        }
        [_datePickerView setDate:date];
        [self showDatePickerView];
    }
    
}
#pragma mark - end

#pragma mark - Textfield delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    currentFieldIndex=1;
//    CGPoint center= toolbarTextField.center;
//    CGPoint rootViewPoint = [toolbarTextField.superview convertPoint:center toView:fieldTableView];
//    NSIndexPath *indexPath = [fieldTableView indexPathForRowAtPoint:rootViewPoint];
//    if (indexPath.row>0&&indexPath.row<tableviewCount-1) {
//        previousBarButton.enabled=true;
//        nextBarButton.enabled=true;
//    }
//    else if (indexPath.row<1){
//        previousBarButton.enabled=false;
//        nextBarButton.enabled=true;
//    }
//    else{
//        previousBarButton.enabled=true;
//        nextBarButton.enabled=false;
//    }
}
//
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end

- (void)submit {
    
    
}

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
