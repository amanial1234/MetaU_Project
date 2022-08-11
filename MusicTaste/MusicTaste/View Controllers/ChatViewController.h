#import <UIKit/UIKit.h>
@import ParseLiveQuery;
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *messages;
@property (nonatomic, strong) PFLiveQueryClient *client;
@property (nonatomic, strong) PFQuery *query;
@end

NS_ASSUME_NONNULL_END
