#import "ChatViewController.h"
#import "UIColor+HTColor.h"
#import "MessageCell.h"
#import "dispatch/dispatch.h"
#import "Parse/Parse.h"


@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self queryForConversation];
    
    self.chatTableView.dataSource = self;
    self.chatTableView.delegate = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.chatTableView insertSubview:self.refreshControl atIndex:0];
    [self.chatTableView addSubview:self.refreshControl];
    
    self.sendButton.layer.cornerRadius = 12;
    self.sendButton.layer.masksToBounds = YES;
    self.sendButton.layer.borderWidth = 1;
    self.sendButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
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
- (IBAction)sendbutton:(id)sender {
    NSMutableArray *matchArray = [NSMutableArray array];
    NSMutableArray *convoArray = [[NSMutableArray alloc] initWithArray:[self.conversation valueForKey:@"messages"]];
    [matchArray addObject:self.messageField.text];
    [matchArray addObject:self.user.objectId];
    [convoArray addObject: matchArray];
    self.conversation[@"messages"] = convoArray;
    [self.conversation saveEventually];
    self.messages = convoArray;
    [self.chatTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    NSMutableArray *messages = self.messages[indexPath.row];
    if ([[messages objectAtIndex: 1] isEqual: self.author.objectId]){
        cell.messageTextLabel.text = [@"    " stringByAppendingString:[messages objectAtIndex: 0]];
        cell.senderNameLabel.text = [self.author valueForKey:@"username"];
    }
    if ([[messages objectAtIndex: 1] isEqual: self.user.objectId]){
        cell.messageTextLabel.text = [@"    " stringByAppendingString:[messages objectAtIndex: 0]];
        cell.senderNameLabel.text = [self.user valueForKey:@"username"];
    }
    cell.messageTextLabel.layer.cornerRadius = 12;
    cell.messageTextLabel.layer.masksToBounds = YES;
    cell.messageTextLabel.layer.borderWidth = 1;
    cell.messageTextLabel.layer.borderColor = [UIColor whiteColor].CGColor;

    return cell;
}

-(void)createConversation{
    NSMutableArray *users = [NSMutableArray array];
    [users addObject:self.author.objectId];
    [users addObject: self.user.objectId];
    PFObject *conversation = [PFObject objectWithClassName:@"Conversation"];
    conversation[@"usersInConversation"] = users;
    self.conversation = conversation;
    [conversation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
      if (succeeded) {
          NSLog(@"Wooo");
      } else {
          NSLog(@"%@", error.description);
      }
    }];
}

-(void)queryForConversation{
    PFQuery *query = [PFQuery queryWithClassName:@"Conversation"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (results.count == 0){
            [self createConversation];
        }
        for (PFObject *convo in results){
            if ([[convo valueForKey:@"usersInConversation"] containsObject: self.author.objectId] && [[convo valueForKey:@"usersInConversation"] containsObject: self.user.objectId]){
                self.conversation = convo;
                self.messages = [self.conversation valueForKey:@"messages"];
                [self.chatTableView reloadData];
            }else{
                [self createConversation];
            }
        }
    }];
}

@end
