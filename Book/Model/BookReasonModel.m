//
//  BookReasonModel.m
//  Book
//
//  Created by Renhuachi on 16/8/29.
//  Copyright © 2016年 software. All rights reserved.
//

#import "BookReasonModel.h"
#import "AFNetworking/AFNetworking.h"
#define BASEURL @"http://121.42.174.184:8080/bookmgyun/servlet/"

@interface BookReasonModel ()

@end

@implementation BookReasonModel

+ (BookReasonModel *)sharedInstance {
    static BookReasonModel *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BookReasonModel alloc]init];
    });
    return instance;
}

- (void)getBookreasonWithURL:(NSString *)bookReasonurl {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [BASEURL stringByAppendingString:bookReasonurl];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
        NSLog(@"success%@",responseObject);
        int status = [responseObject[@"status"] intValue];
        if (status == 1000) {
            _updateReason(responseObject[@"message"]);
        }else if(status == 1001) {
            
        }else if(status == 1002) {
            _updateReason(@"暂无审核信息");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _updateReason(@"审核信息加载失败！");

    }];
}

@end
