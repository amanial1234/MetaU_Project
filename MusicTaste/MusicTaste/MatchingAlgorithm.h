#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface MatchingAlgorithm : NSObject 
@property (assign, nonatomic) double spotifyMatch;
+ (instancetype)shared;
- (void) lookForMatches;
<<<<<<< Updated upstream
- (void) compareSpotifyData:(PFObject *)potentialMatch withData:(NSManagedObject *)userSpotify;
=======
>>>>>>> Stashed changes

@end

NS_ASSUME_NONNULL_END
