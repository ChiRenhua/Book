//
//  LoginViewController.h
//  Book
//
//  Created by Dreamylife on 16/3/19.
//  Copyright © 2016年 software. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SaveUserInfoBlock)(NSString *userPermission,NSString *userName,NSString *userPassword);

@interface LoginViewController : UIViewController

@property (nonatomic,copy) SaveUserInfoBlock userInfoBlock;
@end
