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
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "BookDetialViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController *loginVC;
@property (strong, nonatomic) TabBarViewController *tabVC;
@property (strong, nonatomic) FirstViewController *firstVC;
@property (strong, nonatomic) SecondViewController *secondVC;
@property (strong, nonatomic) ThirdViewController *thirdVC;
@property (strong, nonatomic) FourthViewController *fourthVC;

@end

