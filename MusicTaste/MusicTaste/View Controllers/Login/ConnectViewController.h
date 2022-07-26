#import <UIKit/UIKit.h>
#import <SpotifyiOS/SpotifyiOS.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConnectViewController : UIViewController<SPTSessionManagerDelegate>
@property (nonatomic, strong) SPTSessionManager *sessionManager;
@end

NS_ASSUME_NONNULL_END
