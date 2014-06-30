//
// Created by Danil on 30/06/14.
//

#import "AuthApp.h"

@interface AuthApp ()
@property(nonatomic, strong) NSArray *grantedAccess;

@end

@implementation AuthApp

+ (id)applicationWithRedirectURL:(NSString *)format authUrl:(NSString *)authUrl clientId:(NSString *)id grantedAccess:(NSArray *)access {
    return [[self alloc] initWithRedirectURL:format authUrl:authUrl clientId:id grantedAccess:access];
}



- (id)initWithRedirectURL:(NSString *)redirectURL authUrl:(NSString *)authUrl clientId:(NSString *)clientId grantedAccess:(NSArray *)grantedAccess {
    self = [super init];
    if (self) {
        self.redirectURL = redirectURL;
        self.clientId = clientId;
        self.grantedAccess = grantedAccess;
        self.authUrl = authUrl;
    }

    return self;
}


- (NSString *)grantedAccessString {
    return [self.grantedAccess componentsJoinedByString: @"%20"];
}

- (NSString *)authRequest {
    return [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=code&scope=%@", self.authUrl, self.clientId, self.redirectURL, self.grantedAccessString];
}
@end