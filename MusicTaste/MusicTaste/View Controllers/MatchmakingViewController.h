#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface MatchmakingViewController : UIViewController
@property (nonatomic, strong) PFUser *author;
@property (strong, nonatomic) NSMutableArray *matches;
@end

NS_ASSUME_NONNULL_END
