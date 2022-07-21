#import "ConnectViewController.h"
#import <Parse/Parse.h>
#import "ConnectView.h"
#import "SpotifyAPIManager.h"
#import "dispatch/dispatch.h"
#import "MatchmakingViewController.h"

@interface UIViewController ()

@end

@implementation ConnectViewController

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
            //Once authorize the ConnectViewController will segue to the LoginView Controlelr
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
@end
