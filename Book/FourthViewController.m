//
//  FourthViewController.m
//  Book
//
//  Created by Dreamylife on 16/3/18.
//  Copyright © 2016年 software. All rights reserved.
//

#import "FourthViewController.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size

@interface FourthViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

UITableView *fourthVCTableView;

@implementation FourthViewController

- (id)init {
    if (self = [super init]) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        self.navigationItem.title = @"我";
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加右侧注销按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注销" style:UIBarButtonItemStyleDone target:self action:@selector(logout)];
    fourthVCTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    fourthVCTableView.delegate = self;
    fourthVCTableView.dataSource = self;
    [self.view addSubview:fourthVCTableView];
}

#pragma mark 设置分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
#pragma mark 设置分组标题内容高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

#pragma mark 设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
#pragma mark 设置单元格样式和内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *fourthViewCell;
    fourthViewCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    // 获取用户名
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"userInfo.plist"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    NSString *userName = [userInfo objectForKey:@"userName"];
    
    // 添加用户头像
    UIImageView *userImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];                                                                     // 设置头像图片大小
    userImage.contentMode = UIViewContentModeScaleAspectFit;                                                                                                    // 设置图片属性为合适填充
    [userImage setImage:[UIImage imageNamed:@"touxiang.png"]];
    [fourthViewCell.contentView addSubview:userImage];
    // 添加用户名
    _nameLable = [[UILabel alloc]initWithFrame:CGRectMake(110, 20, SCREEN_BOUNDS.width - 110, 20)];
    _nameLable.text = [[NSString alloc]initWithFormat:@"用户：%@",userName];
    _nameLable.font = [UIFont systemFontOfSize:20];
    [fourthViewCell.contentView addSubview:_nameLable];
    // 添加职位信息
    UILabel * professionLable = [[UILabel alloc]initWithFrame:CGRectMake(110, 60, SCREEN_BOUNDS.width - 110, 20)];
    professionLable.text = @"图书审核员";
    professionLable.font = [UIFont systemFontOfSize:15];
    professionLable.textColor = [UIColor grayColor];
    [fourthViewCell.contentView addSubview:professionLable];
    return fourthViewCell;
}
#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
#pragma mark 设置每组标题名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}
#pragma mark 添加行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self logout];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];                                                                                  // 取消选中的状态
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