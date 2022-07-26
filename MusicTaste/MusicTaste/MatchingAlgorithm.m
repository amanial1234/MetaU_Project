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

- (void) lookForMatches{
    NSMutableDictionary *matchDict = [NSMutableDictionary new];
    PFObject *music = [PFObject objectWithClassName:@"Music"];
    PFQuery *query = [PFQuery queryWithClassName:@"Music"];
    PFUser *current = [PFUser currentUser];
    //Goes through Query
    [query findObjectsInBackgroundWithBlock:^(NSArray *spotifyData, NSError *error) {
        for (PFObject *user in spotifyData){
            //Calls the compare function to compare each user
            [self compareSpotifyData:user withData:spotifyData];
        }
        //sets the matches as an integer in the user's database
        [current saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {}];
    }];
    
}

- (void) compareSpotifyData:(PFObject *)potentialMatch withData:(NSManagedObject*)userSpotify{
<<<<<<< Updated upstream
    PFQuery *query = [PFQuery queryWithClassName:@"Music"];
    PFUser *current = [PFUser currentUser];
    //Makes sure the we are collecting information from the current user
    self.spotifyMatch = 0.0;
    NSMutableArray *matches = [NSMutableArray array];
            double spotifyMatch = 0.0;
=======
    //Makes sure the we are collecting information from the current user
    self.spotifyMatch = 0.0;
    NSMutableArray *matches = [NSMutableArray array];
>>>>>>> Stashed changes
    for (NSManagedObject *matchData in userSpotify){
        if (potentialMatch != NULL){
            if (![potentialMatch.objectId isEqual:[matchData valueForKey:@"objectId"]]){
                NSMutableDictionary *matchesDict = [NSMutableDictionary dictionary];
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
                //Makes copies of array to avoid deletion of data
                NSMutableArray *matchDataGenresCopy = [[NSMutableArray alloc] initWithArray:matchDataGenres];
                NSMutableArray *matchDataTracksCopy = [[NSMutableArray alloc] initWithArray:matchDataTracks];
                NSMutableArray *matchDataAlbumsCopy = [[NSMutableArray alloc] initWithArray:matchDataAlbums];
                NSMutableArray *matchDataArtistsCopy = [[NSMutableArray alloc] initWithArray:matchDataArtists];
                //removes repeating objects in arrays compared to the potential match
                [matchDataGenresCopy removeObjectsInArray:[potentialMatch valueForKey:@"genres"]];
                [matchDataTracksCopy removeObjectsInArray:[potentialMatch valueForKey:@"tracks"]];
                [matchDataAlbumsCopy removeObjectsInArray:[potentialMatch valueForKey:@"albums"]];
                [matchDataArtistsCopy removeObjectsInArray:[potentialMatch valueForKey:@"artists"]];
                //gets the new count of the array
                double newGenreCount = [matchDataGenresCopy count];
                double newAlbumCount = [matchDataAlbumsCopy count];
                double newTrackCount = [matchDataTracksCopy count];
                double newArtistCount = [matchDataArtistsCopy count];
                //generates a integer to determine how similar the two user's music taste is - 0 for similar and 1 for not similar at all
                if (genreCount == 0 || albumCount == 0 || trackCount == 0 || albumCount == 0){
                    //To avoid dividing by zero if any of the counts are zero we make the Spotify match automatically 1
                    self.spotifyMatch = 1;
                }else{
<<<<<<< Updated upstream
                self.spotifyMatch = (((newGenreCount/genreCount)*0.2) + ((newTrackCount/trackCount)*0.3) + ((newAlbumCount/albumCount)*0.2) + ((newArtistCount/artistCount)*0.3));
                }
                [matchesDict setObject:[NSNumber numberWithDouble:self.spotifyMatch] forKey:[matchData valueForKey:@"objectId"]];
                [matches addObject:matchesDict];
                }
            }
    }
    //Saves matches to Database
=======
                    self.spotifyMatch = (((newGenreCount/genreCount)*0.2) + ((newTrackCount/trackCount)*0.3) + ((newAlbumCount/albumCount)*0.2) + ((newArtistCount/artistCount)*0.3));
                }
                [matchesDict setObject:[NSNumber numberWithDouble:self.spotifyMatch] forKey:[matchData valueForKey:@"objectId"]];
                [matches addObject:matchesDict];
            }
        }
    }
    //Saves matches to Database
    NSLog(@"Match: %@", matches);
>>>>>>> Stashed changes
    potentialMatch[@"matches"] = matches;
    [potentialMatch saveInBackground];
}


@end
