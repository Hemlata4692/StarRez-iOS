//
//  ImagePopUpViewController.m
//  Dwell
//
//  Created by Ranosys on 13/10/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ImagePopUpViewController.h"
#import "UIImageView+WebCache.h"

@interface ImagePopUpViewController ()<UIGestureRecognizerDelegate> {

     int pageCounter;
}
@end

@implementation ImagePopUpViewController
@synthesize imageArray;
@synthesize currentSelectedImage;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageControl.numberOfPages = [imageArray count];
    pageCounter = currentSelectedImage;
    self.pageControl.currentPage = pageCounter;
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:178.0/255.0 green:198.0/255.0 blue:58.0/255.0 alpha:1.0];
    self.maintenanceDetailImage.userInteractionEnabled = YES;
   
    [self.maintenanceDetailImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://starrez.centurionstudents.co.uk/StarRezREST/services/photo/RecordAttachment/%@",[imageArray objectAtIndex:pageCounter]]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    //Swipe gesture to swipe images to left
    UISwipeGestureRecognizer *swipeImageLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeIntroImageLeft)];
    swipeImageLeft.delegate=self;
    UISwipeGestureRecognizer *swipeImageRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeIntroImageRight)];
    swipeImageRight.delegate=self;
    
    // Setting the swipe direction.
    [swipeImageLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeImageRight setDirection:UISwipeGestureRecognizerDirectionRight];
    // Adding the swipe gesture on image view
    [[self view] addGestureRecognizer:swipeImageLeft];
    [[self view] addGestureRecognizer:swipeImageRight];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Swipe Images
//Adding left animation to banner images
- (void)addLeftAnimationPresentToView:(UIView *)viewTobeAnimatedLeft {
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [transition setValue:@"IntroSwipeIn" forKey:@"IntroAnimation"];
    transition.fillMode=kCAFillModeForwards;
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromRight;
    [viewTobeAnimatedLeft.layer addAnimation:transition forKey:nil];
}

//Adding right animation to banner images
- (void)addRightAnimationPresentToView:(UIView *)viewTobeAnimatedRight {
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [transition setValue:@"IntroSwipeIn" forKey:@"IntroAnimation"];
    transition.fillMode=kCAFillModeForwards;
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromLeft;
    [viewTobeAnimatedRight.layer addAnimation:transition forKey:nil];
}

//Swipe images in left direction
- (void)swipeIntroImageLeft {
    
    pageCounter++;
    if (pageCounter < imageArray.count) {
        
        self.pageControl.currentPage = pageCounter;
        [self.maintenanceDetailImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://starrez.centurionstudents.co.uk/StarRezREST/services/photo/RecordAttachment/%@",[imageArray objectAtIndex:pageCounter]]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        
        UIImageView *moveIMageView = self.maintenanceDetailImage;
        [self addLeftAnimationPresentToView:moveIMageView];
    }
    else {
        
        pageCounter = (int)imageArray.count - 1;
    }
}

//Swipe images in right direction
- (void)swipeIntroImageRight {
    
    pageCounter--;
    if (pageCounter>=0) {
        self.pageControl.currentPage = pageCounter;
        [self.maintenanceDetailImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://starrez.centurionstudents.co.uk/StarRezREST/services/photo/RecordAttachment/%@",[imageArray objectAtIndex:pageCounter]]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        UIImageView *moveIMageView = self.maintenanceDetailImage;
        [self addRightAnimationPresentToView:moveIMageView];
    }
    else {
        
        pageCounter = 0;
    }
}
#pragma mark - end
- (IBAction)crossAction:(UIButton *)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//[maintenanceImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://starrez.centurionstudents.co.uk/StarRezREST/services/photo/RecordAttachment/%@",[maintenanceImageArray objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]]

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
