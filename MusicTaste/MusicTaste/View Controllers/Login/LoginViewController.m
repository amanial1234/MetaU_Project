
#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "UIColor+HTColor.h"
#import "SpotifyAPIManager.h"

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Make Username and Password UIText Delegates
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
}

- (IBAction)logIn:(id)sender {
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    if ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]){
        //If the username and password are empty return Invalid Login
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Login"
                                                                       message:@"Username and password required."
                                                                       preferredStyle:(UIAlertControllerStyleAlert)];
        //If the username and password are not empty say it is Okay
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                         }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error == nil) {
            //If the username and password are in the data base perform segue to MatchmakingViewController
            [self performSegueWithIdentifier:@"tabBarSegue" sender:nil];
            
        }
        else{
            //If the username and password are not in the data base return Invalid Login UIAlert
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Login"
                                                                           message:@"Username and/or password incorrect."
                                                                           preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                             }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{
            }];
        }
    }];
}
- (IBAction)signUp:(id)sender {
    //If the user signs up the password and username will be added to the database
    PFUser *newUser = [PFUser user];
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
        }
    }];
}

@end
