//
//  BookInfoModel.m
//  Book
//
//  Created by Renhuachi on 16/8/28.
//  Copyright © 2016年 software. All rights reserved.
//

#import "BookInfoModel.h"
#import "AFNetworking/AFNetworking.h"
#import "Utils.h"
#import "Book.h"

#define BASEURL [NSString stringWithFormat:@"%@/bookmgyun/servlet/", [Utils getServerAddress]]

@interface BookInfoModel()
@property(nonatomic,retain)NSMutableArray *bookArray;
@end

@implementation BookInfoModel

+ (BookInfoModel *)sharedInstance {
    static BookInfoModel *instance;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        instance = [[BookInfoModel alloc]init];
    });
    return instance;
}

- (void)getSearchResultWithURL:(NSString*)searchURL {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [BASEURL stringByAppendingString:searchURL];
    NSString *search_result_url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:search_result_url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
        int status = [responseObject[@"status"] intValue];
        if (status == 1000) {
            NSArray *ar = responseObject[@"message"];
            [self buildBookWithData:ar bookState:nil];
        }else if(status == 1001) {
            _showLoginAlert();
        }else if(status == 1002) {
            [_bookArray removeAllObjects];
            _updateTV(@"不存在此书的相关信息!",GET_BOOK_FROM_NET_SUCCESS);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        _updateTV(@"数据请求失败，请稍后重试!",GET_BOOK_FROM_NET_FAILED);
    }];
}

- (void)getBookDataWithURL:(NSString *)bookurl bookState:(NSString *)bookState {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [BASEURL stringByAppendingString:bookurl];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
        int status = [responseObject[@"status"] intValue];
        if (status == 1000) {
            NSArray *ar = responseObject[@"message"];
            NSLog(@"success%@",[ar objectAtIndex:0]);
            [self buildBookWithData:ar bookState:bookState];
        }else if(status == 1001) {
            _showLoginAlert();
        }else if(status == 1002) {
            _updateTV(@"请求列表为空!",GET_BOOK_FROM_NET_SUCCESS);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        if ([bookState isEqualToString:@"审核中"]) {
            _offlineMode();
        }else {
            _updateTV(@"数据请求失败，请稍后重试!",GET_BOOK_FROM_NET_FAILED);
        }
    }];
}

- (void)getwillExpiredBookDataWithURL:(NSString *)bookurl {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [BASEURL stringByAppendingString:bookurl];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
        int status = [responseObject[@"status"] intValue];
        if (status == 1000) {
            NSArray *ar = responseObject[@"message"];
            NSLog(@"success%@",[ar objectAtIndex:0]);
            [self buildwillExpiredBookWithData:ar];
        }else if(status == 1001) {
            _showLoginAlert();
        }else if(status == 1002) {
            _updateTV(@"请求列表为空!",GET_BOOK_FROM_NET_SUCCESS);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        _updateTV(@"数据请求失败，请稍后重试!",GET_BOOK_FROM_NET_FAILED);
    }];
}

- (void)buildBookWithData:(NSArray *)ar bookState:(NSString *)bookstate {
    _bookArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [ar count]; i++) {
        Book *book = [[Book alloc]initWithDictionary:ar[i]];
        book.bookState = bookstate;
        [_bookArray addObject:book];
    }
    _updateTV(@"数据加载成功!",GET_BOOK_FROM_NET_SUCCESS);
}

- (void)buildwillExpiredBookWithData:(NSArray *)ar {
    _bookArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [ar count]; i++) {
        Book *book = [[Book alloc]initWithWillExpiredDictionary:ar[i]];
        book.bookState = @"";
        [_bookArray addObject:book];
    }
    _updateTV(@"数据加载成功!",GET_BOOK_FROM_NET_SUCCESS);
}

- (NSMutableArray *)getBookArray {
    return _bookArray;
}

@end
