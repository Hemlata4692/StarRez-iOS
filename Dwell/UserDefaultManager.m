//
//  UserDefaultManager.m
//
//  Created by Sumit on 08/09/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import "UserDefaultManager.h"

@implementation UserDefaultManager

//Set data in userDefault
+ (void)setValue:(id)value key:(NSString *)key {
    
    [[NSUserDefaults standardUserDefaults]setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

//Fetch data in userDefault
+ (id)getValue:(NSString *)key {
    
    return [[NSUserDefaults standardUserDefaults]objectForKey:key];
}

//Remove data in userDefault
+ (void)removeValue:(NSString *)key {
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
}

//Get dynamic height according to string
+ (float)getDynamicLabelHeight:(NSString *)text font:(UIFont *)font widthValue:(float)widthValue {
    
    CGSize size = CGSizeMake(widthValue,1000);
    CGRect textRect=[text
                     boundingRectWithSize:size
                     options:NSStringDrawingUsesLineFragmentOrigin
                     attributes:@{NSFontAttributeName:font}
                     context:nil];
    return textRect.size.height;
}

//Convert system dateTime to GMT+1 dateTime format
+ (NSString *)sytemToGMTDateTimeFormat:(NSDate *)conversionDateTime {
    
     NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
     NSInteger seconds = [[NSTimeZone systemTimeZone] secondsFromGMT];
    seconds+=(60*60);   //Add 1 hour in GMT seconds differece
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *a=[conversionDateTime dateByAddingTimeInterval:seconds];
    NSString *conversionDateTimeString=[dateFormat stringFromDate:a];
    DLog(@"%@",conversionDateTimeString);
    
    return conversionDateTimeString;
}

//Convert system dateTime to GMT+1 dateTime format
+ (NSString *)GMTToSytemDateTimeFormat:(NSString *)conversionDateTime {
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    NSInteger seconds = [[NSTimeZone systemTimeZone] secondsFromGMT];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//    NSDate *fromDate=[dateFormat dateFromString:conversionDateTime];
//    NSDate *a=[dateFormat dateFromString:conversionDateTime];
//    NSDate *b=[[dateFormat dateFromString:conversionDateTime] dateByAddingTimeInterval:-(60*60)];
    NSDate *convertedDateTime=[[[dateFormat dateFromString:conversionDateTime] dateByAddingTimeInterval:-(60*60)] dateByAddingTimeInterval:-seconds];   //First convert string to date then subtract one hour from NSDate then convert in my system date from GMT date format
//    DLog(@"%@,%@,%@",a,b,c);
    
    NSString *conversionDateTimeString=[dateFormat stringFromDate:convertedDateTime];
    DLog(@"%@",conversionDateTimeString);
    return conversionDateTimeString;
}
@end
