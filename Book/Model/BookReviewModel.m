//
//  BookReviewModel.m
//  Book
//
//  Created by Renhuachi on 16/8/30.
//  Copyright © 2016年 software. All rights reserved.
//

#import "BookReviewModel.h"
#import "AFNetworking/AFNetworking.h"
#define BASEURL @"http://121.42.174.184:8080/bookmgyun/servlet/"

@interface BookReviewModel()

@end

@implementation BookReviewModel

+ (BookReviewModel *)sharedInstance {
    static BookReviewModel *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BookReviewModel alloc]init];
    });
    return instance;
}

- (void)addBookReviewDataToLocalWithBookISBN:(NSString *)ISBN Dictionary:(NSMutableDictionary *)dic {
    
}

- (NSMutableDictionary *)getBookReviewDataToLocalWithBookISBN:(NSString *)ISBN {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    return dic;
}

- (NSDictionary *)getBookReviewDataToLocalWithURL:(NSString *)reviewurl {
    NSDictionary *dic = [[NSDictionary alloc]init];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [BASEURL stringByAppendingString:reviewurl];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
        int status = [responseObject[@"status"] intValue];
        if (status == 1000) {
            NSArray *dic = responseObject[@"message"];
            NSMutableArray *key = [[NSMutableArray alloc]init];
            NSMutableArray *value = [[NSMutableArray alloc]init];
            for (int i = 0; i < [dic count]; i++) {
                [key addObject:dic[i][@"key"]];
                [value addObject:dic[i][@"value"]];
            }
            _updataReviewView(key,value);
        }else if(status == 1001) {
            _showLoginView();
        }else if(status == 1002) {
            _noBookInfo(responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        _failedLoadData(@"数据获取失败，请重试!");
    }];
    return dic;
}

@end
