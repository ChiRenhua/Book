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
#import "UserViewController.h"
#import "HomeViewController.h"
#import "SearchViewController.h"
#import "BookReviewViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController *loginVC;
@property (strong, nonatomic) TabBarViewController *tabVC;
@property (strong, nonatomic) UserViewController *UserVC;
@property (strong, nonatomic) HomeViewController *homeVC;
@property (strong, nonatomic) SearchViewController *searchVC;
@property (strong, nonatomic) BookReviewViewController *bookReviewVC;

@end

