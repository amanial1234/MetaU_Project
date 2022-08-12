#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"
#import "UIImageView+AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *messages;
@property (nonatomic, strong) PFObject *conversation;
@property (nonatomic, strong) PFUser *match;
@property (nonatomic, strong) PFUser *user;
@property (weak, nonatomic) IBOutlet PFImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@end

NS_ASSUME_NONNULL_END
