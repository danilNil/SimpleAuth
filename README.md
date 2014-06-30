SimpleAuth
==========

Here is implementation of custom two step login flow. Suitable for Facebook, linkedin etc oAuth process.

Using:

```obj-c
- (void)loginToFacebookComplete:(void (^)())complete failure:(void (^)())failure {
    facebookClient = [self createFacebookClient];
    [facebookClient getAuthorizationCode:^(NSString *code) {
        NSLog(@"Auth success with auth_code: %@", code);
        //send code to your own server
        [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [self.manager GET:[NSString stringWithFormat:@"%@social/facebook/authorized", baseURL] parameters:@{@"code":code} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            complete();
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure();
        }];
    }                      cancel:^{
        NSLog(@"Authorization was cancelled by user");
        failure();
    }                     failure:^(NSError *error) {
        NSLog(@"Authorization failed %@", error);
        failure();
    }];
}


- (FacebookHttpClient *)createFacebookClient {
    FacebookApplication *application = [FacebookApplication applicationWithRedirectURL:[NSString stringWithFormat:@"%@social/facebook/authorized", baseURL]
                                                                               authUrl:@"https://www.facebook.com/dialog/oauth"
                                                                              clientId:@"xxxxxxxxxx"
                                                                         grantedAccess:[FacebookPermissions permissions]];
    return [FacebookHttpClient clientForApplication:application baseURL:@"https://www.facebook.com/" presentingViewController:self];
} 
```
