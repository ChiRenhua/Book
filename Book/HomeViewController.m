//
//  HomeViewController.m
//  Book
//
//  Created by Dreamylife on 16/4/17.
//  Copyright © 2016年 software. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "PendingViewController.h"
#import "ReviewViewController.h"
#import "AuditedViewController.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *HomeViewtableView;
@end
NSMutableArray *pendingArray;
NSMutableArray *imageArray;
AppDelegate *homeViewDelegate;

@implementation HomeViewController

- (id)init{
    if (self = [super init]) {
        pendingArray = [[NSMutableArray alloc]initWithObjects:@"待审核",@"审核中",@"已审核", nil];
        imageArray = [[NSMutableArray alloc]initWithObjects:@"touxiang.png",@"touxiang.png",@"touxiang.png", nil];
        homeViewDelegate = [[UIApplication sharedApplication]delegate];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"主页";
    homeViewDelegate.loginVC.showHomeViewBlock = ^(){
        // 进行登录验证
        [self verificationLogin];
        // 判断仅当tableview为空时，才会重新创建tableview
        if (_HomeViewtableView == nil) {
            _HomeViewtableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
            _HomeViewtableView.delegate = self;
            _HomeViewtableView.dataSource = self;
            [self.view addSubview:_HomeViewtableView];
        }else {
            // 重新加载数据
            [_HomeViewtableView reloadData];
        }
    };
    if ([homeViewDelegate.userInfo getUserName].length && [homeViewDelegate.userInfo getUserPassword].length && [homeViewDelegate.userInfo getUserPermission].length) {
        _HomeViewtableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _HomeViewtableView.delegate = self;
        _HomeViewtableView.dataSource = self;
        [self.view addSubview:_HomeViewtableView];
    }
    
}

#pragma mark 验证登陆
- (void)verificationLogin {
    NSString *userName = homeViewDelegate.userInfo.getUserName;
    NSString *userPassword = homeViewDelegate.userInfo.getUserPassword;
    // 如果用户信息核对错误，则弹出登陆界面
    if(![userName isEqualToString:@"Martin"] && ![userPassword isEqualToString:@"123456"]) {
        [self presentViewController:homeViewDelegate.loginVC animated:YES completion:nil];
    }
    
}

#pragma mark 设置每组标题名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([[homeViewDelegate.userInfo getUserPermission] isEqualToString:@"0"]) {
        if (section == 0) {
            return @"初审";
        }else if (section == 1) {
            return @"复审";
        }
    }else if ([[homeViewDelegate.userInfo getUserPermission] isEqualToString:@"1"]) {
        return @"初审";
    }else if ([[homeViewDelegate.userInfo getUserPermission] isEqualToString:@"2"]) {
        return @"复审";
    }
    return nil;
}
#pragma mark 设置分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([[homeViewDelegate.userInfo getUserPermission] isEqualToString:@"0"]) {
        return 2;
    }else {
        return 1;
    }
}
#pragma mark 设置分组标题内容高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 30;
    }else if (section == 1) {
        return 15;
    }
    return 0;
}

#pragma mark 设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [pendingArray count];
}
#pragma mark 设置单元格样式和内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *HomeViewcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    HomeViewcell.textLabel.text = pendingArray[indexPath.row];
    HomeViewcell.imageView.contentMode = UIViewContentModeScaleAspectFit;                                                                       // 设置图片属性为合适填充
    [HomeViewcell.imageView setImage:[UIImage imageNamed:imageArray[indexPath.row]]];
    return HomeViewcell;
}
#pragma mark 添加行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            PendingViewController *pendingVC = [[PendingViewController alloc]init:YES];
            [self.navigationController pushViewController:pendingVC animated:YES];
        }else if (indexPath.row == 1) {
            ReviewViewController *reviewVC = [[ReviewViewController alloc]init:YES];
            [self.navigationController pushViewController:reviewVC animated:YES];
        }else if (indexPath.row == 2) {
            AuditedViewController *auditedVC = [[AuditedViewController alloc]init:YES];
            [self.navigationController pushViewController:auditedVC animated:YES];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            PendingViewController *pendingVC = [[PendingViewController alloc]init:NO];
            [self.navigationController pushViewController:pendingVC animated:YES];
        }else if (indexPath.row == 1) {
            ReviewViewController *reviewVC = [[ReviewViewController alloc]init:NO];
            [self.navigationController pushViewController:reviewVC animated:YES];
        }else if (indexPath.row == 2) {
            AuditedViewController *auditedVC = [[AuditedViewController alloc]init:NO];
            [self.navigationController pushViewController:auditedVC animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];                                                                                  // 取消选中的状态
}
#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end