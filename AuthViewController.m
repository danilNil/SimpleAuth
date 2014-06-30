//
// Created by Danil on 30/06/14.
//

#import "AuthViewController.h"
#import "AuthApp.h"
#import "MBProgressHUD.h"
#import "FacebookAuthorizationViewController.h"

@interface AuthViewController()<UIWebViewDelegate>
@property(nonatomic, strong) UIWebView *authenticationWebView;
@property(nonatomic, copy) AuthorizationCodeFailureCallback failureCallback;
@property(nonatomic, copy) AuthorizationCodeSuccessCallback successCallback;
@property(nonatomic, copy) AuthorizationCodeCancelCallback cancelCallback;
@property(nonatomic, strong) AuthApp *application;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation AuthViewController
NSString *kErrorDomain = @"AUTH_ERROR";
BOOL handlingRedirectURL;

- (id)initWithApplication:(AuthApp *)application success:(AuthorizationCodeSuccessCallback)success cancel:(AuthorizationCodeCancelCallback)cancel failure:(AuthorizationCodeFailureCallback)failure {
    self = [super init];
    if (self) {
        self.application = application;
        self.successCallback = success;
        self.cancelCallback = cancel;
        self.failureCallback = failure;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(tappedCancelButton:)];
    self.navigationItem.leftBarButtonItem = cancelButton;

    self.authenticationWebView = [[UIWebView alloc] init];
    self.authenticationWebView.delegate = self;
    self.authenticationWebView.scalesPageToFit = YES;
    [self.view addSubview:self.authenticationWebView];
    self.hud = [[MBProgressHUD alloc] initWithView:self.authenticationWebView];
    [self.authenticationWebView addSubview:self.hud];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.authenticationWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.application authRequest]]]];
    [self.hud show:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.authenticationWebView.frame = self.view.bounds;
}


#pragma mark UI Action Methods

- (void)tappedCancelButton:(id)sender {
    self.cancelCallback();
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = [[request URL] absoluteString];

    //prevent loading URL if it is the redirectURL
    handlingRedirectURL = [url hasPrefix:self.application.redirectURL];

    if (handlingRedirectURL) {
        if ([url rangeOfString:@"error"].location != NSNotFound) {
            NSError *error = [[NSError alloc] initWithDomain:kErrorDomain code:1 userInfo:[[NSMutableDictionary alloc] init]];
            self.failureCallback(error);
        } else {
            NSString *authorizationCode = [self extractGetParameter:@"code" fromURLString: url];
            self.successCallback(authorizationCode);
        }
    }
    return !handlingRedirectURL;
}

- (NSString *)extractGetParameter: (NSString *) parameterName fromURLString:(NSString *)urlString {
    NSMutableDictionary *mdQueryStrings = [[NSMutableDictionary alloc] init];
    urlString = [[urlString componentsSeparatedByString:@"?"] objectAtIndex:1];
    for (NSString *qs in [urlString componentsSeparatedByString:@"&"]) {
        [mdQueryStrings setValue:[[[[qs componentsSeparatedByString:@"="] objectAtIndex:1]
                stringByReplacingOccurrencesOfString:@"+" withString:@" "]
                stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                          forKey:[[qs componentsSeparatedByString:@"="] objectAtIndex:0]];
    }
    return [mdQueryStrings objectForKey:parameterName];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (!handlingRedirectURL)
        self.failureCallback(error);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    [self.hud hide:YES];
    /*fix for the LinkedIn Auth window - it doesn't scale right when placed into
     a webview inside of a form sheet modal. If we transform the HTML of the page
     a bit, and fix the viewport to 540px (the width of the form sheet), the problem
     is solved.
    */
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSString* js =
                @"var meta = document.createElement('meta'); "
                        @"meta.setAttribute( 'name', 'viewport' ); "
                        @"meta.setAttribute( 'content', 'width = 540px, initial-scale = 1.0, user-scalable = yes' ); "
                        @"document.getElementsByTagName('head')[0].appendChild(meta)";

        [webView stringByEvaluatingJavaScriptFromString: js];
    }
}
@end