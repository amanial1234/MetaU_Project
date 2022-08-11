#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessagingViewController : UIViewController
@property (nonatomic, strong) PFUser *author;
@property (strong, nonatomic) NSMutableArray *acceptedMatches;
@end

NS_ASSUME_NONNULL_END
