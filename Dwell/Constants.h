//
//  Constants.h
//  Dwell
//
//  Created by Ranosys on 13/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>
static const float cornerRadius=15.0;

@interface Constants : NSObject

+ (UIColor*)dashboardColor;
+ (UIColor*)blueBackgroundColor:(float)alpha;
+ (UIColor*)yellowBackgroundColor:(float)alpha;
+ (UIColor*)greenBackgroundColor:(float)alpha;
+ (UIColor*)redBackgroundColor:(float)alpha;
+ (UIColor*)orangeBackgroundColor;
+ (UIColor*)darkGreenBackgroundColor;
+ (UIColor*)grayBackgroundColor;
+ (UIColor*)logoutColor;
+ (UIColor*)historyColor:(float)alpha;
+ (UIColor*)cancelColor:(float)alpha;
@end
