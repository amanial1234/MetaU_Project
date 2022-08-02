#import "User.h"

@implementation User
//Generate name and profile pticture
@synthesize name,profilePicture,artists;

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
        artists = nil;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties such as name and the profile picture
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.profilePicture forKey:@"image"];
    [encoder encodeObject:self.profilePicture forKey:@"artists"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode name and image
        self.name = [decoder decodeObjectForKey:@"name"];
        self.profilePicture = [decoder decodeObjectForKey:@"image"];
        self.profilePicture = [decoder decodeObjectForKey:@"artists"];
    }
    return self;
}

@end
