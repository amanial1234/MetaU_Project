#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MatchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *matchImage;
@property (weak, nonatomic) IBOutlet UILabel *matchName;
@property (weak, nonatomic) IBOutlet UILabel *matchBio;
@property (weak, nonatomic) IBOutlet UILabel *matchAge;
@property (weak, nonatomic) IBOutlet UILabel *matchArtists;
@property (weak, nonatomic) IBOutlet UILabel *matchGenres;
@end

NS_ASSUME_NONNULL_END
