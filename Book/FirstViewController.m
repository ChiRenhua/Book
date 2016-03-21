//
//  FirstViewController.m
//  Book
//
//  Created by Dreamylife on 16/3/18.
//  Copyright © 2016年 software. All rights reserved.
//

#import "FirstViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationItem.title = @"页面一";
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width/2-100, SCREEN_BOUNDS.height/2-25, 200, 50)];
    [lable setText:@"First Page"];
    lable.font = [UIFont systemFontOfSize:20];
    lable.textAlignment = NSTextAlignmentCenter;
    [lable setTextColor:[UIColor blackColor]];
    [self.view addSubview:lable];
}

- (void)viewWillAppear:(BOOL)animated {
    [self verificationLogin];
}

#pragma mark 验证登陆
- (void)verificationLogin {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"userInfo.plist"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    NSString *userName = [userInfo objectForKey:@"userName"];
    NSString *userPassword = [userInfo objectForKey:@"userPassword"];
    if([userName isEqualToString:@"Martin"] && [userPassword isEqualToString:@"123456"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
        [self presentViewController:appdelegate.loginVC animated:YES completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
