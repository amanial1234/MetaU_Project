#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^CompletionBlock)();

@interface DetailsViewController : UIViewController

@property (copy, nonatomic) CompletionBlock completion;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) PFUser *author;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UILabel *bio;
@property (weak, nonatomic) IBOutlet PFImageView *profileView;
@property (strong, nonatomic) NSMutableArray *matches;
@property (strong, nonatomic) NSMutableArray *acceptedMatches;
@property (weak, nonatomic) IBOutlet UIImageView *artistsImage1;
@property (weak, nonatomic) IBOutlet UIImageView *artistsImage2;
@property (weak, nonatomic) IBOutlet UIImageView *artistsImage3;
@property (weak, nonatomic) IBOutlet UIImageView *artistsImage4;

@property (weak, nonatomic) IBOutlet UIView *dragAreaView;
@property (weak, nonatomic) IBOutlet UIView *dragView;
@property (weak, nonatomic) IBOutlet UIView *acceptView;
@property (weak, nonatomic) IBOutlet UIView *rejectView;
@property (weak, nonatomic) IBOutlet UILabel *acceptLabel;
@property (weak, nonatomic) IBOutlet UILabel *rejectLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dragViewX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dragViewY;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;

@property (assign, nonatomic) CGFloat initialDragViewY;
@property (readonly, nonatomic) BOOL isAcceptReached;
@property (readonly, nonatomic) BOOL isRejectReached;
@property (assign, nonatomic) CGRect lastBounds;
@end

NS_ASSUME_NONNULL_END
