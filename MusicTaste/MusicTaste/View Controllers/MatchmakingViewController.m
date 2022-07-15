#import "MatchmakingViewController.h"
#import "MatchCell.h"

@interface MatchmakingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *MatchTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end
    
@implementation MatchmakingViewController

+ (instancetype)sharedMatchmaking {
    static MatchmakingViewController * MatchVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MatchVC = [[self alloc] init];
    });
    return MatchVC;
}


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
