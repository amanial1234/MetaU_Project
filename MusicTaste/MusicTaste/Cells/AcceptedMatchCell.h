#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AcceptedMatchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *matchImage;
@property (weak, nonatomic) IBOutlet UILabel *matchName;

@end

NS_ASSUME_NONNULL_END
