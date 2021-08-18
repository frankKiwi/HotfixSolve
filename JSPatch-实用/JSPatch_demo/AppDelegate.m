//
//  AppDelegate.m
//  JSPatch_demo
//
//  Created by zhang_rongwu on 15/12/10.
//  Copyright © 2015年 zhang_rongwu. All rights reserved.
//

#import "AppDelegate.h"
#import "JPEngine.h"
#import "ViewController.h"
#import "JPLoader.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    [JPEngine startEngine];
//    NSString *sourcePatch = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"js"];
//    NSString *script = [NSString stringWithContentsOfFile:sourcePatch encoding:NSUTF8StringEncoding error:nil];
//    [JPEngine evaluateScript:script];
    [self loadLocalUnRSA];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ViewController *rootViewController = [[ViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}
/***  执行本地的未加密JS */

- (void)loadLocalUnRSA{
        [JPLoader shareJs]
                               .hotfixIsRsa(NO)
                               .hotfixIsTest(YES)
                               .hotfixIsZipFile(NO)
                               .hotfixIsJSPtach(NO)
                               .hotfixServeUrl(@"");
                               [[JPLoader shareJs] initJSPatchIsJustLocal:YES];
}
/***  执行本地的加密JS */

- (void)loadLocalRSA{
        NSString *homeUrl = @"https://----/ioshotfix/mainv1.js";
        [JPLoader shareJs]
                               .hotfixIsRsa(YES)
                               .hotfixIsTest(YES)
                               .hotfixIsZipFile(NO)
                               .hotfixIsJSPtach(NO)
                               .hotfixServeUrl(homeUrl);
                               [[JPLoader shareJs] initJSPatchIsJustLocal:YES];
}
/***  拉取服务端js文件 */

- (void)loadJsSeverPath{
    NSString *homeUrl = @"https://----/ioshotfix/mainv1.js";
    [JPLoader shareJs]
                   .hotfixIsRsa(YES)
                   .hotfixIsTest(NO)
                   .hotfixIsZipFile(NO)
                   .hotfixIsJSPtach(NO)
                   .hotfixServeUrl(homeUrl);
                   [[JPLoader shareJs] initJSPatchIsJustLocal:NO];

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

@end
