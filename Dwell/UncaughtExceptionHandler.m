//
//  UncaughtExceptionHandler.m
//  UncaughtExceptions
//
//  Created by Matt Gallagher on 2010/05/25.
//  Copyright 2010 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "UncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

@implementation UncaughtExceptionHandler

+ (NSArray *)backtrace
{
	 void* callstack[128];
	 int frames = backtrace(callstack, 128);
	 char **strs = backtrace_symbols(callstack, frames);
	 
	 int i;
	 NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
	 for (
	 	i = UncaughtExceptionHandlerSkipAddressCount;
	 	i < UncaughtExceptionHandlerSkipAddressCount +
			UncaughtExceptionHandlerReportAddressCount;
		i++)
	 {
	 	[backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
	 }
	 free(strs);
	 
	 return backtrace;
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex
{
	if (anIndex == 0)
	{
		dismissed = YES;
	}
}

- (void)validateAndSaveCriticalApplicationData
{
    myvalue = 0;
    [self performSelector:@selector(userLogin) withObject:nil afterDelay:.1];

}

- (void)badAccess
{
    void (*nullFunction)() = NULL;
    
    nullFunction();
}

//Get crashed view
- (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    }
    else {
        if (vc.childViewControllers) {
            if ([vc.childViewControllers lastObject]==nil) {
                return vc;
            }
            else{
                return [self getVisibleViewControllerFrom:[vc.childViewControllers lastObject]];
            }
        }
        else if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}


- (void)userLogin {
    
         UINavigationController *navCnt = (UINavigationController *)myDelegate.window.rootViewController;
         UIViewController *rootViewController =[self getVisibleViewControllerFrom:myDelegate.window.rootViewController];
    NSString *strClass = NSStringFromClass([rootViewController class]);
     NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appDisplayName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    NSString *networkType=@"";
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"]integerValue]) {
        case 0:
            NSLog(@"No wifi or cellular");
            networkType=@"No wifi or cellular";
            break;
            
        case 1:
            NSLog(@"2G");
            networkType=@"2G";
            break;
            
        case 2:
            NSLog(@"3G");
            networkType=@"3G";
            break;
            
        case 3:
            NSLog(@"4G");
            networkType=@"4G";
            break;
            
        case 4:
            NSLog(@"LTE");
            networkType=@"LTE";
            break;
            
        case 5:
            NSLog(@"Wifi");
            networkType=@"Wifi";
            break;
            
        default:
            break;
    }
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSLocale *countryLocale = [NSLocale currentLocale];
    NSString *countryCode = [countryLocale objectForKey:NSLocaleCountryCode];
    NSString *country = [countryLocale displayNameForKey:NSLocaleCountryCode value:countryCode];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    
    NSString *crashString=[NSString stringWithFormat:@"Device-> %@\nScreen name-> %@\nVersion-> %@ (%@)\nNetwork type-> %@\niOS version-> %@\nTime zone-> %@,\nCountry Code-> %@\nCountry name-> %@\nTimestamp-> %@\nException-> %@",[[UIDevice currentDevice] name],strClass,
                            majorVersion, minorVersion,networkType,[[UIDevice currentDevice] systemVersion],tz.description,countryCode,country,[dateFormatter stringFromDate:[NSDate date]],exceptionText];
    NSLog(@"%@,\n%@, \n%@, \nVersion %@ (%@),\n%@,\n%@,\n%@,\n%@,\n%@,\n%@,\n%@,\n%@",[[UIDevice currentDevice] name],strClass,
          appDisplayName, majorVersion, minorVersion,networkType,[[UIDevice currentDevice] systemVersion],tz.description,countryLocale,countryCode,country,[dateFormatter stringFromDate:[NSDate date]],exceptionText);
    [self callCrashWebservice:crashString];
    
    
//         return [self getVisibleViewControllerFrom:rootViewController];
         
//         UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;

//         UINavigationController *navigationController = (UINavigationController *)self;
////         [navigationController.visibleViewController topVisibleViewController];
//         
//         NSArray *a = navCnt.viewControllers;
//          NSString *CurrentSelectedCViewController = NSStringFromClass([[navigationController.visibleViewController topVisibleViewController] class]);
//         
//         [self topMostController];
         
//         UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
//         
//         UIViewController *next = nil;
//         
//         while ((next = [self _topMostController:topController]) != nil) {
//             topController = next;
//         }
    
         
//     } failure:^(NSError *error) {
//         
//         NSLog(@"log");
//     }] ;
    
}

-(void)callCrashWebservice :(NSString *)crashString
{
    
//    NSURLSession *session = [NSURLSession sharedSession];
    //populate json
    NSDictionary *requestDict = @{@"content":crashString,@"to":@"rohit@ranosys.com",@"subject":@"Dwell API crash Andriod/IOS"};
//    NSError *jsonError;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDict options:NSJSONWritingPrettyPrinted error:&jsonError];
//    //populate the json data in the setHTTPBody:jsonData
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://ranosys.net/client/starrez/crash.php"]];
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:jsonData];
//    //Send data with the request that contains the json data
//    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        // Do your stuff...
//        NSXMLParser	*parser;
//parser = [[NSXMLParser alloc] initWithData:data];
//        dismissed = YES;
//    }] resume];
    
    
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager POST:@"http://ranosys.net/client/starrez/crash.php" parameters:requestDict success:^(NSURLSessionDataTask *task, id responseObject) {
//         dismissed = YES;
//        NSLog(@"responseObject = %@", responseObject);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"error = %@", error);
//         dismissed = YES;
//    }];
    
    
    
    NSError *error;
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
//    NSURL *url=[NSURL URLWithString:@"http://ranosys.net/client/starrez/crash.php"];
//    NSData *postData = [NSJSONSerialization dataWithJSONObject:requestDict options:0 error:&error];;
//    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:url];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:postData];
//    
//    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
//                                          {
//                                              NSString *responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//                                              NSLog(@"%@",responseString);
//                                              dismissed = YES;
////                                              NSMutableDictionary* responseData=[NSMutableDictionary new];
////                                              if ([responseString isEqualToString:@""]) {
////                                                  [responseData setObject:@"2" forKey:@"success"];
////                                                  failure(responseData);
////                                              }
////                                              else if ((NULL!=responseString)&&(nil!=responseString)) {
////                                                  
////                                                  responseData=(NSMutableDictionary *)[NullValueChecker checkArrayForNullValue:[[[XMLDictionaryParser sharedInstance] dictionaryWithString:responseString] mutableCopy]];
////                                                  if (responseData.count!=0) {
////                                                      [responseData setObject:@"1" forKey:@"success"];
////                                                      success(responseData);
////                                                  }
////                                                  else {
////                                                      [responseData setObject:@"0" forKey:@"success"];
////                                                      failure(responseData);
////                                                  }
////                                              }
//                                          }];
//    
//    [postDataTask resume];
    
    
//    NSURLSessionDataTask *uploadTask;
//    NSLog(@"request submit mission dict %@",requestDict);
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]  multipartFormRequestWithMethod:@"POST" URLString:@"http://ranosys.net/client/starrez/crash.php" parameters:requestDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {} error:nil];
//    uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (!error) {
//            //success
//            responseObject=(NSMutableDictionary *)[NullValueChecker checkArrayForNullValue:[responseObject mutableCopy]];
////            success(responseObject);
//        } else {
//            id messageString;
//            if (nil!=[responseObject objectForKey:@"message"]) {
//                messageString=[responseObject objectForKey:@"message"];
//            }
//            else {
//                messageString=error.localizedDescription;
//            }
////            failure(messageString);
//        }
//    }];
//    [uploadTask resume];
    
    
//    NSURL *sRequestURL = [NSURL URLWithString:@"http://ranosys.net/client/starrez/crash.php"];
//    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:sRequestURL];
////    NSString *sMessageLength = [NSString stringWithFormat:@"%lu", (unsigned long)[requestDict length]];
//    NSData *postData = [NSJSONSerialization dataWithJSONObject:requestDict options:0 error:&error];;
//    [myRequest setValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
////    [myRequest setValue: @"urn:Magento" forHTTPHeaderField:@"SOAPAction"];
////    [myRequest setValue: postData forHTTPHeaderField:@"Content-Length"];
//    
//    //    [myRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    //    [myRequest addValue: @"urn:Magento" forHTTPHeaderField:@"SOAPAction"];
//    //    [myRequest addValue: sMessageLength forHTTPHeaderField:@"Content-Length"];
//    
//    [myRequest setHTTPMethod:@"POST"];
//    [myRequest setHTTPBody: postData];
//    NSURLResponse *response = NULL;
//    NSError *requestError = NULL;
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:&response error:&requestError];
//    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//    dismissed = YES;
//        NSLog(@"SOAP response is **%@",responseString);
    
    NSURLSession *session = [NSURLSession sharedSession];
    //populate json
//    NSDictionary *gistDict = @{@"files":@"test",@"description":@"test"};
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDict options:NSJSONWritingPrettyPrinted error:&jsonError];
    //populate the json data in the setHTTPBody:jsonData
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://ranosys.net/client/starrez/crash.php"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    //Send data with the request that contains the json data
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                      DLog(@"%@",responseString);
        // Do your stuff...
    }] resume];
//    return responseData;
}


-(UIViewController *)_topMostController:(UIViewController *)cont {
    UIViewController *topController = cont;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    if ([topController isKindOfClass:[UINavigationController class]]) {
        UIViewController *visible = ((UINavigationController *)topController).visibleViewController;
        if (visible) {
            topController = visible;
        }
    }
    
    return (topController != cont ? topController : nil);
}

//-(UIViewController *)topMostController() {
//    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
//    
//    UIViewController *next = nil;
//    
//    while ((next = _topMostController(topController)) != nil) {
//        topController = next;
//    }
//    
//    return topController;
//}


- (void)handleException:(NSException *)exception
{
	[self validateAndSaveCriticalApplicationData];
	
//	UIAlertView *alert =
//		[[[UIAlertView alloc]
//			initWithTitle:NSLocalizedString(@"Unhandled exception", nil)
//			message:[NSString stringWithFormat:NSLocalizedString(
//				@"You can try to continue but the application may be unstable.\n\n"
//				@"Debug details follow:\n%@\n%@", nil),
//				[exception reason],
//				[[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]]
//			delegate:self
//			cancelButtonTitle:NSLocalizedString(@"Quit", nil)
//			otherButtonTitles:NSLocalizedString(@"Continue", nil), nil]
//		autorelease];
//	[alert show];
	
    
    NSLog(@"Debug details follow:\nname--->%@\n%@fghfghf\n%@\n%@",[exception name],[exception reason],[[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey],[exception userInfo]);
    
    exceptionText=[NSString stringWithFormat:@"%@\n%@\n%@",[exception name],[exception reason],[exception userInfo]];
	CFRunLoopRef runLoop = CFRunLoopGetCurrent();
	CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
	
	while (!dismissed)
	{
		for (NSString *mode in (__bridge NSArray *)allModes)
		{
//            if (myvalue == 0) {
//                myvalue = 1;
//                NSLog(@"sdafdsfdsfafadsfdsfasd");
//                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//          
			CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
		}
	}
	
	CFRelease(allModes);

	NSSetUncaughtExceptionHandler(NULL);
	signal(SIGABRT, SIG_DFL);
	signal(SIGILL, SIG_DFL);
	signal(SIGSEGV, SIG_DFL);
	signal(SIGFPE, SIG_DFL);
	signal(SIGBUS, SIG_DFL);
	signal(SIGPIPE, SIG_DFL);
	
	if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName])
	{
		kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
	}
	else
	{
		[exception raise];
	}
}

@end

void HandleException(NSException *exception)
{
	int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
	if (exceptionCount > UncaughtExceptionMaximum)
	{
		return;
	}
	
	NSArray *callStack = [UncaughtExceptionHandler backtrace];
	NSMutableDictionary *userInfo =
		[NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
	[userInfo
		setObject:callStack
		forKey:UncaughtExceptionHandlerAddressesKey];
	
	[[[UncaughtExceptionHandler alloc] init]
		performSelectorOnMainThread:@selector(handleException:)
		withObject:
			[NSException
				exceptionWithName:[exception name]
				reason:[exception reason]
				userInfo:userInfo]
		waitUntilDone:YES];
}

void SignalHandler(int signal)
{
	int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
	if (exceptionCount > UncaughtExceptionMaximum)
	{
		return;
	}
	
	NSMutableDictionary *userInfo =
		[NSMutableDictionary
			dictionaryWithObject:[NSNumber numberWithInt:signal]
			forKey:UncaughtExceptionHandlerSignalKey];

	NSArray *callStack = [UncaughtExceptionHandler backtrace];
	[userInfo
		setObject:callStack
		forKey:UncaughtExceptionHandlerAddressesKey];
	
	[[[UncaughtExceptionHandler alloc] init]
		performSelectorOnMainThread:@selector(handleException:)
		withObject:
			[NSException
				exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
				reason:
					[NSString stringWithFormat:
						NSLocalizedString(@"Signal %d was raised.", nil),
						signal]
				userInfo:
					[NSDictionary
						dictionaryWithObject:[NSNumber numberWithInt:signal]
						forKey:UncaughtExceptionHandlerSignalKey]]
		waitUntilDone:YES];
}

void InstallUncaughtExceptionHandler()
{
    
	NSSetUncaughtExceptionHandler(&HandleException);
	signal(SIGABRT, SignalHandler);
	signal(SIGILL, SignalHandler);
	signal(SIGSEGV, SignalHandler);
	signal(SIGFPE, SignalHandler);
	signal(SIGBUS, SignalHandler);
	signal(SIGPIPE, SignalHandler);
}

