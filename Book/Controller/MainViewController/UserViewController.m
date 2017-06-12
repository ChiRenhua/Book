//
//  UserViewController.m
//  Book
//
//  Created by Dreamylife on 16/3/18.
//  Copyright © 2016年 software. All rights reserved.
//

#import "UserViewController.h"
#import "AppDelegate.h"
#import "UserInfoModel.h"
#import "UIColor+AppConfig.h"
#import "Utils.h"
#import "CustomIOSAlertView.h"
#import "CompetenceViewController.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size

@interface UserViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UILabel *nameLable;
@property (nonatomic,retain)UILabel *professionLable;
@end

AppDelegate *UserVCdelegate;

@implementation UserViewController

- (id)init {
    if (self = [super init]) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        self.navigationItem.title = @"我";
        UserVCdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _UserVCTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _UserVCTableView.delegate = self;
    _UserVCTableView.dataSource = self;
    [self.view addSubview:_UserVCTableView];
    UIView *viewAboveHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_BOUNDS.height * (-1), SCREEN_BOUNDS.width, SCREEN_BOUNDS.height)];
    viewAboveHeaderView.backgroundColor = [UIColor bookAppColor];
    [_UserVCTableView addSubview:viewAboveHeaderView];
    _UserVCTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark 设置分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
#pragma mark 设置分组标题内容高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0001f;
    }else if (section == 1) {
        return 0;
    }
    return 0;
}

#pragma mark 设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 2;
    }
    return 1;
}
#pragma mark 设置单元格样式和内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *UserViewCell;
        UserViewCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        UserViewCell.backgroundColor = [UIColor bookAppColor];
        
        UserViewCell.selectedBackgroundView = [[UIView alloc] initWithFrame:UserViewCell.frame];
        UserViewCell.selectedBackgroundView.backgroundColor = [UIColor bookAppColor];

        
        // 添加用户头像
        UIImageView *userImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];                                                                     // 设置头像图片大小
        userImage.contentMode = UIViewContentModeScaleAspectFit;                                                                                                    // 设置图片属性为合适填充
        [userImage setImage:[UIImage imageNamed:@"touxiang.png"]];
        [UserViewCell.contentView addSubview:userImage];
        // 添加用户名
        _nameLable = [[UILabel alloc]initWithFrame:CGRectMake(110, 20, SCREEN_BOUNDS.width - 110, 20)];
         NSString *userName = [[UserInfoModel sharedInstance] getUserName];
        _nameLable.text = userName;
        _nameLable.textColor = [UIColor whiteColor];
        _nameLable.font = [UIFont systemFontOfSize:20];
        [UserViewCell.contentView addSubview:_nameLable];
        // 添加职位信息
        _professionLable = [[UILabel alloc]initWithFrame:CGRectMake(110, 60, SCREEN_BOUNDS.width - 110, 20)];
        if ([[UserInfoModel sharedInstance] firstTrial] && ![[UserInfoModel sharedInstance] secondTrial]) {
            _professionLable.text = @"图书初审审核员";
        }else if ([[UserInfoModel sharedInstance] firstTrial] && [[UserInfoModel sharedInstance] secondTrial]) {
            _professionLable.text = @"图书复审审核员";
        }
        _professionLable.font = [UIFont systemFontOfSize:15];
        _professionLable.textColor = [UIColor whiteColor];
//        [UserViewCell.contentView addSubview:_professionLable];
        return UserViewCell;
    }else if (indexPath.section == 1) {
        UITableViewCell *UserViewCell;
        UserViewCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        
        if (indexPath.row == 0) {
            UserViewCell.textLabel.text = @"真实姓名";
            UserViewCell.detailTextLabel.text = [[UserInfoModel sharedInstance]getUserRealName];
        }else if (indexPath.row == 1){
            UserViewCell.textLabel.text = @"权限";
        }
        return UserViewCell;
    }else if (indexPath.section == 2) {
        UITableViewCell *changeServerAddressCell;
        changeServerAddressCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        
        changeServerAddressCell.textLabel.text = @"服务器地址";
        changeServerAddressCell.detailTextLabel.text = [Utils getServerAddress];
        return changeServerAddressCell;
    }
    return nil;
}
#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }
    return 50;
}
#pragma mark 设置每组标题名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}
#pragma mark 添加行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self logout];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];                                                                                  // 取消选中的状态
    }else if (indexPath.section == 1) {
        
        if (indexPath.row == 1) {
            CompetenceViewController *competenceVC = [[CompetenceViewController alloc]init];
            [self.navigationController pushViewController:competenceVC animated:YES];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];                                                                                  // 取消选中的状态
    }else if (indexPath.section == 2) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        // 使用自定义的AlertView
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 267, 80)];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 247, 20)];
        lable.text = @"服务器地址";
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:17];
        [containerView addSubview:lable];
        // 服务器地址
        UITextField *serverAddressTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 40, 247, 30)];
        serverAddressTextField.backgroundColor = [UIColor whiteColor];
        serverAddressTextField.font = [UIFont systemFontOfSize:20];
        serverAddressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        serverAddressTextField.borderStyle = UITextBorderStyleRoundedRect;
        serverAddressTextField.text = [Utils getServerAddress];
        serverAddressTextField.returnKeyType = UIReturnKeyNext;
        [containerView addSubview:serverAddressTextField];
        
        [alertView setContainerView:containerView];
        
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"修改", nil]];
        
        [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
            
            if (buttonIndex == 1) {
                [Utils setServerAddress:serverAddressTextField.text];
                [self.UserVCTableView reloadData];
            }
            [alertView close];
        }];
        
        [alertView setUseMotionEffects:true];
        
        // And launch the dialog
        [alertView show];
    }
    
}
#pragma mark 登出
- (void)logout {
    // 添加注销确认提示框
    UIAlertController *logoutAlert = [UIAlertController alertControllerWithTitle:@"警告" message:@"注销会删除当前用户的本地信息" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *lougoutAction = [UIAlertAction actionWithTitle:@"注销" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        [self presentViewController:UserVCdelegate.loginVC animated:YES completion:nil];
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
