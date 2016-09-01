//
//  BookDetialModel.h
//  Book
//
//  Created by Renhuachi on 16/8/29.
//  Copyright © 2016年 software. All rights reserved.
//

#import <Foundation/Foundation.h>

//更新审核未通过原因
typedef void (^UpdateReason)(NSString * reason);
//更新审核未通过原因拉取失败
typedef void (^FailedUpdateReason)();
//登录验证失败弹窗
typedef void (^BookDetialShowLoginView)();
//展示提审结果
typedef void (^ShowToast)(NSString *message);
//拉起审核页面
typedef void (^ShowReviewView)();
@interface BookDetialModel : NSObject

@property(nonatomic,copy) UpdateReason updateReason;
@property(nonatomic,copy) ShowToast showToast;
@property(nonatomic,copy) BookDetialShowLoginView bookDetialShowLoginView;
@property(nonatomic,copy) ShowReviewView showReviewView;
@property(nonatomic,copy) FailedUpdateReason failedUpdateReason;

typedef NS_ENUM(NSInteger, Module)
{
    bookReasonModule        = 1,
    addReviewButtonModule   = 1 << 1,
};

+ (BookDetialModel *)sharedInstance;

- (void)getBookreasonWithURL:(NSString *)bookReasonurl by:(NSInteger )Module;

@end
