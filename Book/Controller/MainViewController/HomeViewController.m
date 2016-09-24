//
//  HomeViewController.m
//  Book
//
//  Created by Dreamylife on 16/4/17.
//  Copyright © 2016年 software. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "CheckBookViewController.h"
#import "UserInfoModel.h"
#import "UIColor+AppConfig.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size
#define ROW_HIGHT SCREEN_BOUNDS.height / 11

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *HomeViewtableView;
@end
NSMutableArray *CheckBookArray;
NSMutableArray *imageArray;
AppDelegate *homeViewDelegate;

@implementation HomeViewController

- (id)init{
    if (self = [super init]) {
        CheckBookArray = [[NSMutableArray alloc]initWithObjects:@"待审核",@"审核中",@"已通过",@"未通过", nil];
        imageArray = [[NSMutableArray alloc]initWithObjects:@"CheckBook.png",@"review.png",@"bookpass.png",@"bookunpass.png",nil];
        homeViewDelegate = [[UIApplication sharedApplication]delegate];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // 导航栏添加logo
    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *logoImage = [UIImage imageNamed:@"logo_white.png"];
    [logoView setImage:logoImage];
    self.navigationItem.titleView = logoView;
    homeViewDelegate.loginVC.showHomeViewBlock = ^(){
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
    // 进行登录验证
    [self verificationLogin];
    if ([[UserInfoModel sharedInstance]getUserName].length && [[UserInfoModel sharedInstance]getUserPassword].length && [[UserInfoModel sharedInstance]getUserCompetence].length) {
        _HomeViewtableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _HomeViewtableView.delegate = self;
        _HomeViewtableView.dataSource = self;
        [self.view addSubview:_HomeViewtableView];
    }
    
}

#pragma mark 验证登陆
- (void)verificationLogin {
    NSString *userName = [[UserInfoModel sharedInstance]getUserName];
    NSString *userPassword = [[UserInfoModel sharedInstance]getUserPassword];
    if (userName == nil || userPassword == nil) {
        [self presentViewController:homeViewDelegate.loginVC animated:YES completion:nil];
    }else {
        // 如果用户信息核对错误，则弹出登陆界面
        [[UserInfoModel sharedInstance]getUserLoginStateWithName:userName andPassword:userPassword];
        [UserInfoModel sharedInstance].showLoginView = ^(){
            [self presentViewController:homeViewDelegate.loginVC animated:YES completion:nil];
        };
    }  
}

#pragma mark 设置每组标题名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    int competence = [[[UserInfoModel sharedInstance]getUserCompetence]intValue];
    if (competence == 2) {
        if (section == 0) {
            return @"初审";
        }else if (section == 1) {
            return @"复审";
        }
    }else if (competence == 1) {
        return @"初审";
    }
    return nil;
}
#pragma mark 设置分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int competence = [[[UserInfoModel sharedInstance]getUserCompetence]intValue];
    if (competence == 2) {
        return 2;
    }else {
        return 1;
    }
}
#pragma mark 设置分组标题内容高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat headerHight = SCREEN_BOUNDS.height/20;
    if (section == 0) {
        return headerHight;
    }
    return 0;
}

#pragma mark 设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [CheckBookArray count];
}
#pragma mark 设置单元格样式和内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *HomeViewcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    UIImageView *homeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageArray[indexPath.row]]];
    homeImageView.frame = CGRectMake(15, 10, ROW_HIGHT - 20, ROW_HIGHT - 20);
    homeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [HomeViewcell.contentView addSubview:homeImageView];
    
    UIImageView *rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_black.png"]];
    rightImageView.frame = CGRectMake(SCREEN_BOUNDS.width / 10 * 9, ROW_HIGHT/2 - (ROW_HIGHT - 30)/2, ROW_HIGHT - 30, ROW_HIGHT - 30);
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [HomeViewcell.contentView addSubview:rightImageView];
    // 图书名字
    UILabel *homeName = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width / 4, ROW_HIGHT / 2 - 8.5, SCREEN_BOUNDS.width - 90, 20)];
    homeName.text = CheckBookArray[indexPath.row];
    homeName.font = [UIFont systemFontOfSize:17];
    homeName.textColor = [UIColor blackColor];
    [HomeViewcell.contentView addSubview:homeName];

    return HomeViewcell;
}
#pragma mark 添加行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int competence = [[[UserInfoModel sharedInstance]getUserCompetence]intValue];
    switch (competence) {
        case 1:
            if (indexPath.row == 0) {
                CheckBookViewController *CheckBookVC = [[CheckBookViewController alloc]init:firstUncheckedBook :nil :nil];
                [self.navigationController pushViewController:CheckBookVC animated:YES];
            }else if (indexPath.row == 1) {
                CheckBookViewController *CheckBookVC = [[CheckBookViewController alloc]init:firstCheckingBook :nil :nil];
                [self.navigationController pushViewController:CheckBookVC animated:YES];
            }else if (indexPath.row == 2) {
                CheckBookViewController *CheckBookVC = [[CheckBookViewController alloc]init:firstCheckedPassBook :nil :nil];
                [self.navigationController pushViewController:CheckBookVC animated:YES];
            }else if (indexPath.row == 3) {
                CheckBookViewController *CheckBookVC = [[CheckBookViewController alloc]init:firstCheckedUnpassBook :nil :nil];
                [self.navigationController pushViewController:CheckBookVC animated:YES];
            }

            break;
        case 2:
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    CheckBookViewController *CheckBookVC = [[CheckBookViewController alloc]init:firstUncheckedBook :nil :nil];
                    [self.navigationController pushViewController:CheckBookVC animated:YES];
                }else if (indexPath.row == 1) {
                    CheckBookViewController *CheckBookVC = [[CheckBookViewController alloc]init:firstCheckingBook :nil :nil];
                    [self.navigationController pushViewController:CheckBookVC animated:YES];
                }else if (indexPath.row == 2) {
                    CheckBookViewController *CheckBookVC = [[CheckBookViewController alloc]init:firstCheckedPassBook :nil :nil];
                    [self.navigationController pushViewController:CheckBookVC animated:YES];
                }else if (indexPath.row == 3) {
                    CheckBookViewController *CheckBookVC = [[CheckBookViewController alloc]init:firstCheckedUnpassBook :nil :nil];
                    [self.navigationController pushViewController:CheckBookVC animated:YES];
                }
            }else if (indexPath.section == 1) {
                if (indexPath.row == 0) {
                    CheckBookViewController *CheckBookVC = [[CheckBookViewController alloc]init:reviewUncheckedBook :nil :nil];
                    [self.navigationController pushViewController:CheckBookVC animated:YES];
                }else if (indexPath.row == 1) {
                    CheckBookViewController *CheckBookVC = [[CheckBookViewController alloc]init:reviewCheckingBook :nil :nil];
                    [self.navigationController pushViewController:CheckBookVC animated:YES];
                }else if (indexPath.row == 2) {
                    CheckBookViewController *CheckBookVC = [[CheckBookViewController alloc]init:reviewCheckedPassBook :nil :nil];
                    [self.navigationController pushViewController:CheckBookVC animated:YES];
                }else if (indexPath.row == 3) {
                    CheckBookViewController *CheckBookVC = [[CheckBookViewController alloc]init:reviewCheckedUnpassBook :nil :nil];
                    [self.navigationController pushViewController:CheckBookVC animated:YES];
                }
            }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];                                                                                  // 取消选中的状态
}
#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HIGHT;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
