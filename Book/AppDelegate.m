//
//  AppDelegate.m
//  Book
//
//  Created by Dreamylife on 16/3/18.
//  Copyright © 2016年 software. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 初始化TabBarViewController以及四个视图控制器
    _tabVC = [[TabBarViewController alloc]init];
    _firstVC = [[FirstViewController alloc]init];
    _secondVC = [[SecondViewController alloc]init];
    _thirdVC = [[ThirdViewController alloc]init];
    _fourthVC = [[FourthViewController alloc]init];
    _loginVC = [[LoginViewController alloc]init];
    
    // 初始化用户信息类
    _userInfo = [[UserInfo alloc]init];
    
    //为四个视图控制器添加导航栏控制器
    UINavigationController *firstTab = [[UINavigationController alloc]initWithRootViewController:_firstVC];
    UINavigationController *secondTab = [[UINavigationController alloc]initWithRootViewController:_secondVC];
    UINavigationController *thirdTab = [[UINavigationController alloc]initWithRootViewController:_thirdVC];
    UINavigationController *fourthTab = [[UINavigationController alloc]initWithRootViewController:_fourthVC];
    
    // 创建一个包含四个导航栏的数组
    NSArray *controllers = [NSArray arrayWithObjects:firstTab,secondTab,thirdTab,fourthTab,nil];
    
    // 将数组传递给TabBarViewController
    _tabVC.viewControllers = controllers;
    
    // 设置每个视图控制器的标题和图片
    firstTab.title = @"待审核";
    secondTab.title = @"审核中";
    thirdTab.title = @"已审核";
    fourthTab.title = @"我";
    
    firstTab.tabBarItem.image = [UIImage imageNamed:@"first"];
    secondTab.tabBarItem.image = [UIImage imageNamed:@"first"];
    thirdTab.tabBarItem.image = [UIImage imageNamed:@"first"];
    fourthTab.tabBarItem.image = [UIImage imageNamed:@"first"];

    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = _tabVC;
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
#pragma mark 禁止屏幕旋转
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

@end
