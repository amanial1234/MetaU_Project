//
//  SpotifyAPIManager.m
//  MusicTaste
//
//  Created by Aman Abraham on 7/6/22.
//

#import "SpotifyAPIManager.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "MatchmakingViewController.h"
#import <CoreData/CoreData.h>
#import "ConnectView.h"
#import "LoginViewController.h"

@implementation SpotifyAPIManager


+ (instancetype)shared {
    static SpotifyAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

static NSString * const SpotifyClientID = @"9f9a8a428178497e8c58840c65d9f3c0";
static NSString * const SpotifySecretID = @"085725985e87480fab42de4970086a54";
static NSString * const SpotifyRedirectURLString = @"spotify-ios-quick-start://spotify-login-callback";


#pragma mark - Actions

- (void) setUpSpotifyWithCompletion:(void (^)(NSDictionary *, NSError*))completion{
    NSString *spotifyClientID = SpotifyClientID;
    NSURL *spotifyRedirectURL = [NSURL URLWithString:SpotifyRedirectURLString];

    self.configuration  = [[SPTConfiguration alloc] initWithClientID:spotifyClientID redirectURL:spotifyRedirectURL];
    
    self.configuration.playURI = @"";

    self.sessionManager = [[SPTSessionManager alloc] initWithConfiguration:self.configuration delegate:self];
    
    SPTScope requestedScope = SPTUserLibraryReadScope | SPTPlaylistReadPrivateScope |  SPTUserTopReadScope;
     
    if (@available(iOS 11, *)) {
        [self.sessionManager initiateSessionWithScope:requestedScope options:SPTDefaultAuthorizationOption];
    } else {
        [self.sessionManager initiateSessionWithScope:requestedScope options:SPTDefaultAuthorizationOption presentingViewController:self];
    }
    completion(nil, nil);
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    [self.sessionManager application:app openURL:url options:options];
    return true;
}



#pragma mark - SPTSessionManagerDelegate

- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session
{
    self.token = session.accessToken;
    [self getSpotifyTracksArtists:^(NSDictionary *dict, NSError *error) {
    }];
}

- (void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error
{}

- (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session
{}





#pragma mark - Getting Spotify Data

-(void) getSpotifyTracksArtists:(void (^)(NSDictionary *, NSError*))completion{
    // get artists
    [self getSpotifyData:@"https://api.spotify.com/v1/me/top/artists" completion:^(NSDictionary * artistDict, NSError * error) {
        if (!error){
            NSArray *artistArray = artistDict[@"items"];
            // get dictionary of genres and artists based on top artists
            NSDictionary *artistDict = [self convertSpotifyArtists:artistArray];
            // get tracks data
            [self getSpotifyData:@"https://api.spotify.com/v1/me/top/tracks" completion:^(NSDictionary * tracksDict, NSError * error) {
                if (!error){
                    NSArray *tracksArray = tracksDict[@"items"];
                    // get dictionary of genres, tracks, and artists based on top tracks
                    NSDictionary *tracksDict =[self convertSpotifyTracks:tracksArray];
                    [artistDict[@"artists"] unionSet:tracksDict[@"artists"]];
                    completion(@{@"artists": artistDict[@"artists"], @"tracks":tracksDict[@"tracks"], @"albums": tracksDict[@"albums"], @"genres": artistDict[@"genres"], @"images": artistDict[@"images"]}, nil);
                }
            }];
        }
    }];
}


-(void) getSpotifyData:(NSString *)urlString completion:(void (^)(NSDictionary *, NSError*))completion{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    [request setHTTPMethod:@"GET"];
    [request addValue:[@"Bearer " stringByAppendingString:self.token] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               completion(nil, error);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               completion(dataDictionary, nil);
           }
       }];
    [task resume];
}


- (NSDictionary *) convertSpotifyArtists:(NSArray *)artists{
    NSMutableSet *genreSet = [[NSMutableSet alloc] init];
    NSMutableSet *artistSet = [[NSMutableSet alloc] init];
    NSMutableArray *artistImages = [NSMutableArray new];
    for (NSDictionary *artist in artists){
        if  (artistImages.count < 10){
            NSArray *artistAndImage = [NSArray arrayWithObjects: artist[@"name"],artist[@"images"][2][@"url"], nil];
            [artistImages addObject:artistAndImage];
        }
        [genreSet addObjectsFromArray:artist[@"genres"]];
        [artistSet addObject:artist[@"id"]];
    }
    return @{@"genres": genreSet, @"artists": artistSet, @"images": artistImages};
}

- (NSDictionary *) convertSpotifyTracks:(NSArray *)tracks{
    NSMutableSet *trackSet = [[NSMutableSet alloc] init];
    NSMutableSet *artistSet = [[NSMutableSet alloc] init];
    NSMutableSet *albumSet = [[NSMutableSet alloc] init];
    for (NSDictionary *track in tracks){
        NSDictionary *albumItems = track[@"album"];
        // adds album and artist of album to set
        [albumSet addObject:albumItems[@"id"]];
        for (NSDictionary *artist in albumItems[@"artists"]){
            [artistSet addObject:artist[@"id"]];
        }
        // adds artists on song to set
        NSArray *trackArtists = track[@"artists"];
        if (trackArtists.count>1){
            for (NSDictionary *artist in trackArtists){
                [artistSet addObject:artist[@"id"]];
            }
        }
        // adds track id to set
        [trackSet addObject:track[@"id"]];
    }
    return @{@"albums": albumSet, @"artists": artistSet, @"tracks":trackSet};
}

-(void) saveData:(NSDictionary *) spotifyData{
    
}


@end
