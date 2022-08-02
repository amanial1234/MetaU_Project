#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface MatchingAlgorithm : NSObject 
@property (assign, nonatomic) double spotifyMatch;
@property (nonatomic, strong) PFUser *author;
+ (instancetype)shared;
- (void) lookForMatches;
- (void) compareSpotifyData:(PFObject *)potentialMatch withData:(NSManagedObject *)userSpotify;

@end

NS_ASSUME_NONNULL_END
