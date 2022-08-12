#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sendMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendNameLabel;
@end

NS_ASSUME_NONNULL_END
