//
//  AppDelegate.m
//  Book
//
//  Created by Dreamylife on 16/3/18.
//  Copyright © 2016年 software. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TabBarViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"

@interface AppDelegate ()

@end
LoginViewController *loginVC;
TabBarViewController *tabVC;
FirstViewController *firstVC;
SecondViewController *secondVC;
ThirdViewController *thirdVC;
FourthViewController *fourthVC;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    tabVC = [[TabBarViewController alloc]init];
    firstVC = [[FirstViewController alloc]init];
    secondVC = [[SecondViewController alloc]init];
    thirdVC = [[ThirdViewController alloc]init];
    fourthVC = [[FourthViewController alloc]init];
    
    UINavigationController *firstTab = [[UINavigationController alloc]initWithRootViewController:firstVC];
    UINavigationController *secondTab = [[UINavigationController alloc]initWithRootViewController:secondVC];
    UINavigationController *thirdTab = [[UINavigationController alloc]initWithRootViewController:thirdVC];
    UINavigationController *fourthTab = [[UINavigationController alloc]initWithRootViewController:fourthVC];
    
    NSArray *controllers = [NSArray arrayWithObjects:firstTab,secondTab,thirdTab,fourthTab,nil];
    
    tabVC.viewControllers = controllers;
    
    firstTab.title = @"页面一";
    secondTab.title = @"页面二";
    thirdTab.title = @"页面三";
    fourthTab.title = @"页面四";
    
    firstTab.tabBarItem.image = [UIImage imageNamed:@"first"];
    secondTab.tabBarItem.image = [UIImage imageNamed:@"first"];
    thirdTab.tabBarItem.image = [UIImage imageNamed:@"first"];
    fourthTab.tabBarItem.image = [UIImage imageNamed:@"first"];

    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
   // loginVC = [[LoginViewController alloc]init];
    self.window.rootViewController = tabVC;
    [self.window makeKeyAndVisible];
    
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
