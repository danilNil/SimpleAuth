//
// Created by Danil on 30/06/14.
//

#import "AuthHttpClient.h"
#import "AuthApp.h"
#import "AuthViewController.h"

@interface AuthHttpClient ()
@property(nonatomic, strong) AuthApp *application;
@property(nonatomic, strong) UIViewController* presentingViewController;
@end

@implementation AuthHttpClient

+ (id)clientForApplication:(AuthApp *)application baseURL:(NSString *)url presentingViewController:(UIViewController *)controller {
    AuthHttpClient *client = [[self alloc] initWithBaseURL:[NSURL URLWithString:url]];
    client.application = application;
    client.presentingViewController = controller;
    return client;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self setResponseSerializer:[AFJSONResponseSerializer serializer]];
    }
    return self;
}


- (void)getAuthorizationCode:(void (^)(NSString *))success cancel:(void (^)(void))cancel failure:(void (^)(NSError *))failure {
    AuthViewController *authorizationViewController = [[AuthViewController  alloc]
            initWithApplication:
                    self.application
                        success:^(NSString *code) {
                [self hideAuthenticateView];
                if (success) {
                    success(code);
                }
            }
                         cancel:^{
                [self hideAuthenticateView];
                if (cancel) {
                    cancel();
                }
            } failure:^(NSError *error) {
                [self hideAuthenticateView];
                if (failure) {
                    failure(error);
                }
            }];
    [self showAuthorizationView:authorizationViewController];
}

- (void)showAuthorizationView:(AuthViewController *)authorizationViewController {
    if (self.presentingViewController == nil)
        self.presentingViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;

    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:authorizationViewController];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        nc.modalPresentationStyle = UIModalPresentationFormSheet;
    }

    [self.presentingViewController presentViewController:nc animated:YES completion:nil];
}

- (void)hideAuthenticateView {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end