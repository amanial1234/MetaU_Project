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

@interface MatchmakingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *MatchTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSString *name;
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
    [[MatchingAlgorithm shared] lookForMatches];
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MatchCell"];
    cell.matchName.text = @"Aman, 20";
    return cell;
}

@end
