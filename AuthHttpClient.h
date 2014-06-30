//
// Created by Danil on 30/06/14.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@class AuthApp;


@interface AuthHttpClient : AFHTTPRequestOperationManager
+ (id)clientForApplication:(AuthApp *)application baseURL:(NSString *)url presentingViewController:(UIViewController *)controller;

- (id)initWithBaseURL:(NSURL *)url;

- (void)getAuthorizationCode:(void (^)(NSString *))success cancel:(void (^)(void))cancel failure:(void (^)(NSError *))failure;
@end