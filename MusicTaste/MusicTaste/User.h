#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject<NSCoding>
//Properties

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *profilePicture;

//Initializer
+ (User *) user;
- (void)encodeWithCoder:(NSCoder *)enCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
@end

NS_ASSUME_NONNULL_END
