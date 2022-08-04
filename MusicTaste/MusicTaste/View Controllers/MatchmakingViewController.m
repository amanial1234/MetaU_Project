#import "MatchmakingViewController.h"
#import "MatchCell.h"
#import "SpotifyAPIManager.h"
#import "MatchingAlgorithm.h"
#import "Parse/Parse.h"
#import "SpotifyAPIManager.h"
#import "AppDelegate.h"
#import "SceneDelegate.h"
#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "dispatch/dispatch.h"
#import "LoginViewController.h"
@interface MatchmakingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *MatchTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSString *name;
@property (strong, nonatomic) NSArray *matchesObjectIds;
@property (nonatomic, strong) NSArray *profilePicture;
- (IBAction)didTapLogout:(id)sender;

@end

@implementation MatchmakingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Intializes TableView and gets User from SpotifyAPIManager
    self.author = [SpotifyAPIManager shared].author;
    self.MatchTableView.dataSource = self;
    self.MatchTableView.delegate = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.MatchTableView insertSubview:self.refreshControl atIndex:0];
    [self.MatchTableView addSubview:self.refreshControl];
    self.MatchTableView.rowHeight = 540;
    //Checks if Notification has been updated
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateView:)
                                                 name:@"TestNotification"
                                               object:nil];
    MatchCell *cell = [_MatchTableView dequeueReusableCellWithIdentifier:@"MatchCell"];
    [self.view bringSubviewToFront:cell.matchName];
}

- (void)updateView:(BOOL)animated{
    //Function to update matches once the notifcation is returned
    self.author  = [SpotifyAPIManager shared].author;
    if ([self.author valueForKey:@"matches"] != nil){
        [[MatchingAlgorithm shared] lookForMatches];
    }
    [self getMatchesDictionary];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.matches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MatchCell"];
    PFObject *match = self.matches[indexPath.row];
    //returns Genres, bio, name, and user's Artists
    cell.matchName.text = [[match valueForKey:@"username"] stringByAppendingString:@","];
    cell.matchAge.text = [match valueForKey:@"age"];
    cell.matchBio.text = [match valueForKey:@"bio"];
    cell.matchArtists.text = [[[match valueForKey:@"images"] objectAtIndex:0] objectAtIndex:0];
    cell.matchGenres.text = [[match valueForKey:@"genres"] objectAtIndex:0];
    if ([match valueForKey:@"userimage"] != nil){
        NSString *URLString = [match valueForKey:@"userimage"];
        NSString *stringWithoutNormal = [URLString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
        NSURL *urlNew = [NSURL URLWithString:stringWithoutNormal];
        [cell.matchImage setImageWithURL: urlNew];
        cell.matchImage.layer.cornerRadius = cell.matchImage.frame.size.height/10;
    }
    return cell;
}

-(void)getMatchesDictionary{
    PFQuery *music = [PFQuery queryWithClassName:@"Music"];
    NSMutableArray *allMatchesArray = [self.author valueForKey:@"matches"];
    //query through each match
    [music findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            self.matches = [[NSMutableArray alloc] init];
            for (NSString *matchid in allMatchesArray){
                for (PFObject *user in users){
                    if ([matchid isEqual: user.objectId]){
                        [self.matches addObject:user];
                        [self.MatchTableView reloadData];
                    }
                }
            }
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Segue to Details View Controller
    if([[segue identifier] isEqualToString:@"detailsSegue"]) {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.MatchTableView indexPathForCell:cell];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        PFUser *match = self.matches[indexPath.row];
        //shares matches Array and Match User to DetailsViewController
        detailsViewController.author = match;
        detailsViewController.matches = self.matches;
    }
}

-(NSURL*)convertURL:(NSString *) url{
    NSString *stringWithoutNormal = [url stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    //Removes the string "normal" from url to be able to use the URL
    NSURL *urlNew = [NSURL URLWithString:stringWithoutNormal];
    return urlNew;
}

- (void) receiveTestNotification:(NSNotification *) notification{
    //Function to see if the notification has been recieved.
    if ([[notification name] isEqualToString:@"TestNotification"])
        NSLog (@"Successfully received the test notification!");
}

- (IBAction)didTapLogout:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        appDelegate.window.rootViewController = loginViewController;
        [self performSegueWithIdentifier:@"MLoginSegue" sender:nil];
    });
}
@end
