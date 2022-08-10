#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import <Parse/Parse.h>
#import "EditViewController.h"
#import "SpotifyAPIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "dispatch/dispatch.h"
#import "Parse/PFImageView.h"

@interface ProfileViewController () 
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *bio;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet PFImageView *profileView;
@property (weak, nonatomic) IBOutlet UIImageView *artist1View;
@property (weak, nonatomic) IBOutlet UIImageView *artist2View;
@property (weak, nonatomic) IBOutlet UIImageView *artist3View;
@property (weak, nonatomic) IBOutlet UIImageView *artist4View;
@property (weak, nonatomic) NSMutableArray *artists;

- (IBAction)didTapLogout:(id)sender;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.author  = [SpotifyAPIManager shared].author;
    self.artists = [self.author valueForKey:@"artistsimages"];
    self.screenName.text = [self.author valueForKey:@"username"];
    //if statement to check if there is a customiamge to replace the default image
    if ([self.author valueForKey:@"usercustomimage"] != nil){
        self.profileView.file = [self.author valueForKey:@"usercustomimage"];
        [self.profileView loadInBackground];
    }
    else{
        if ([self.author valueForKey:@"userimage"] != nil){
            NSString *URLString = [self.author valueForKey:@"userimage"];
            NSURL *urlNew = [self convertURL: URLString];
            [self.profileView setImageWithURL: urlNew];
        }
    }
    //Gets top artists images using fucntion Convert Url
    [self.artist1View setImageWithURL:[self convertURL:[[self.artists objectAtIndex:0] objectAtIndex:1]]];
    [self.artist2View setImageWithURL:[self convertURL:[[self.artists objectAtIndex:1] objectAtIndex:1]]];
    [self.artist3View setImageWithURL:[self convertURL:[[self.artists objectAtIndex:2] objectAtIndex:1]]];
    [self.artist4View setImageWithURL:[self convertURL:[[self.artists objectAtIndex:3] objectAtIndex:1]]];
    //Makes image Circle
    self.profileView.layer.cornerRadius = self.profileView.frame.size.height/2;
    self.profileView.layer.masksToBounds = YES;
    self.profileView.layer.borderWidth = 0;
    self.bio.text = [self.author valueForKey:@"bio"];
    self.age.text = [self.author valueForKey:@"age"];
}

-(void)viewDidAppear:(BOOL)animated{
    //updates bio, age, and image when View appears
    if ([self.author valueForKey:@"usercustomimage"] != nil){
        self.profileView.file = [self.author valueForKey:@"usercustomimage"];
        [self.profileView loadInBackground];
    }
    self.bio.text = [self.author valueForKey:@"bio"];
    self.age.text = [self.author valueForKey:@"age"];
}

- (IBAction)editAction:(id)sender {
    //segues when the edit button is pressed
    [self performSegueWithIdentifier:@"editSegue" sender:nil];
}

-(NSURL*)convertURL:(NSString *) url{
    NSString *stringWithoutNormal = [url stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    //Removes the string "normal" from url to be able to use the URL
    NSURL *urlNew = [NSURL URLWithString:stringWithoutNormal];
    return urlNew;
}
- (IBAction)didTapLogout:(UIButton *)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [self performSegueWithIdentifier:@"PLoginSegue" sender:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"editSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        EditViewController *editController = (EditViewController*)navigationController.topViewController;
        //passes the user
        editController.author = self.author;
    }
}

@end
