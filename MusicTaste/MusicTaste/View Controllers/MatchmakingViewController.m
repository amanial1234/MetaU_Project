#import "MatchmakingViewController.h"
#import "MatchCell.h"
#import "User.h"
#import "SpotifyAPIManager.h"
#import "MatchingAlgorithm.h"
#import "Parse/Parse.h"
#import "SpotifyAPIManager.h"
#import "AppDelegate.h"
#import "SceneDelegate.h"
#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MatchmakingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *MatchTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSString *name;
@property (strong, nonatomic) NSArray *matchesObjectIds;
@property (strong, nonatomic) NSMutableArray *matches;
@property (nonatomic, strong) NSArray *profilePicture;

@end
    
@implementation MatchmakingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.MatchTableView.dataSource = self;
    self.MatchTableView.delegate = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.MatchTableView insertSubview:self.refreshControl atIndex:0];
    [self.MatchTableView addSubview:self.refreshControl];
    self.MatchTableView.rowHeight = 540;
    MatchCell *cell = [_MatchTableView dequeueReusableCellWithIdentifier:@"MatchCell"];
    [self.view bringSubviewToFront:cell.matchName];
    [self getMatchesDictionary];
    [[MatchingAlgorithm shared] lookForMatches];
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.matches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MatchCell"];
    PFObject *match = self.matches[indexPath.row];
    cell.matchName.text = [match valueForKey:@"username"];
    cell.matchArtists.text = [[[match valueForKey:@"images"] objectAtIndex:0] objectAtIndex:0];
    cell.matchGenres.text = [[match valueForKey:@"genres"] objectAtIndex:0];
    if ([match valueForKey:@"userimage"] != nil){
        NSString *URLString = [match valueForKey:@"userimage"];
        NSString *stringWithoutNormal = [URLString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
        NSURL *urlNew = [NSURL URLWithString:stringWithoutNormal];
        [cell.matchImage setImageWithURL: urlNew];
    }
    return cell;
}

-(void)getMatchesDictionary{
    //goes through users to get all the matches user's ID
    PFUser *current = [PFUser currentUser];
    PFQuery *music = [PFQuery queryWithClassName:@"Music"];
    NSArray *musicUsers = [music findObjects];
    for (PFObject *user in musicUsers){
        if ([[user valueForKey:@"userId"] isEqual:current.objectId]){
            NSMutableArray *allMatchesArray = [user valueForKey:@"matches"];
            NSMutableDictionary *matchesDict = [allMatchesArray objectAtIndex:0];
            self.matchesObjectIds = [matchesDict keysSortedByValueUsingSelector:@selector(compare:)];
        }
    }
    //query through each match
    [music findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            self.matches = [[NSMutableArray alloc] initWithArray:users];
            for (PFObject *user in users){
                if (![self.matchesObjectIds containsObject: user.objectId]){
                    [self.matches removeObject:user];
                    [self.MatchTableView reloadData];
                }
            }
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Segue to Details View Controller
    if([[segue identifier] isEqualToString:@"detailsSegue"]) {
        UITableViewCell *cell = sender;
        NSIndexPath *indexpath = [self.MatchTableView indexPathForCell:cell];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        PFUser *match = self.matches[indexpath.row];
        detailsViewController.author = match;
    }
}
@end
