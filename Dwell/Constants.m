//
//  Constants.m
//  Dwell
//
//  Created by Ranosys on 13/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "Constants.h"

@implementation Constants

+ (UIColor*)dashboardColor {
    return [UIColor colorWithRed:230.0/255 green:68.0/255.0 blue:62.0/255.0 alpha:1.0];
}

+ (UIColor*)blueBackgroundColor:(float)alpha {
    return [UIColor colorWithRed:49.0/255 green:104.0/255.0 blue:178.0/255.0 alpha:1.0];
}

+ (UIColor*)yellowBackgroundColor:(float)alpha {
    return [UIColor colorWithRed:255.0/255 green:196.0/255.0 blue:12.0/255.0 alpha:alpha];
}

+ (UIColor*)greenBackgroundColor:(float)alpha {
    return [UIColor colorWithRed:45.0/255 green:179.0/255.0 blue:74.0/255.0 alpha:alpha];
}

+ (UIColor*)redBackgroundColor:(float)alpha {
    return [UIColor colorWithRed:229.0/255 green:41.0/255.0 blue:35.0/255.0 alpha:alpha];
}

+ (UIColor*)orangeBackgroundColor {
    return [UIColor colorWithRed:226.0/255 green:114.0/255.0 blue:50.0/255.0 alpha:1.0];
}

+ (UIColor*)darkGreenBackgroundColor {
    return [UIColor colorWithRed:136.0/255 green:157.0/255.0 blue:92.0/255.0 alpha:1.0];
}

+ (UIColor*)grayBackgroundColor {
    return [UIColor colorWithRed:107.0/255 green:107.0/255.0 blue:107.0/255.0 alpha:1.0];
}

+ (UIColor*)logoutColor {
    return [UIColor colorWithRed:225.0/255 green:100.0/255.0 blue:92.0/255.0 alpha:1.0];
}

+ (UIColor*)historyColor:(float)alpha {
    return [UIColor colorWithRed:138.0/255 green:74.0/255.0 blue:158.0/255.0 alpha:1.0];
}

+ (UIColor*)cancelColor:(float)alpha {
    return [UIColor colorWithRed:108.0/255 green:108.0/255.0 blue:108.0/255.0 alpha:1.0];
}
@end