#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface MatchingAlgorithm : NSObject

@property (strong, nonatomic) NSArray *foundPosts;
+ (instancetype)shared;
+ (void) lookForMatches;
+ (void) compare:(PFObject *)potentialMatch withDictionary:(NSMutableDictionary *)matches withData:(NSManagedObject *)data;
+ (double) compareSpotifyData:(PFObject *)potentialMatch withData:(NSManagedObject *)userSpotify;

@end

NS_ASSUME_NONNULL_END
