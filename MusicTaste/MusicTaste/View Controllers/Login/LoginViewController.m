//
//  LoginViewController.m
//  MusicTaste
//
//  Created by Aman Abraham on 7/6/22.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "ConnectView.h"
#import "LoginViewController.h"

static NSString * const SpotifyClientID = @"9f9a8a428178497e8c58840c65d9f3c0";
static NSString * const SpotifySecretID = @"085725985e87480fab42de4970086a54";
static NSString * const SpotifyRedirectURLString = @"spotify-ios-quick-start://spotify-login-callback";


@interface UIViewController ()

@property (nonatomic, assign) BOOL didAuthorize;

@end

@implementation LoginViewController

@synthesize didAuthorize = _didAuthorize;

#pragma mark - Authorization example

- (void)viewDidLoad
{
    SPTConfiguration *configuration = [SPTConfiguration configurationWithClientID:SpotifyClientID
                                                                      redirectURL:[NSURL URLWithString:SpotifyRedirectURLString]];
    self.sessionManager = [SPTSessionManager sessionManagerWithConfiguration:configuration
                                                                       delegate:self];
    [super viewDidLoad];
    if(self.didAuthorize){
    }
    else{
    }
}

#pragma mark - Actions

- (void)didTapAuthButton:(ConnectButton *)sender
{
    SPTScope scope = SPTUserLibraryReadScope | SPTPlaylistReadPrivateScope;
    if (@available(iOS 11, *)) {
        [self.sessionManager initiateSessionWithScope:scope options:SPTDefaultAuthorizationOption ];
    } else {
        [self.sessionManager initiateSessionWithScope:scope options:SPTDefaultAuthorizationOption presentingViewController:self];
    }
}

#pragma mark - SPTSessionManagerDelegate

- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session
{
    [self presentAlertControllerWithTitle:@"Authorization Succeeded"
                                  message:session.description
                              buttonTitle:@"Nice"];
    self.didAuthorize = YES;
}



- (void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error
{
    [self presentAlertControllerWithTitle:@"Authorization Failed"
                                  message:error.description
                              buttonTitle:@"Bummer"];
}

- (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session
{
    [self presentAlertControllerWithTitle:@"Session Renewed"
                                  message:session.description
                              buttonTitle:@"Sweet"];
}

#pragma mark - Set up view

- (void)loadView
{
    ConnectView *view = [ConnectView new];
    [view.connectButton addTarget:self action:@selector(didTapAuthButton:) forControlEvents:UIControlEventTouchUpInside];
    self.view = view;
}

- (void)presentAlertControllerWithTitle:(NSString *)title
                                message:(NSString *)message
                            buttonTitle:(NSString *)buttonTitle
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:buttonTitle
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:dismissAction];
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
    });
}

@end
