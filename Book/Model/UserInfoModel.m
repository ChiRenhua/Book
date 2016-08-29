//
//  UserInfoModel.m
//  Book
//
//  Created by Dreamylife on 16/4/15.
//  Copyright © 2016年 software. All rights reserved.
//

#import "UserInfoModel.h"
#import "AFNetworking/AFNetworking.h"
#define BASEURL @"http://121.42.174.184:8080/bookmgyun/servlet/"

@interface UserInfoModel ()
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *userPassword;
@property(nonatomic,copy)NSString *userID;
@property(nonatomic,copy)NSString *userCompetence;
@property(nonatomic,copy)NSString *userRealName;
@property(nonatomic,copy)NSString *userSessionid;
@end

@implementation UserInfoModel


+ (UserInfoModel *)sharedInstance {
    static UserInfoModel *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserInfoModel alloc]init];
    });
    return instance;
}

-(void)saveUserLoginDataWithName:(NSString *)userName andPassword:(NSString *)userPassword andID:(NSString *)userID andCompetence:(NSString *) userCompetence andRealName:(NSString *) userRealName andSessionid:(NSString *) userSessionid{
    _userName = userName;
    _userPassword = userPassword;
    _userID = userID;
    _userCompetence = userCompetence;
    _userRealName = userRealName;
    _userSessionid = userSessionid;
    NSMutableDictionary *userDataDictionary = [[NSMutableDictionary alloc]init];
    [userDataDictionary setValue:userName forKey:@"userName"];
    [userDataDictionary setValue:userPassword forKey:@"userPassword"];
    [userDataDictionary setValue:userID forKey:@"userID"];
    [userDataDictionary setValue:userCompetence forKey:@"userCompetence"];
    [userDataDictionary setValue:userRealName forKey:@"userRealName"];
    [userDataDictionary setValue:userSessionid forKey:@"userSessionid"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"userInfo.plist"];
    [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
            
    [userDataDictionary writeToFile:plistPath atomically:YES];
}

- (void)getUserDataWithName:(NSString *)name andPassword:(NSString *)password {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *str = [NSString stringWithFormat:@"UserAction.serv?username=%@&password=%@",name,password];
    NSString *url = [BASEURL stringByAppendingString:str];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
         
     } progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
         NSLog(@"success%@",responseObject);
         int status = [responseObject[@"status"] intValue];
         if (status == 1000) {
             [self saveUserLoginDataWithName:name andPassword:password andID:responseObject[@"message"][@"id"] andCompetence:responseObject[@"message"][@"competence"] andRealName:responseObject[@"message"][@"realName"] andSessionid:responseObject[@"message"][@"sessionid"]];
             _loginResult(LOGIN_SUCCESS);
         }else if(status == 1001) {
             _loginResult(LOGIN_FAILED);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",error);
         _loginResult(LOGIN_NETWRONG);
     }];
}

- (void)getUserLoginStateWithName:(NSString *)name andPassword:(NSString *)password {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *str = [NSString stringWithFormat:@"UserAction.serv?username=%@&password=%@",name,password];
    NSString *url = [BASEURL stringByAppendingString:str];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
        NSLog(@"success%@",responseObject);
        int status = [responseObject[@"status"] intValue];
        if(status == 1001) {
            _showLoginView();
        }else if (status == 1000) {
            [self saveUserLoginDataWithName:name andPassword:password andID:responseObject[@"message"][@"id"] andCompetence:responseObject[@"message"][@"competence"] andRealName:responseObject[@"message"][@"realName"] andSessionid:responseObject[@"message"][@"sessionid"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}



- (NSString *)getUserName {
    // 从plist文件中读取用户数据
    if (!_userName) {
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [path objectAtIndex:0];
        NSString *plistPath = [filePath stringByAppendingPathComponent:@"userInfo.plist"];
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
        _userName = [userInfo objectForKey:@"userName"];
    }
    
    return _userName;
}

- (NSString *)getUserPassword {
    // 从plist文件中读取用户数据
    if (!_userPassword) {
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [path objectAtIndex:0];
        NSString *plistPath = [filePath stringByAppendingPathComponent:@"userInfo.plist"];
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
        _userPassword = [userInfo objectForKey:@"userPassword"];
    }
    return _userPassword;
}

- (NSString *)getUserID {
    // 从plist文件中读取用户数据
    if (!_userID) {
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [path objectAtIndex:0];
        NSString *plistPath = [filePath stringByAppendingPathComponent:@"userInfo.plist"];
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
        _userID = [userInfo objectForKey:@"userID"];
    }
    return _userID;
}

- (NSString *)getUserCompetence {
    // 从plist文件中读取用户数据
    if (!_userCompetence) {
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [path objectAtIndex:0];
        NSString *plistPath = [filePath stringByAppendingPathComponent:@"userInfo.plist"];
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
        _userCompetence = [userInfo objectForKey:@"userCompetence"];
    }
    return _userCompetence;
}

- (NSString *)getUserRealName {
    // 从plist文件中读取用户数据
    if (!_userRealName) {
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [path objectAtIndex:0];
        NSString *plistPath = [filePath stringByAppendingPathComponent:@"userInfo.plist"];
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
        _userRealName = [userInfo objectForKey:@"userRealName"];
    }
    return _userRealName;
}

- (NSString *)getUserSessionid {
    // 从plist文件中读取用户数据
    if (!_userSessionid) {
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [path objectAtIndex:0];
        NSString *plistPath = [filePath stringByAppendingPathComponent:@"userInfo.plist"];
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
        _userSessionid = [userInfo objectForKey:@"userSessionid"];
    }
    return _userSessionid;
}
@end
