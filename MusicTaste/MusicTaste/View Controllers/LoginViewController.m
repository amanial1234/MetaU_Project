//
//  LoginViewController.m
//  MusicTaste
//
//  Created by Aman Abraham on 7/6/22.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)loginbutton:(id)sender {
    [self loginUser];
}
- (IBAction)registerbutton:(id)sender {
    [self registerUser];
    
}
- (void)registerUser {
    [self performSegueWithIdentifier:@"loginSegue" sender:nil];
//    PFUser *newUser = [PFUser user];
//    newUser.username = self.usernameField.text;
//    newUser.password = self.passwordField.text;
//    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
//        if (error != nil) {
//            NSLog(@"Error: %@", error.localizedDescription);
//        } else {
//            NSLog(@"User registered successfully");
//
//            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
//        }
//    }];
}

- (void)loginUser {
    [self performSegueWithIdentifier:@"loginSegue" sender:nil];
//    NSString *username = self.usernameField.text;
//    NSString *password = self.passwordField.text;
//
//    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
//        if (error != nil) {
//            NSLog(@"User log in failed: %@", error.localizedDescription);
//        } else {
//            NSLog(@"User logged in successfully");
//
//            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
//        }
//    }];
}
@end
