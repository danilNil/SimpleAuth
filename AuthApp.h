//
// Created by Danil on 30/06/14.
// Copyright (c) 2014 Mabogo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AuthApp : NSObject
@property(nonatomic, copy) NSString *redirectURL;
@property(nonatomic, copy) NSString *clientId;
@property(nonatomic, strong) NSString *authUrl;
+ (id)applicationWithRedirectURL:(NSString *)format authUrl:(NSString *)authUrl clientId:(NSString *)id grantedAccess:(NSArray *)access;
- (NSString *)grantedAccessString;

- (NSString *)authRequest;
@end