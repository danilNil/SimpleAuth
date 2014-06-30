//
// Created by Danil on 30/06/14.
//



@class AuthApp;

typedef void(^AuthorizationCodeSuccessCallback)(NSString *code);
typedef void(^AuthorizationCodeCancelCallback)(void);
typedef void(^AuthorizationCodeFailureCallback)(NSError *errorReason);

@interface AuthViewController : UIViewController
- (id)initWithApplication:(AuthApp *)application success:(AuthorizationCodeSuccessCallback)success cancel:(AuthorizationCodeCancelCallback)cancel failure:(AuthorizationCodeFailureCallback)failure;

@end