#import <UIKit/UIKit.h>
#import <SpotifyiOS/SpotifyiOS.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController<SPTSessionManagerDelegate>


@property (nonatomic) SPTSessionManager *sessionManager;
@property (assign) BOOL myBool;

@end

NS_ASSUME_NONNULL_END
