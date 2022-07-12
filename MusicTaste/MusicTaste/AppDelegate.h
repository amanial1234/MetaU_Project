//
//  AppDelegate.h
//  MusicTaste
//
//  Created by Aman Abraham on 7/5/22.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)saveContext;
@end

