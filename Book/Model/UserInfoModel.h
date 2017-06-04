//
//  UserInfoModel.h
//  Book
//
//  Created by Dreamylife on 16/4/15.
//  Copyright © 2016年 software. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LOGIN_FAILED 0
#define LOGIN_SUCCESS 1
#define LOGIN_NETWRONG 2

typedef void (^LoginResult)(NSInteger code);
typedef void (^ShowLoginView)();
@interface UserInfoModel : NSObject

@property(nonatomic,copy) LoginResult loginResult;
@property(nonatomic,copy) ShowLoginView showLoginView;

+ (UserInfoModel *)sharedInstance;

- (void)getUserDataWithName:(NSString *)name andPassword:(NSString *)password;

- (void)getUserLoginStateWithName:(NSString *)name andPassword:(NSString *)password;

- (NSString *)getUserName;
- (NSString *)getUserPassword;
- (NSString *)getUserID;
- (NSArray *)getUserCompetence;
- (NSString *)getUserRealName;
- (NSString *)getUserSessionid;

- (BOOL)firstTrial;
- (BOOL)secondTrial;

- (NSMutableDictionary *)getCompetenceDictionnary;

@end
