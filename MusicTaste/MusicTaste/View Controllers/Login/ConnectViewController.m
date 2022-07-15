#import "ConnectViewController.h"
#import <Parse/Parse.h>
#import "ConnectView.h"
#import "SpotifyAPIManager.h"
#import "dispatch/dispatch.h"
#import "MatchmakingViewController.h"

@interface UIViewController ()

@end

@implementation ConnectViewController

#pragma mark - Authorization example

- (void)viewDidLoad
{
    [super viewDidLoad];
}
#pragma mark - Actions

- (void)didTapAuthButton:(ConnectButton *)sender
{
    SpotifyAPIManager *api = [SpotifyAPIManager shared];
    [api setUpSpotifyWithCompletion:^(NSDictionary *data, NSError *error) {
        if (!error) {
            //Once Authorized it the ConnectViewController will segue to the Login View Controlelr
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }else{}
    }];
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
