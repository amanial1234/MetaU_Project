#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"
#import <Parse/Parse.h>
#import "EditViewController.h"
#import "SpotifyAPIManager.h"

@interface ProfileViewController () 
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *bio;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UIImageView *artist1View;
@property (weak, nonatomic) IBOutlet UIImageView *artist2View;
@property (weak, nonatomic) IBOutlet UIImageView *artist3View;
@property (weak, nonatomic) IBOutlet UIImageView *artist4View;
@property (weak, nonatomic) NSMutableArray *artists;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.author  = [SpotifyAPIManager shared].author;
    self.artists = [[User user] artists];
    self.screenName.text = [[User user] name];
    NSString *URLString = [[User user] profilePicture];
    NSURL *urlNew = [self convertURL: URLString];
    [self.profileView setImageWithURL: urlNew];
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
    //updates bio and age when View appears
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
@end
