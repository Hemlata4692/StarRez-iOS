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
#import "UIImage+deviceSpecificMedia.h"

#define informationWebUrl @"http://www.dwellstudent.co.uk/en/information/"
#define eventWebUrl @"http://www.dwellstudent.co.uk/en/event/"
#define helpWebUrl @"http://www.dwellstudent.co.uk/en/help/"

@interface InformationViewController (){
    
    UIBarButtonItem *barButton;
    NSString *webViewUrl, *lastWebUrl;
    BOOL isLoaderShow;
}
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation InformationViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    isLoaderShow=false;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque=NO;
    
    //Add menu bar button initially
    [self addBackgroungImage:@"Resource"];
    [self setTransparentNavigtionBar];
    [self addLeftBarButtonWithImage:[UIImage imageNamed:@"menu.png"]];
    if ([[UserDefaultManager getValue:@"ScreenName"] isEqualToString:@"Event"]) {   //If event tab click
        [UserDefaultManager setValue:[NSNumber numberWithInteger:4] key:@"indexpath"];
        self.navigationItem.title=@"Event";
        webViewUrl=eventWebUrl;
        Internet *internet=[[Internet alloc] init];
        if (![internet start]) {
            isLoaderShow=true;
//            [myDelegate showIndicator:[Constants oldGreenBackgroundColor:1.0]];
            [myDelegate showIndicator:[Constants navigationColor]];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:eventWebUrl]]];
        }
    }
    else if ([[UserDefaultManager getValue:@"ScreenName"] isEqualToString:@"Information"]) {   //If information tab click
        [UserDefaultManager setValue:[NSNumber numberWithInteger:5] key:@"indexpath"];
        self.navigationItem.title=@"Information";
        webViewUrl=informationWebUrl;
        Internet *internet=[[Internet alloc] init];
        if (![internet start]) {
            isLoaderShow=true;
//            [myDelegate showIndicator:[Constants oldGreenBackgroundColor:1.0]];
            [myDelegate showIndicator:[Constants navigationColor]];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:informationWebUrl]]];
        }
    }
    else if ([[UserDefaultManager getValue:@"ScreenName"] isEqualToString:@"Help"]) {   //If help tab click
        [UserDefaultManager setValue:[NSNumber numberWithInteger:6] key:@"indexpath"];
        self.navigationItem.title=@"Help";
        webViewUrl=helpWebUrl;
        Internet *internet=[[Internet alloc] init];
        if (![internet start]) {
            isLoaderShow=true;
//            [myDelegate showIndicator:[Constants oldGreenBackgroundColor:1.0]];
            [myDelegate showIndicator:[Constants navigationColor]];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:helpWebUrl]]];
        }
    }
    lastWebUrl=webViewUrl;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

//Make the navigation bar transparent and show only bar items.
- (void)setTransparentNavigtionBar {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}

//Add different background image for all sub classes at run time.
- (void)addBackgroungImage:(NSString *)imageName {
    
    //Set background image on uiview
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:imageName] drawInRect:self.view.bounds];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[image imageForDeviceWithName:imageName]]];
    backgroundImage.contentMode = UIViewContentModeScaleAspectFit;
    backgroundImage.frame = self.view.frame;
    [self.view insertSubview:backgroundImage atIndex:0];
}

#pragma mark - Webview delegates
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    DLog(@"start value: %@",request.URL);
    webViewUrl=[request.URL absoluteString];
    if ([[UserDefaultManager getValue:@"ScreenName"] isEqualToString:@"Information"]) {
        if ([self isValidURL:[webViewUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
            //Information view has list to navigte other webpage
            if (![webViewUrl isEqualToString:informationWebUrl]) {
                if (!isLoaderShow) {
                    //                [myDelegate showIndicator:[Constants oldGreenBackgroundColor:1.0]];
                    [myDelegate showIndicator:[Constants navigationColor]];
                    isLoaderShow=true;
                    [self addLeftBackBarButtonWithImage:[UIImage imageNamed:@"back_btn"]];
                }
            }
            else {
                if (!isLoaderShow) {
                    //                [myDelegate showIndicator:[Constants oldGreenBackgroundColor:1.0]];
                    [myDelegate showIndicator:[Constants navigationColor]];
                    isLoaderShow=true;
                }
            }
        }
    }
    else if ([[UserDefaultManager getValue:@"ScreenName"] isEqualToString:@"Event"]) {
        if ([self isValidURL:[webViewUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
        //Information view has list to navigte other webpage
        if (![webViewUrl isEqualToString:eventWebUrl]) {
            if (!isLoaderShow) {
                //                [myDelegate showIndicator:[Constants oldGreenBackgroundColor:1.0]];
                [myDelegate showIndicator:[Constants navigationColor]];
                isLoaderShow=true;
                [self addLeftBackBarButtonWithImage:[UIImage imageNamed:@"back_btn"]];
            }
        }
        else {
            if (!isLoaderShow) {
                //                [myDelegate showIndicator:[Constants oldGreenBackgroundColor:1.0]];
                [myDelegate showIndicator:[Constants navigationColor]];
                isLoaderShow=true;
            }
        }
        }
    }
    else if ([[UserDefaultManager getValue:@"ScreenName"] isEqualToString:@"Help"]) {
        if ([self isValidURL:[webViewUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
        //Information view has list to navigte other webpage
        if (![webViewUrl isEqualToString:helpWebUrl]) {
            if (!isLoaderShow) {
                //                [myDelegate showIndicator:[Constants oldGreenBackgroundColor:1.0]];
                [myDelegate showIndicator:[Constants navigationColor]];
                isLoaderShow=true;
                [self addLeftBackBarButtonWithImage:[UIImage imageNamed:@"back_btn"]];
            }
        }
        else {
            if (!isLoaderShow) {
                //                [myDelegate showIndicator:[Constants oldGreenBackgroundColor:1.0]];
                [myDelegate showIndicator:[Constants navigationColor]];
                isLoaderShow=true;
            }
        }
        }
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [myDelegate stopIndicator];
    isLoaderShow=false;
    if ([[UserDefaultManager getValue:@"ScreenName"] isEqualToString:@"Information"]) {
        if (![webViewUrl isEqualToString:informationWebUrl]) {
            [self addLeftBackBarButtonWithImage:[UIImage imageNamed:@"back_btn"]];
        }
        else {
            [self addLeftBarButtonWithImage:[UIImage imageNamed:@"menu.png"]];
        }
    }
    else if ([[UserDefaultManager getValue:@"ScreenName"] isEqualToString:@"Event"]) {
        if (![webViewUrl isEqualToString:eventWebUrl]) {
            [self addLeftBackBarButtonWithImage:[UIImage imageNamed:@"back_btn"]];
        }
        else {
            [self addLeftBarButtonWithImage:[UIImage imageNamed:@"menu.png"]];
        }
    }
    else if ([[UserDefaultManager getValue:@"ScreenName"] isEqualToString:@"Help"]) {
        if (![webViewUrl isEqualToString:helpWebUrl]) {
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
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:informationWebUrl]]];
    }
    else if ([[UserDefaultManager getValue:@"ScreenName"] isEqualToString:@"Event"]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:eventWebUrl]]];
    }
    else if ([[UserDefaultManager getValue:@"ScreenName"] isEqualToString:@"Help"]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:helpWebUrl]]];
    }
}
#pragma mark - end

#pragma mark - Link validation
- (BOOL)isValidURL:(NSString *)urlString {
    if ([urlString containsString:@"http:"]||[urlString containsString:@"https:"]) {
        return YES;
    }
    return NO;
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
