#import "ChatViewController.h"
#import "UIColor+HTColor.h"
#import "MessageCell.h"
#import "Conversation.h"
#import "Message.h"
#import "dispatch/dispatch.h"
@import ParseLiveQuery;

@interface ChatViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chatTableView.dataSource = self;
    self.chatTableView.delegate = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.chatTableView insertSubview:self.refreshControl atIndex:0];
    [self.chatTableView addSubview:self.refreshControl];
    self.chatTableView.rowHeight = 126;
    
    UIColor *topColor = [UIColor ht_bitterSweetDarkColor];
    UIColor *bottomColor = [UIColor blackColor];
        
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    theViewGradient.frame = self.view.bounds;
    theViewGradient.startPoint = CGPointZero;
    theViewGradient.endPoint = CGPointMake(0, .1);
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    [self.view.layer insertSublayer:theViewGradient atIndex:0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
//    PFObject *match = self.acceptedMatches[indexPath.row];
//    //returns Genres, bio, name, and user's Artists
//    cell.matchName.text = [[match valueForKey:@"username"] stringByAppendingString:@","];
//    if ([match valueForKey:@"userimage"] != nil){
//        NSString *URLString = [match valueForKey:@"userimage"];
//        NSString *stringWithoutNormal = [URLString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
//        NSURL *urlNew = [NSURL URLWithString:stringWithoutNormal];
//        [cell.matchImage setImageWithURL: urlNew];
//        cell.matchImage.layer.cornerRadius = cell.matchImage.frame.size.height/10;
//    }
    return cell;
}

-(void)liveQuerySetup{
    self.client = [[PFLiveQueryClient alloc] init];
    self.query = [self queryForMessagesBetweenTwoUsers];
    self.subscription = [[self.client subscribeToQuery:self.query] addCreateHandler:^(PFQuery *query, PFObject *object){
        Message *message = [message.author fetchIfNeeded];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.messages addObject:message];
            [self.conversation.messages] = [NSArray arrayWithArray:self.messages];
            [self.conversation saveInBackground];
            [self.chatTableView reloadData];
        });
    }];
}
@end
