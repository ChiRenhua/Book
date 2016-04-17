//
//  AppDelegate.h
//  Book
//
//  Created by Dreamylife on 16/3/18.
//  Copyright © 2016年 software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "TabBarViewController.h"
#import "PendingViewController.h"
#import "ReviewViewController.h"
#import "AuditedViewController.h"
#import "UserViewController.h"
#import "BookDetialViewController.h"
#import "UserInfo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController *loginVC;
@property (strong, nonatomic) TabBarViewController *tabVC;
@property (strong, nonatomic) PendingViewController *PendingVC;
@property (strong, nonatomic) ReviewViewController *ReviewVC;
@property (strong, nonatomic) AuditedViewController *AuditedVC;
@property (strong, nonatomic) UserViewController *UserVC;
@property (strong, nonatomic) UserInfo *userInfo;

@end

