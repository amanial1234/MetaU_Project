#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *messages;
@property (nonatomic, strong) PFObject *conversation;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) PFUser *user;
@end

NS_ASSUME_NONNULL_END
