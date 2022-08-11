#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Message : NSObject

@property (nonatomic, strong) NSString *idStr; // For favoriting, retweeting & replying
@property (nonatomic, strong) NSString *text; // Text content of tweet

@end

NS_ASSUME_NONNULL_END
