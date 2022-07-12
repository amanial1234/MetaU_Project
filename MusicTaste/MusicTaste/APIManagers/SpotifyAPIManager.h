#import <Foundation/Foundation.h>
#import <SpotifyiOS/SpotifyiOS.h>

NS_ASSUME_NONNULL_BEGIN
NS_ASSUME_NONNULL_END

@interface SpotifyAPIManager : NSObject <SPTSessionManagerDelegate>

+ (instancetype)shared;

@property (nonatomic, strong) SPTSessionManager *sessionManager;
@property (nonatomic, strong) SPTConfiguration *configuration;
@property (nonatomic, strong) NSString *token;
@property (weak) IBOutlet UIWindow *window;


- (void) setUpSpotifyWithCompletion:(void (^)(NSDictionary *, NSError*))completion;

- (void) getSpotifyTracksArtists:(void (^)(NSDictionary *, NSError*))completion;


@end
