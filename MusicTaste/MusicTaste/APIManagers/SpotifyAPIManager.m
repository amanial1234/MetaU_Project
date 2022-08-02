#import "SpotifyAPIManager.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "MatchmakingViewController.h"
#import "ConnectView.h"
#import "ConnectViewController.h"
#import "dispatch/dispatch.h"
#import "User.h"


@implementation SpotifyAPIManager

#pragma mark - Shared
+ (instancetype)shared {
    static SpotifyAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}


//Spotify API IDs
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
    [self.sessionManager initiateSessionWithScope:requestedScope options:SPTDefaultAuthorizationOption];
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
    //returned message if the session succeeded
    self.token = session.accessToken;
    [self getSpotifyTracksArtists:^(NSDictionary *dict, NSError *error) {
        if (!error){
            //Gets Access Token and save user's Spotify Track Artists data
            [self saveSpotifyUserData:dict];
            [self saveSpotifyData:dict];
            
        }
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
                    [artistDict[@"artists"] addObject:tracksDict[@"artists"]];
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
    //Compiles Get Request for using Spotify API
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
            NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            completion(dataDictionary, nil);
        }
    }];
    [task resume];
}

- (NSDictionary *) convertSpotifyArtists:(NSArray *)artists{
    //Converts Spotify Data into arrays that store the User's Top Genre, Top Artist's Names and Images
    NSMutableArray *genreArray = [[NSMutableArray alloc] init];
    NSMutableArray *artistArray = [[NSMutableArray alloc] init];
    NSMutableArray *artistImages = [NSMutableArray new];
    for (NSDictionary *artist in artists){
        if  (artistImages.count < 10){
            NSArray *artistAndImage = [NSArray arrayWithObjects: artist[@"name"],artist[@"images"][2][@"url"], nil];
            [artistImages addObject:artistAndImage];
        }
        [genreArray addObjectsFromArray:artist[@"genres"]];
        [artistArray addObject:artist[@"id"]];
    }
    //Returns all the data into an Dictionary
    return @{@"genres": genreArray, @"artists": artistArray, @"images": artistImages};
}

- (NSDictionary *) convertSpotifyTracks:(NSArray *)tracks{
    NSMutableArray *trackSet = [[NSMutableArray alloc] init];
    NSMutableArray *artistSet = [[NSMutableArray alloc] init];
    NSMutableArray *albumSet = [[NSMutableArray alloc] init];
    for (NSDictionary *track in tracks){
        NSDictionary *albumItems = track[@"album"];
        // adds album and artist of album to array
        [albumSet addObject:albumItems[@"id"]];
        for (NSDictionary *artist in albumItems[@"artists"]){
            [artistSet addObject:artist[@"id"]];
        }
        // adds artists on song to array
        NSArray *trackArtists = track[@"artists"];
        if (trackArtists.count>1){
            for (NSDictionary *artist in trackArtists){
                [artistSet addObject:artist[@"id"]];
            }
        }
        // adds track id to array
        [trackSet addObject:track[@"id"]];
    }
    //Returns all the data into a dictionary
    return @{@"albums": albumSet, @"artists": artistSet, @"tracks":trackSet};
}
-(void) saveSpotifyData:(NSDictionary *) spotifyData{
    //Saves all Spotify Data such as there top genres,tracks,artist,album,and the artist images to the Parse Database
    PFObject *music = [PFObject objectWithClassName:@"Music"];
    PFUser *current = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Music"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        [User user].artists = [NSArray arrayWithArray:spotifyData[@"images"]];
        if (![[[results valueForKey:@"author"] valueForKey:@"objectId"] containsObject: current.objectId]){
            music[@"author"] = current;
            music[@"genres"] = [NSArray arrayWithArray:spotifyData[@"genres"]];
            music[@"tracks"] = [NSArray arrayWithArray:spotifyData[@"tracks"]];
            music[@"artists"] = [NSArray arrayWithArray:spotifyData[@"artists"]];
            music[@"albums"] = [NSArray arrayWithArray:spotifyData[@"albums"]];
            music[@"images"] = [NSArray arrayWithArray:spotifyData[@"images"]];
            [self getSpotifyData:@"https://api.spotify.com/v1/me" completion:^(NSDictionary * userDict, NSError * error) {
                if (!error){
                    PFUser *current = [PFUser currentUser];
                    NSString *name = userDict[@"display_name"];
                    NSArray *images = userDict[@"images"];
                    NSDictionary *imageDict = [images objectAtIndex:0];
                    if (imageDict != nil){
                        NSString * url =[NSString stringWithFormat:imageDict[@"url"], nil];
                        music[@"username"] = [NSString stringWithFormat: name, nil];
                        music[@"userimage"] = url;
                        [music saveEventually];
                    }
                }
            }];
            [music saveEventually];
        }
        for (PFUser *user in results){
            if ([[[user valueForKey:@"author"] valueForKey:@"objectId"] isEqual:current.objectId] )
                self.author = user;
        }
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"TestNotification"
         object:self];
    }];
}

-(void) saveSpotifyUserData:(NSDictionary *) spotifyData{
    // Saves name and Profile Picture to User
    [self getSpotifyData:@"https://api.spotify.com/v1/me" completion:^(NSDictionary * userDict, NSError * error) {
        if (!error){
            NSString *name = userDict[@"display_name"];
            NSArray *images = userDict[@"images"];
            NSDictionary *imageDict = [images objectAtIndex:0];
            if (imageDict != nil){
                [User user].name = [NSString stringWithFormat: name, nil];
                NSString * url =[NSString stringWithFormat:imageDict[@"url"], nil];
                [User user].profilePicture = url;
            }
        }
    }];
}

@end
