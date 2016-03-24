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
#import "ListTableViewCell.h"
#import "BookDetialViewController.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@end

BookDetialViewController *bookDetialVC;
ListTableViewCell *cell;
AppDelegate *appdelegate;

@implementation FirstViewController

- (id)init {
    if (self = [super init]) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        self.navigationItem.title = @"待审核";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];                 // 初始化tableview填充整个屏幕
    _tableView.dataSource = self;                                                                                   // 设置tableview的数据代理
    _tableView.delegate = self;                                                                                     // 设置tableview代理
    [self.view addSubview:_tableView];                                                                              // 将tableview添加到屏幕上
    appdelegate = [[UIApplication sharedApplication]delegate];
    
    bookDetialVC = [[BookDetialViewController alloc]init];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self verificationLogin];                                                                                        // 进行登录验证
}

#pragma mark 验证登陆
- (void)verificationLogin {
    // 从plist文件中读取用户数据
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"userInfo.plist"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    NSString *userName = [userInfo objectForKey:@"userName"];
    NSString *userPassword = [userInfo objectForKey:@"userPassword"];
    // 如果用户信息核对错误，则弹出登陆界面
    if (userName == nil || userPassword == nil) {
        AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
        [self presentViewController:appdelegate.loginVC animated:YES completion:nil];
    }
    if(![userName isEqualToString:@"Martin"] && ![userPassword isEqualToString:@"123456"]) {
        AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
        [self presentViewController:appdelegate.loginVC animated:YES completion:nil];
    }
    
}
#pragma mark 设置每组标题名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"书籍信息";
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
    return [appdelegate.bookArray count];
}
#pragma mark 设置单元格样式和内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"UIListTableViewCell"];                                                        // 从缓存池中取出cell
    if (!cell) {                                                                                                                        // 判断是否能取出cell
        cell = [[ListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UIListTableViewCell"];            // 如果cell为空则创建一个新的cell并放入缓存池中
    }else{                                                                                                                              // 如果cell不为空（注意：以下操作很重要，不然会造成cell数据错乱）
        [cell removeCellView];                                                                                                          // 将之前cell界面上的view全部remove掉
        [cell initCellView];                                                                                                            // 重新初始化cell上的view
    }
    Book *books = appdelegate.bookArray[indexPath.row];
    [cell setBookInfo:books];
    return cell;
}
#pragma mark 添加行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:bookDetialVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];                                                                          // 取消选中的状态
}
#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
