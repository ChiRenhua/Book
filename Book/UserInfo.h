//
//  UserInfo.h
//  Book
//
//  Created by Dreamylife on 16/4/15.
//  Copyright © 2016年 software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserInfo : NSObject
// 获取用户名
- (NSString *)getUserName;
// 获取密码
- (NSString *)getUserPassword;
// 获取用户权限
- (NSString *)getUserPermission;


@end
