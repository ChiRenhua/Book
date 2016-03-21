//
//  FourthViewController.m
//  Book
//
//  Created by Dreamylife on 16/3/18.
//  Copyright © 2016年 software. All rights reserved.
//

#import "FourthViewController.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size

@interface FourthViewController ()

@end

@implementation FourthViewController

- (id)init {
    if (self = [super init]) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        self.navigationItem.title = @"页面四";
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取用户名
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"userInfo.plist"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    NSString *userName = [userInfo objectForKey:@"userName"];
    
    // 添加用户头像
    UIImageView *userImage = [[UIImageView alloc]init];
    userImage.bounds = CGRectMake(0, 0, 150, 150);                                                  // 设置头像图片大小
    userImage.contentMode = UIViewContentModeScaleAspectFit;                                        // 设置图片属性为合适填充
    userImage.center = CGPointMake(SCREEN_BOUNDS.width/2, SCREEN_BOUNDS.height/5);                  // 设置图片位置
    [userImage setImage:[UIImage imageNamed:@"touxiang.png"]];
    [self.view addSubview:userImage];
    // 添加用户名
    _nameLable = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_BOUNDS.height/5 + 90, SCREEN_BOUNDS.width, 20)];
    _nameLable.text = [[NSString alloc]initWithFormat:@"欢迎用户：%@",userName];
    _nameLable.textAlignment = NSTextAlignmentCenter;
    _nameLable.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:_nameLable];
    
    // 添加右侧注销按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注销" style:UIBarButtonItemStyleDone target:self action:@selector(logout)];
}
#pragma mark 登出
- (void)logout {
    // 添加注销确认提示框
    UIAlertController *logoutAlert = [UIAlertController alertControllerWithTitle:@"警告" message:@"注销会删除当前用户的本地信息" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *lougoutAction = [UIAlertAction actionWithTitle:@"注销" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self presentViewController:loginVC animated:YES completion:nil];
        // 删除已登录用户信息
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [path objectAtIndex:0];
        NSString *plistPath = [filePath stringByAppendingPathComponent:@"userInfo.plist"];
        [fileManager removeItemAtPath:plistPath error:nil];

    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    [logoutAlert addAction:lougoutAction];
    [logoutAlert addAction:cancleAction];
    [self presentViewController:logoutAlert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end