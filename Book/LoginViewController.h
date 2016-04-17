//
//  LoginViewController.h
//  Book
//
//  Created by Dreamylife on 16/3/19.
//  Copyright © 2016年 software. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark 保存用户数据Block
typedef void (^SaveUserInfoBlock)(NSString *userPermission,NSString *userName,NSString *userPassword);
#pragma mark 通知主界面显示对应权限的数据
typedef void (^ShowHomeViewBlock)();

@interface LoginViewController : UIViewController

@property (nonatomic, copy) SaveUserInfoBlock userInfoBlock;
@property (nonatomic, copy) ShowHomeViewBlock showHomeViewBlock;
@end
