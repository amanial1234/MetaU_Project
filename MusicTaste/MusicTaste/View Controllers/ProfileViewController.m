#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"

@interface ProfileViewController () 
//connects objects: Screenname and profileview
@property (weak, nonatomic) IBOutlet UILabel *screen_name;
@property (weak, nonatomic) IBOutlet UIImageView *profileView;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Sets username
    self.screen_name.text = [[User user] name];
    //Gets image Url
    NSString *URLString = [[User user] profilePicture];
    NSString *stringWithoutNormal = [URLString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *urlNew = [NSURL URLWithString:stringWithoutNormal];
    [self.profileView setImageWithURL: urlNew];
    //Makes image Circle
    self.profileView.layer.cornerRadius = self.profileView.frame.size.height/2;
    self.profileView.layer.masksToBounds = YES;
    self.profileView.layer.borderWidth = 0;
    
}

@end    
