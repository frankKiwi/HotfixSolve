//
//  AppDelegate.m
//  FNKRunnerDemo
//
//  Created by Frank on 2020/5/23.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "AppDelegate.h"
#import <objc/message.h>
#import "SignViewController.h"
#import "BinaryPathRequest.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
//    [BinaryPathRequest loadServiceScriptString];
//    [BinaryPathRequest reverseHotFix];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.hidden = NO;
    self.window.backgroundColor = [UIColor whiteColor];

    SignViewController*vc = [SignViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window setRootViewController:nav];
    
    [BinaryPathRequest loadLocalFile];

    
#if __x86_64__  &&  TARGET_OS_SIMULATOR  &&  !TARGET_OS_IOSMAC
    NSLog(@"SIMULATOR");
#endif
    return YES;
}


@end
