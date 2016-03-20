//
//  LoginViewController.m
//  Book
//
//  Created by Dreamylife on 16/3/19.
//  Copyright © 2016年 software. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size

@interface LoginViewController ()<UITextFieldDelegate,MBProgressHUDDelegate,NSURLConnectionDataDelegate>


@end

UITextField *userNameTextField;
UITextField *userPassWordTextField;
MBProgressHUD *mbprogress;

@implementation LoginViewController

- (id)init{
    if(self = [super init]){
        self.view.backgroundColor = [UIColor whiteColor];                                           // 设置背景颜色为白色
        mbprogress = [[MBProgressHUD alloc]initWithView:self.view];                                 // 初始化toast
        mbprogress.delegate = self;                                                                 // 设置toast代理为当前类
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
    userNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, SCREEN_BOUNDS.height/3, SCREEN_BOUNDS.width, 50)];
    userNameTextField.backgroundColor = [UIColor whiteColor];
    userNameTextField.font = [UIFont systemFontOfSize:20];                                          // 设置文字大小
    userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;                            // 设置删除按钮出现时间
    userNameTextField.borderStyle = UITextBorderStyleRoundedRect;                                   // 设置边框样式
    userNameTextField.placeholder = @"用户名";                                                       // 添加默认文字，点击消失
    userNameTextField.returnKeyType = UIReturnKeyNext;                                              // return键样式更改
    [self.view addSubview:userNameTextField];
    
    userPassWordTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, SCREEN_BOUNDS.height/3 + 50, SCREEN_BOUNDS.width, 50)];
    userPassWordTextField.backgroundColor = [UIColor whiteColor];
    userPassWordTextField.font = [UIFont systemFontOfSize:20];                                       // 设置文字大小
    userPassWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;                         // 设置删除按钮出现时间
    userPassWordTextField.borderStyle = UITextBorderStyleRoundedRect;                                // 设置边框样式
    userPassWordTextField.placeholder = @"密码";                                                      // 添加默认文字，点击消失
    userPassWordTextField.keyboardType = UIKeyboardTypeDefault;                                      // 设置键盘样式
    userPassWordTextField.secureTextEntry = YES;                                                     // 密文输入
    userPassWordTextField.clearsOnBeginEditing = YES;                                                // 再次编辑清空
    userPassWordTextField.returnKeyType = UIReturnKeyJoin;                                           // return键样式更改
    userPassWordTextField.delegate = self;
    [self.view addSubview:userPassWordTextField];
    
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
    if ([userNameTextField.text isEqualToString:@""] || [userPassWordTextField.text isEqualToString:@""]) {
        // 对于没有输入用户名或密码的情况作处理
        mbprogress.mode = MBProgressHUDModeText;                                                      // 设置toast的样式为文字
        mbprogress.label.text = NSLocalizedString(@"请输入用户名或密码", @"HUD message title");
        [self.view addSubview:mbprogress];
        [self.view bringSubviewToFront:mbprogress];
        [mbprogress showAnimated:YES];
        [mbprogress hideAnimated:YES afterDelay:2.];
    }else if([userNameTextField.text isEqualToString:@"Martin"] && [userPassWordTextField.text isEqualToString:@"123456"]) {
            [self showProgressWithTitle:@"正在登陆..."];
            [self getWeatherInfoFromNet];
    }else {
        [self showLoginFailedDialg];
    }
}
#pragma mark 显示toast
- (void)showProgressWithTitle:(NSString *) title{
    mbprogress.mode = MBProgressHUDModeIndeterminate;
    mbprogress.label.text = NSLocalizedString(title, @"HUD cleanining up title");
    [self.view addSubview:mbprogress];
    [self.view bringSubviewToFront:mbprogress];
    [mbprogress showAnimated:YES];
}

- (void)getWeatherInfoFromNet{
    NSString *URLString = @"http://wthrcdn.etouch.cn/WeatherApi?citykey=101051002";
    NSURL * URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:URL];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

// 数据全部获取完成后回调，有点延迟
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        mbprogress.customView = imageView;
        mbprogress.mode = MBProgressHUDModeCustomView;
        mbprogress.label.text = NSLocalizedString(@"登陆成功", @"HUD completed title");
        [mbprogress hideAnimated:YES afterDelay:3.f];
        [self dismissViewControllerAnimated:YES completion:nil];                                          // 登录成功后撤下登录界面
    });
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        [mbprogress hideAnimated:YES];
        [self showLoginFailedDialg];
    });
}

#pragma mark 登陆失败弹窗
- (void)showLoginFailedDialg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登陆失败" message:@"账号或密码错误，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
    }];
    [alert addAction:okAction];
}
#pragma mark 重置键盘return按钮事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self login];
    [userPassWordTextField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end