//
//  Constants.h
//  Dwell
//
//  Created by Ranosys on 13/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>
static const float cornerRadius=10.0;

@interface Constants : NSObject

+ (UIColor*)dashboardColor;
+ (UIColor*)blueBackgroundColor;
+ (UIColor*)yellowBackgroundColor;
+ (UIColor*)greenBackgroundColor;
+ (UIColor*)redBackgroundColor;
+ (UIColor*)orangeBackgroundColor;
+ (UIColor*)oliveGreenBackgroundColor;
+ (UIColor*)grayBackgroundColor;
+ (UIColor*)logoutColor;
+ (UIColor*)skyBlueColor;
+ (UIColor*)cancelColor;
+ (UIColor*)navigationColor;
+ (UIColor*)darkGrayBackgroundColor;
+ (UIColor*)purpleBackgroundColor;

//Use for side bar
+ (UIColor*)oldDashboardColor;
+ (UIColor*)oldBlueBackgroundColor:(float)alpha;
+ (UIColor*)oldYellowBackgroundColor:(float)alpha;
+ (UIColor*)oldGreenBackgroundColor:(float)alpha;
+ (UIColor*)oldOrangeBackgroundColor;
+ (UIColor*)oldDarkGreenBackgroundColor;
+ (UIColor*)oldGrayBackgroundColor;
+ (UIColor*)oldLogoutColor;
@end
