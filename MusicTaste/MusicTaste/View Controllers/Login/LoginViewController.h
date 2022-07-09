//
//  LoginViewController.h
//  MusicTaste
//
//  Created by Aman Abraham on 7/6/22.
//

#import <UIKit/UIKit.h>
#import <SpotifyiOS/SpotifyiOS.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController<SPTSessionManagerDelegate>


@property (nonatomic) SPTSessionManager *sessionManager;

@end

NS_ASSUME_NONNULL_END
