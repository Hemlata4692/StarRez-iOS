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

+ (UIColor*)parcelColor {
    return [UIColor colorWithRed:49.0/255 green:104.0/255.0 blue:178.0/255.0 alpha:1.0];
}

+ (UIColor*)eventColor:(float)alpha {
    return [UIColor colorWithRed:255.0/255 green:196.0/255.0 blue:12.0/255.0 alpha:alpha];
}

+ (UIColor*)resourceColor:(float)alpha {
    return [UIColor colorWithRed:45.0/255 green:179.0/255.0 blue:74.0/255.0 alpha:alpha];
}

+ (UIColor*)returnedColor:(float)alpha {
    return [UIColor colorWithRed:229.0/255 green:41.0/255.0 blue:35.0/255.0 alpha:alpha];
}
@end