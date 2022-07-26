#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"

@interface ProfileViewController () 
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UIImageView *profileView;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName.text = [[User user] name];
    NSString *URLString = [[User user] profilePicture];
    //Removes the string "normal" from url to be able to use the URL
    NSString *stringWithoutNormal = [URLString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *urlNew = [NSURL URLWithString:stringWithoutNormal];
    [self.profileView setImageWithURL: urlNew];
    //Makes image Circle
    self.profileView.layer.cornerRadius = self.profileView.frame.size.height/2;
    self.profileView.layer.masksToBounds = YES;
    self.profileView.layer.borderWidth = 0;
    
}

@end    
