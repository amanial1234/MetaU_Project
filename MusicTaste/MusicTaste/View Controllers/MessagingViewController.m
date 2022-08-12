#import "MessagingViewController.h"
#import "Parse/Parse.h"
#import "AcceptedMatchCell.h"
#import "UIColor+HTColor.h"
#import "UIImageView+AFNetworking.h"
#import "ChatViewController.h"

@interface MessagingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *MatchTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation MessagingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.MatchTableView.dataSource = self;
    self.MatchTableView.delegate = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.MatchTableView insertSubview:self.refreshControl atIndex:0];
    [self.refreshControl addTarget:self action:@selector(getMatchesDictionary) forControlEvents:UIControlEventValueChanged];
    [self.MatchTableView insertSubview:self.refreshControl atIndex:0];
    [self.MatchTableView addSubview:self.refreshControl];
    self.MatchTableView.rowHeight = 126;
    [self getMatchesDictionary];
    
    AcceptedMatchCell *cell = [_MatchTableView dequeueReusableCellWithIdentifier:@"AcceptedMatchCell"];
    UIColor *topColor = [UIColor ht_jayDarkColor];
    UIColor *bottomColor = [UIColor blackColor];
    
    //Gets Gradient and sets it
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    theViewGradient.frame = self.view.bounds;
    theViewGradient.startPoint = CGPointZero;
    //Decides where to located the Gradient
    theViewGradient.endPoint = CGPointMake(0, .1);
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    [self.view.layer insertSublayer:theViewGradient atIndex:0];
    
    [self.view bringSubviewToFront:cell.matchName];
}

-(void)viewDidAppear:(BOOL)animated{
    [self getMatchesDictionary];
    [self.MatchTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.acceptedMatches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AcceptedMatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AcceptedMatchCell"];
    PFObject *match = self.acceptedMatches[indexPath.row];
    //Sets the userImage and User Name
    cell.matchName.text = [match valueForKey:@"username"];
    if ([match valueForKey:@"userimage"] != nil){
        NSString *URLString = [match valueForKey:@"userimage"];
        NSString *stringWithoutNormal = [URLString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
        NSURL *urlNew = [NSURL URLWithString:stringWithoutNormal];
        [cell.matchImage setImageWithURL: urlNew];
        cell.matchImage.layer.cornerRadius = cell.matchImage.frame.size.height/2;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)getMatchesDictionary{
    PFQuery *music = [PFQuery queryWithClassName:@"Music"];
    NSMutableArray *allMatchesArray = self.author[@"acceptedMatches"];
    //query through each match to get the accepted matches
    [music findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            self.acceptedMatches = [[NSMutableArray alloc] init];
            for (NSString *matchid in allMatchesArray){
                for (PFObject *user in users){
                    if ([matchid isEqual: user.objectId]){
                        [self.acceptedMatches addObject:user];
                    }
                }
                [self.MatchTableView reloadData];
            }
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Segue to Chat View Controller
    if([[segue identifier] isEqualToString:@"chatSegue"]) {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.MatchTableView indexPathForCell:cell];
        ChatViewController *chatViewController = [segue destinationViewController];
        PFUser *match = self.acceptedMatches[indexPath.row];
        chatViewController.match = match;
        chatViewController.user = self.author;
    }
}

@end
