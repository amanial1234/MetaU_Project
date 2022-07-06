//
//  main.m
//  MusicTaste
//
//  Created by Aman Abraham on 7/5/22.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <SpotifyiOS/SpotifyiOS.h>

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
