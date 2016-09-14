//
//  UIFont+CustomFont.m
//  Dwell
//
//  Created by Ranosys on 14/09/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "UIFont+CustomFont.h"

@implementation UIFont (CustomFont)

+ (UIFont*)calibriBoldWithSize:(int)size {
    
    UIFont *font=[UIFont fontWithName:@"Calibri-Bold" size:size];
    return font;
}

+ (UIFont*)calibriNormalWithSize:(int)size {
    
    UIFont *font=[UIFont fontWithName:@"Calibri" size:size];
    return font;
}

+ (UIFont*)handseanWithSize:(int)size {
    
    UIFont *font=[UIFont fontWithName:@"HandOfSean" size:size];
    return font;
}
@end
