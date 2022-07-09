//
//  SpotifyAPIManager.h
//  MusicTaste
//
//  Created by Aman Abraham on 7/6/22.
//

#import <Foundation/Foundation.h>
#import <SpotifyiOS/SpotifyiOS.h>

NS_ASSUME_NONNULL_BEGIN
NS_ASSUME_NONNULL_END

@interface SpotifyAPIManager : NSObject <SPTSessionManagerDelegate>

+ (instancetype)shared;

@property (nonatomic, strong) SPTSessionManager *sessionmanager;
@property (nonatomic, strong) SPTConfiguration *configuration;
@property (nonatomic, strong) NSString *token;



- (void) setUpSpotifyWithCompletion:(void (^)(NSDictionary *, NSError*))completion;

- (void) getSpotifyTracksArtists:(void (^)(NSDictionary *, NSError*))completion;


@end
