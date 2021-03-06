//
//  AppDelegate.m
//  课程设计-3D导航
//
//  Created by Etouch on 15/12/30.
//  Copyright © 2015年 iceB. All rights reserved.
//

//高德appKey:e91a6524b617d0922e85a99a74b1d62a
#import "AppDelegate.h"
#import "YPViewController.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
 
    SBKBeaconID *beaconID = [SBKBeaconID beaconIDWithProximityUUID:SBKSensoroDefaultProximityUUID];
    [[SBKBeaconManager sharedInstance] startRangingBeaconsWithID:beaconID
                                               wakeUpApplication:YES];
    SBKBeaconID *beaconIDWeChat = [SBKBeaconID beaconIDWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"23A01AF0-232A-4518-9C0E-323FB773F5EF"]];
    [[SBKBeaconManager sharedInstance] startRangingBeaconsWithID:beaconIDWeChat
                                               wakeUpApplication:YES];
    
    [[SBKBeaconManager sharedInstance] requestAlwaysAuthorization];
    //测试用防蹭用密钥，期限到2016-01-01
    [[SBKBeaconManager sharedInstance] addBroadcastKey:@"01Y2GLh1yw3+6Aq0RsnOQ8xNvXTnDUTTLE937Yedd/DnlcV0ixCWo7JQ+VEWRSya80yea6u5aWgnW1ACjKNzFnig=="];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor clearColor];
    YPViewController * MainCtrl = [[YPViewController alloc]init];
    MainCtrl.view.backgroundColor = [UIColor grayColor];
    UINavigationController *navCtrl = [[UINavigationController alloc]initWithRootViewController:MainCtrl];
    self.window.rootViewController = navCtrl;
    [self.window makeKeyAndVisible];
    
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

@end
