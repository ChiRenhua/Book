//
//  UserInfo.m
//  Book
//
//  Created by Dreamylife on 16/4/15.
//  Copyright © 2016年 software. All rights reserved.
//

#import "UserInfo.h"
#import "AppDelegate.h"

@implementation UserInfo
AppDelegate *userInfoDelegate;


-(id)init {
    if (self = [super init]) {
        userInfoDelegate = [[UIApplication sharedApplication]delegate];
        #pragma mark 将用户信息存储到plist文件中
        userInfoDelegate.loginVC.userInfoBlock = ^(NSString *userPermission,NSString *userName,NSString *userPassword){
            NSMutableDictionary *userDataDictionary = [[NSMutableDictionary alloc]init];
            [userDataDictionary setValue:userName forKey:@"userName"];
            [userDataDictionary setValue:userPassword forKey:@"userPassword"];
            [userDataDictionary setValue:userPermission forKey:@"userPermission"];
            
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *filePath = [path objectAtIndex:0];
            NSString *plistPath = [filePath stringByAppendingPathComponent:@"userInfo.plist"];
            [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
            
            [userDataDictionary writeToFile:plistPath atomically:YES];
        };
    }
    return self;
}

- (NSString *)getUserName {
    // 从plist文件中读取用户数据
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"userInfo.plist"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    NSString *userName = [userInfo objectForKey:@"userName"];
    return userName;
}

- (NSString *)getUserPassword {
    // 从plist文件中读取用户数据
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"userInfo.plist"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    NSString *userPassword = [userInfo objectForKey:@"userPassword"];
    return userPassword;
}

- (NSString *)getUserPermission {
    // 从plist文件中读取用户数据
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"userInfo.plist"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    NSString *userPermission = [userInfo objectForKey:@"userPermission"];
    return userPermission;
}
@end
