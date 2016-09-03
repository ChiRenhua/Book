//
//  LoginViewController.m
//  Book
//
//  Created by Dreamylife on 16/3/19.
//  Copyright © 2016年 software. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "UserInfoModel.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size

@interface LoginViewController ()<UITextFieldDelegate,MBProgressHUDDelegate>
@property(strong,retain) UITextField *userNameTextField;
@property(strong,retain)  UITextField *userPassWordTextField;
@property(strong,retain)  MBProgressHUD *mbprogress;
@end



@implementation LoginViewController

- (id)init{
    if(self = [super init]){
        self.view.backgroundColor = [UIColor whiteColor];                                           // 设置背景颜色为白色
        _mbprogress = [[MBProgressHUD alloc]initWithView:self.view];                                // 初始化toast
        _mbprogress.delegate = self;                                                                // 设置toast代理为当前类
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLoginForm];                                                                            // 加载登录界面UI
}
#pragma mark 加载登录界面UI
- (void)addLoginForm {
    // 添加登陆头像
    UIImageView *userImage = [[UIImageView alloc]init];
    userImage.bounds = CGRectMake(0, 0, 150, 150);                                                  // 设置头像图片大小
    userImage.contentMode = UIViewContentModeScaleAspectFit;                                        // 设置图片属性为合适填充
    userImage.center = CGPointMake(SCREEN_BOUNDS.width/2, SCREEN_BOUNDS.height/5);                  // 设置图片位置
    [userImage setImage:[UIImage imageNamed:@"touxiang.png"]];
    [self.view addSubview:userImage];
    // 添加登陆表格
    _userNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, SCREEN_BOUNDS.height/3, SCREEN_BOUNDS.width, 50)];
    _userNameTextField.backgroundColor = [UIColor whiteColor];
    _userNameTextField.font = [UIFont systemFontOfSize:20];                                          // 设置文字大小
    _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;                            // 设置删除按钮出现时间
    _userNameTextField.borderStyle = UITextBorderStyleRoundedRect;                                   // 设置边框样式
    _userNameTextField.placeholder = @"用户名";                                                       // 添加默认文字，点击消失
    _userNameTextField.returnKeyType = UIReturnKeyNext;                                              // return键样式更改
    [self.view addSubview:_userNameTextField];
    
    _userPassWordTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, SCREEN_BOUNDS.height/3 + 50, SCREEN_BOUNDS.width, 50)];
    _userPassWordTextField.backgroundColor = [UIColor whiteColor];
    _userPassWordTextField.font = [UIFont systemFontOfSize:20];                                       // 设置文字大小
    _userPassWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;                         // 设置删除按钮出现时间
    _userPassWordTextField.borderStyle = UITextBorderStyleRoundedRect;                                // 设置边框样式
    _userPassWordTextField.placeholder = @"密码";                                                      // 添加默认文字，点击消失
    _userPassWordTextField.keyboardType = UIKeyboardTypeDefault;                                      // 设置键盘样式
    _userPassWordTextField.secureTextEntry = YES;                                                     // 密文输入
    _userPassWordTextField.clearsOnBeginEditing = YES;                                                // 再次编辑清空
    _userPassWordTextField.returnKeyType = UIReturnKeyJoin;                                           // return键样式更改
    _userPassWordTextField.delegate = self;
    [self.view addSubview:_userPassWordTextField];
    
    // 添加登陆按钮
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = CGRectMake(SCREEN_BOUNDS.width/4, SCREEN_BOUNDS.height/3+110, (SCREEN_BOUNDS.width/4)*2, 50);
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];// 为登录按钮添加点击事件
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:loginButton];
    
    
    
}
#pragma mark 登陆验证操作
- (void)login {
    if ([_userNameTextField.text isEqualToString:@""] || [_userPassWordTextField.text isEqualToString:@""]) {
        // 对于没有输入用户名或密码的情况作处理
        _mbprogress.mode = MBProgressHUDModeText;                                                       // 设置toast的样式为文字
        _mbprogress.label.text = NSLocalizedString(@"请输入用户名或密码", @"HUD message title");           // 设置toast上的文字
        [self.view addSubview:_mbprogress];                                                             // 将toast添加到view中
        [self.view bringSubviewToFront:_mbprogress];                                                    // 让toast显示在view的最前端
        [_mbprogress showAnimated:YES];                                                                 // 显示toast
        [_mbprogress hideAnimated:YES afterDelay:1.5];                                                  // 1.5秒后销毁toast
    }else {
        [_mbprogress hideAnimated:YES];
        [self showProgressWithTitle:@"正在登陆..."andMode:MBProgressHUDModeIndeterminate];
        [[UserInfoModel sharedInstance]getUserDataWithName:_userNameTextField.text andPassword:_userPassWordTextField.text];
        [UserInfoModel sharedInstance].loginResult = ^(NSInteger code){
            switch (code) {
                case 0:
                    //[_mbprogress hideAnimated:YES];
                    [_mbprogress removeFromSuperview];
                    [self showLoginFailedDialg];
                    break;
                case 1:
                    
                    [_mbprogress hideAnimated:YES];
                    [self showSuccessProgress];
                    break;
                case 2:
                    //[_mbprogress hideAnimated:YES];
                    [_mbprogress removeFromSuperview];
                    [self showProgressWithTitle:@"网络错误"andMode:MBProgressHUDModeText];
                    [_mbprogress hideAnimated:YES afterDelay:1.5];                                                  // 1.5秒后销毁toast
                    break;
                default:
                    break;
            }
        };
    }
}
#pragma mark 显示toast
- (void)showProgressWithTitle:(NSString *) title andMode:(NSInteger )mode{
    _mbprogress.mode = mode;
    _mbprogress.label.text = NSLocalizedString(title, @"HUD cleanining up title");
    [self.view addSubview:_mbprogress];
    [self.view bringSubviewToFront:_mbprogress];
    [_mbprogress showAnimated:YES];
}

- (void)showUserView {
    // 加载个人页面数据
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    [appdelegate.UserVC.UserVCTableView reloadData];
}

- (void)showSuccessProgress {
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    _mbprogress.customView = imageView;
    _mbprogress.mode = MBProgressHUDModeCustomView;
    _mbprogress.label.text = NSLocalizedString(@"登陆成功", @"HUD completed title");
    [self.view bringSubviewToFront:_mbprogress];                                                    // 让toast显示在view的最前端
    [_mbprogress showAnimated:YES];                                                                 // 显示toast
    [self performSelector:@selector(showMainView) withObject:nil afterDelay:1.5f];
    _showHomeViewBlock();
    [self showUserView];
}
// 显示主界面
- (void)showMainView {
    [_mbprogress hideAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 登陆失败弹窗
- (void)showLoginFailedDialg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登陆失败" message:@"账号或密码错误，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark 重置键盘return按钮事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self login];
    [_userPassWordTextField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end