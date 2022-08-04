#import "AppDelegate.h"
#import "ConnectViewController.h"
#import <Parse/Parse.h>
#import "SpotifyAPIManager.h"

@interface AppDelegate ()

@property(nonatomic, strong) ConnectViewController *rootViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<NSString *, id> *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = [ConnectViewController new];
    self.rootViewController = [ConnectViewController new];
    self.window.rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];
    
    //Parse
    
    if ([SpotifyAPIManager shared] != nil) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        self.window.rootViewController = navigationController;
    }
    
    ParseClientConfiguration *configuration = [ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
          configuration.applicationId = @"iJNJWEK6K95hrPtlEDKWcvhN3QAKBcRAXqvkmAVM";
          configuration.clientKey = @"r60ipSnjnCwPOSFpNm7zzqL38DOAk0wL8oWjJ5jO";
          configuration.server = @"https://parseapi.back4app.com/";
    }];
    [Parse initializeWithConfiguration:configuration];

    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)URL
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    [self.rootViewController.sessionManager application:application openURL:URL options:options];
    NSLog(@"%@ %@", URL, options);
    return YES;
}
#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
}
#pragma mark - Core Data stack



@end
