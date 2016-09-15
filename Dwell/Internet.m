//
//  Internet.m
//  RKPharma
//
//  Created by shiv vaishnav on 16/05/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//

#import "Reachability.h"
#import "Internet.h"

@implementation Internet
{
    Reachability *reachability;
    CustomAlert *alertView;
}

- (BOOL)start {
    
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    if(remoteHostStatus == NotReachable) {
        alertView = [[CustomAlert alloc] initWithTitle:@"Connection Error" tagValue:2 delegate:self message:@"Please check your internet connection." doneButtonText:@"OK" cancelButtonText:@""];
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - MyAlert delegates
- (void)customAlertDelegateAction:(CustomAlert *)myAlert option:(int)option {
    
    [alertView dismissAlertView];
}
#pragma mark - end
@end
