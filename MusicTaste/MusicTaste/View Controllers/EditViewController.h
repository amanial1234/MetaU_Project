#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN
@protocol EditViewControllerDelegate

@end

@interface EditViewController : UIViewController
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, weak) id<EditViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
