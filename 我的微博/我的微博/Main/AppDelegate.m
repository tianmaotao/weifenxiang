//
//  AppDelegate.m
//  我的微博
//
//  Created by 汇文教育 on 16/1/11.
//  Copyright © 2016年 1203. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "SinaWeibo.h"
#import "LeftViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "ThemeImageView.h"

@interface AppDelegate ()<SinaWeiboDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self themeDidChange];
    [self.window makeKeyAndVisible];
    
    //左滑页面
    LeftViewController *leftViewController = [[LeftViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:leftViewController];
    MainTabBarController *mainController = [[MainTabBarController alloc] init];
    MMDrawerController *drawerController = [[MMDrawerController alloc] initWithCenterViewController:mainController leftDrawerViewController:nav];
//    drawerController.view.backgroundColor = [UIColor clearColor];
    //设置手势操作的区域
    [drawerController setMaximumLeftDrawerWidth:150.0];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [[MMExampleDrawerVisualStateManager sharedManager]
                 drawerVisualStateBlockForDrawerSide:drawerSide];
        if(block){
            block(drawerController, drawerSide, percentVisible);
        }
    }];
    
    self.window.rootViewController = drawerController;
    
    
    self.sinaWeibo = [[SinaWeibo alloc] initWithAppKey:kAppkey appSecret:kSecret appRedirectURI:kAppRedirectURI andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaWeiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaWeiboInfo objectForKey:@"AccessTokenKey"] && [sinaWeiboInfo objectForKey:@"ExpirationDateKey"] && [sinaWeiboInfo objectForKey:@"UserIDKey"]) {
        _sinaWeibo.accessToken = [sinaWeiboInfo objectForKey:@"AccessTokenKey"];
        _sinaWeibo.expirationDate = [sinaWeiboInfo objectForKey:@"ExpirationDateKey"];
        _sinaWeibo.userID = [sinaWeiboInfo objectForKey:@"UserIDKey"];
    }
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)themeDidChange {
    ThemeImageView *bgImg = [[ThemeImageView alloc] initWithFrame:self.window.frame];
    bgImg.imageName = @"mask_bg.jpg";
}

#pragma mark - SinaWeiboDelegate
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken,@"AccessTokenKey",
                              sinaweibo.expirationDate,@"ExpirationDateKey",
                              sinaweibo.userID,@"UserIDKey",
                              sinaweibo.refreshToken,@"refresh_token",nil];
    [[NSUserDefaults standardUserDefaults]setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
