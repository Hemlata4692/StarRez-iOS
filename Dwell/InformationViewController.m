//
//  InformationViewController.m
//  Dwell
//
//  Created by Ranosys on 29/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "InformationViewController.h"
#import "SWRevealViewController.h"
#import "Internet.h"

@interface InformationViewController (){
    
    UIBarButtonItem *barButton;
    NSString *webViewUrl;
    BOOL isLoaderShow;
}
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation InformationViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    isLoaderShow=false;
    //Add menu bar button initially
    [self addLeftBarButtonWithImage:[UIImage imageNamed:@"menu.png"]];
    if ([[UserDefaultManager getValue:@"ScreenName"] isEqualToString:@"Event"]) {   //If event tab click
        [UserDefaultManager setValue:[NSNumber numberWithInteger:4] key:@"indexpath"];
        self.navigationItem.title=@"Event";
        webViewUrl=@"http://www.centurionstudents.co.uk/en/event/";
        Internet *internet=[[Internet alloc] init];
        if (![internet start]) {
            isLoaderShow=true;
            [myDelegate showIndicator:[Constants navigationColor]];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.centurionstudents.co.uk/en/event/"]]];
        }
    }
    else if ([[UserDefaultManager getValue:@"ScreenName"] isEqualToString:@"Information"]) {   //If information tab click
        [UserDefaultManager setValue:[NSNumber numberWithInteger:5] key:@"indexpath"];
        self.navigationItem.title=@"Information";
        webViewUrl=@"http://www.centurionstudents.co.uk/en/information/";
        Internet *internet=[[Internet alloc] init];
        if (![internet start]) {
            isLoaderShow=true;
            [myDelegate showIndicator:[Constants navigationColor]];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.centurionstudents.co.uk/en/information/"]]];
        }
    }
    else if ([[UserDefaultManager getValue:@"ScreenName"] isEqualToString:@"Help"]) {   //If help tab click
        [UserDefaultManager setValue:[NSNumber numberWithInteger:6] key:@"indexpath"];
        self.navigationItem.title=@"Help";
        webViewUrl=@"http://www.centurionstudents.co.uk/en/help/";
        Internet *internet=[[Internet alloc] init];
        if (![internet start]) {
            isLoaderShow=true;
            [myDelegate showIndicator:[Constants navigationColor]];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.centurionstudents.co.uk/en/help/"]]];
        }
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Webview delegates
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    DLog(@"start value: %@",request.URL);
    webViewUrl=[request.URL absoluteString];
    if ([[UserDefaultManager getValue:@"ScreenName"] isEqualToString:@"Information"]) {
        //Information view has list to navigte other webpage
        if (![webViewUrl isEqualToString:@"http://www.centurionstudents.co.uk/en/information/"]) {
            if (!isLoaderShow) {
                [myDelegate showIndicator:[Constants navigationColor]];
                 isLoaderShow=true;
                [self addLeftBackBarButtonWithImage:[UIImage imageNamed:@"back_btn"]];
            }
        }
        else {
            if (!isLoaderShow) {
                [myDelegate showIndicator:[Constants navigationColor]];
                isLoaderShow=true;
            }
        }
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [myDelegate stopIndicator];
    isLoaderShow=false;
    if ([[UserDefaultManager getValue:@"ScreenName"] isEqualToString:@"Information"]) {
        if (![webViewUrl isEqualToString:@"http://www.centurionstudents.co.uk/en/information/"]) {
            [self addLeftBackBarButtonWithImage:[UIImage imageNamed:@"back_btn"]];
        }
        else {
            [self addLeftBarButtonWithImage:[UIImage imageNamed:@"menu.png"]];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
   
    [myDelegate stopIndicator];
}
#pragma mark - end

#pragma mark - Add bar button
//Add side menu along with action in all the screens of sidebar
- (void)addLeftBarButtonWithImage:(UIImage *)buttonImage {
    
    CGRect frameimg = CGRectMake(0, 0, buttonImage.size.width+5, buttonImage.size.height+5);
    UIButton *button = [[UIButton alloc] initWithFrame:frameimg];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    barButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [button addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    //Add pan gesture for going back to main screens by clicking on menu button.
    [revealViewController panGestureRecognizer];
    [revealViewController tapGestureRecognizer];
    revealViewController.panGestureRecognizer.enabled = NO;
}

//Add back bar button
- (void)addLeftBackBarButtonWithImage:(UIImage *)buttonImage {
    
    //Navigation bar button for adding back button.
    CGRect framing1 = CGRectMake(0, 0, 25, 25);
    UIButton *button = [[UIButton alloc] initWithFrame:framing1];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    barButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems=[NSArray arrayWithObjects:barButton, nil];
}
#pragma mark - end

#pragma mark - IBActions
//Back button action
- (void)backButtonAction :(id)sender {
    if ([[UserDefaultManager getValue:@"ScreenName"] isEqualToString:@"Information"]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.centurionstudents.co.uk/en/information/"]]];
    }
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
