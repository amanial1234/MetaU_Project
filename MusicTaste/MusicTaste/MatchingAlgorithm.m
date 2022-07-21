#import "MatchingAlgorithm.h"
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "dispatch/dispatch.h"

@implementation MatchingAlgorithm

+ (instancetype)shared {
    //Shared Instance of the Matching Algorithm
    static MatchingAlgorithm *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

+ (void) lookForMatches{
    NSMutableDictionary *matchDict = [NSMutableDictionary new];
    PFObject *music = [PFObject objectWithClassName:@"Music"];
    PFQuery *query = [PFQuery queryWithClassName:@"Music"];
    PFUser *current = [PFUser currentUser];
    //Goes through Query
    [query findObjectsInBackgroundWithBlock:^(NSArray *spotifyData, NSError *error) {
        for (PFObject *user in spotifyData){
            //We make sure we are not comparing the same object
            if (![user.objectId isEqual:music.objectId]){
                //Calls the compare function to compare each user
                [MatchingAlgorithm compare:user withDictionary:matchDict withData:user];
            }
        }
    }];
    //sets the matches as an integer in the user's database
    NSArray *matches = [[[matchDict keysSortedByValueUsingSelector:@selector(compare:)] reverseObjectEnumerator] allObjects];
    music[@"matches"] = [NSArray arrayWithArray:matches];
    [current saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {}];
}

+ (double) compareSpotifyData:(PFObject *)potentialMatch withData:(NSManagedObject *)userSpotify{
    double spotifyMatch = 0.0;
    PFQuery *query = [PFQuery queryWithClassName:@"Music"];
    PFUser *current = [PFUser currentUser];
    [query whereKey:@"userId" equalTo:current.objectId];
    //Makes sure the we are collecting information from the current user
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
            double spotifyMatch = 0.0;
            NSManagedObject *matchData = results[0];
            if (potentialMatch != NULL){
                //Calls the genres,tracks, albums, and artists from the database
                NSMutableArray *matchDataGenres = [matchData valueForKey:@"genres"];
                NSMutableArray *matchDataTracks = [matchData valueForKey:@"tracks"];
                NSMutableArray *matchDataAlbums = [matchData valueForKey:@"albums"];
                NSMutableArray *matchDataArtists = [matchData valueForKey:@"artists"];
                //Generates counts of all the arrays
                NSInteger genreCount = [matchDataGenres count];
                NSInteger albumCount = [matchDataAlbums count];
                NSInteger trackCount = [matchDataTracks count];
                NSInteger artistCount = [matchDataArtists count];
                //removes repeating objects in arrays compared to the potential match
                [matchDataGenres removeObjectsInArray:[potentialMatch valueForKey:@"genres"]];
                [matchDataTracks removeObjectsInArray:[potentialMatch valueForKey:@"tracks"]];
                [matchDataAlbums removeObjectsInArray:[potentialMatch valueForKey:@"albums"]];
                [matchDataArtists removeObjectsInArray:[potentialMatch valueForKey:@"artists"]];
                //gets the new count of the array
                double newGenreCount = [matchDataGenres count];
                double newAlbumCount = [matchDataAlbums count];
                double newTrackCount = [matchDataTracks count];
                double newArtistCount = [matchDataArtists count];
                //generates a integer to determine how similar the two user's music taste is - 0 for similar and 1 for not similar at all
                spotifyMatch = (((newGenreCount/genreCount)*0.2) + ((newTrackCount/trackCount)*0.3) + ((newAlbumCount/albumCount)*0.2) + ((newArtistCount/artistCount)*0.3));
            }
        }];
    });
    return spotifyMatch;
}

+ (void) compare:(PFObject *)potentialMatch withDictionary:(NSMutableDictionary *)matches withData:(NSManagedObject *)data {
    PFQuery *query = [PFQuery queryWithClassName:@"Music"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        //Creates a double that will be used to measure the similarity between users
        double spotifyComp = 0.0;
        if (results != NULL){
            //Calls upon compareSpotifyData to compare the user to another user
            spotifyComp = [self compareSpotifyData:potentialMatch withData:results];
        }
        [matches setObject:[NSNumber numberWithDouble:spotifyComp] forKey:potentialMatch.objectId];
    }];
}


@end
