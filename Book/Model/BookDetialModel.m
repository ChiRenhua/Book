//
//  BookDetialModel.m
//  Book
//
//  Created by Renhuachi on 16/8/29.
//  Copyright © 2016年 software. All rights reserved.
//

#import "BookDetialModel.h"
#import "AFNetworking/AFNetworking.h"
#define BASEURL @"http://218.7.18.46/bookmgyun/servlet/"

@interface BookDetialModel ()

@end

@implementation BookDetialModel

+ (BookDetialModel *)sharedInstance {
    static BookDetialModel *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BookDetialModel alloc]init];
    });
    return instance;
}

- (void)getBookreasonWithURL:(NSString *)bookReasonurl by:(NSInteger)Module{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [BASEURL stringByAppendingString:bookReasonurl];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
        NSLog(@"success%@",responseObject);
        int status = [responseObject[@"status"] intValue];
        if (Module == bookReasonModule) {
            if (status == 1000) {
                _updateReason(responseObject[@"message"]);
            }else if(status == 1001) {
                _bookDetialShowLoginView();
            }else if(status == 1002) {
                _updateReason(@"暂无审核记录");
            }else if(status == 1003) {
                _updateReason(@"无");
            }
        }else if (Module == addReviewButtonModule) {
            if (status == 1000) {
                //加审成功
                _showReviewView();
            }else if(status == 1001) {
                _bookDetialShowLoginView();
            }else if(status == 1002) {
                //书籍不存在
                _showToast(@"书籍不存在，请验证后重试!");
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (Module == bookReasonModule) {
            _failedUpdateReason();
        }else if (Module == addReviewButtonModule) {
            //加审失败逻辑
            _showToast(@"加审失败，请重试!");
        }
        

    }];
}

@end
