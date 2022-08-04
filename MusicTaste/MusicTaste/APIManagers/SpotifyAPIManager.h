#import <Foundation/Foundation.h>
#import <SpotifyiOS/SpotifyiOS.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN
NS_ASSUME_NONNULL_END

@interface SpotifyAPIManager : NSObject <SPTSessionManagerDelegate>

+ (instancetype)shared;

@property (nonatomic, strong) SPTSessionManager *sessionManager;
@property (nonatomic, strong) SPTConfiguration *configuration;
@property (nonatomic, strong) NSString *token;
@property (weak) IBOutlet UIWindow *window;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *profilePicture;
@property (nonatomic, strong) PFUser *author;

- (void) setUpSpotifyWithCompletion:(void (^)(NSDictionary *, NSError*))completion;

- (void) getSpotifyTracksArtists:(void (^)(NSDictionary *, NSError*))completion;

@end
