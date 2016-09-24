//
//  SearchModel.m
//  Book
//
//  Created by Renhuachi on 16/9/2.
//  Copyright © 2016年 software. All rights reserved.
//

#import "SearchModel.h"
#import "AFNetworking/AFNetworking.h"
#define BASEURL @"http://121.42.174.184:8080/bookmgyun/servlet/"

@interface SearchModel()

@end

@implementation SearchModel

+ (SearchModel *)sharedInstance {
    static SearchModel *instance;
    static dispatch_once_t token;
    dispatch_once(&token,^{
        instance = [[SearchModel alloc]init];
    });
    return instance;
}

- (void)getSearchDataWithURL:(NSString *)searchURL {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [BASEURL stringByAppendingString:searchURL];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
        //NSLog(@"success%@",responseObject);
        int status = [responseObject[@"status"] intValue];
        if (status == 1000) {
            NSMutableArray *array = responseObject[@"message"];
            _successLoadSearchData(array);
        }else if(status == 1001) {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _failedLoadSearchData();
    }];
}

@end
