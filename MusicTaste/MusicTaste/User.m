#import "User.h"

@implementation User
//Generate name and profile pticture
@synthesize name,profilePicture;

+ (User *) user {
    static User *user = nil;
    if (!user) {
        //initliaze User
        user = [[super allocWithZone:nil] init];
    }
    return user;
}

+ (id) allocWithZone:(struct _NSZone *)zone {
    return [self user];
}
- (id) init {
    self = [super init];
    if (self) {
        //initializes name and profile picture
        name = nil;
        profilePicture = nil;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties such as name and the profile picture
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.profilePicture forKey:@"image"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode name and image
        self.name = [decoder decodeObjectForKey:@"name"];
        self.profilePicture = [decoder decodeObjectForKey:@"image"];
    }
    return self;
}

@end
