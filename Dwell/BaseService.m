//
//  Webservice.m
//  MyTake
//
//  Created by Hema on 11/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "BaseService.h"
#import "XMLDictionary.h"
#import "NullValueChecker.h"

@implementation BaseService


#pragma mark - Singleton instance
- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}
#pragma mark - end

//Post method for other services
- (void)post:(NSString *)path parameters:(NSString *)parameters onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url=[NSURL URLWithString:path];
    NSData *postData = [parameters dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request addValue:@"starrez.temp2" forHTTPHeaderField:@"StarRezUsername"];
    [request addValue:@"9591404d-1069-4290-b121-63b1a7e9e932" forHTTPHeaderField:@"StarRezPassword"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              NSString *responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                               NSMutableDictionary* responseData=[NSMutableDictionary new];
                                              if ([responseString isEqualToString:@""]) {
                                                  [responseData setObject:@"2" forKey:@"success"];
                                                  failure(responseData);
                                              }
                                              else if ((NULL!=responseString)&&(nil!=responseString)) {
                                                  
                                                   responseData=(NSMutableDictionary *)[NullValueChecker checkArrayForNullValue:[[[XMLDictionaryParser sharedInstance] dictionaryWithString:responseString] mutableCopy]];
                                                  if (responseData.count!=0) {
                                                      [responseData setObject:@"1" forKey:@"success"];
                                                      success(responseData);
                                                  }
                                                  else {
                                                      [responseData setObject:@"0" forKey:@"success"];
                                                      failure(responseData);
                                                  }
                                              }
                                          }];
    
    [postDataTask resume];
}

- (void)jsonPost:(NSString *)path parameters:(NSDictionary *)parameters onSuccess:(void (^)(id))success onFailure:(void (^)(id))failure {
    
    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url=[NSURL URLWithString:path];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];;
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              NSString *responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                              NSMutableDictionary* responseData=[NSMutableDictionary new];
                                              if ([responseString isEqualToString:@""]) {
                                                  [responseData setObject:@"2" forKey:@"success"];
                                                  failure(responseData);
                                              }
                                              else if ((NULL!=responseString)&&(nil!=responseString)) {
                                                  
                                                  responseData=(NSMutableDictionary *)[NullValueChecker checkArrayForNullValue:[[[XMLDictionaryParser sharedInstance] dictionaryWithString:responseString] mutableCopy]];
                                                  if (responseData.count!=0) {
                                                      [responseData setObject:@"1" forKey:@"success"];
                                                      success(responseData);
                                                  }
                                                  else {
                                                      [responseData setObject:@"0" forKey:@"success"];
                                                      failure(responseData);
                                                  }
                                              }
                                          }];
    
    [postDataTask resume];
}
#pragma mark - end
@end