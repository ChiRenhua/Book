//
//  BookInfoModel.m
//  Book
//
//  Created by Renhuachi on 16/8/28.
//  Copyright © 2016年 software. All rights reserved.
//

#import "BookInfoModel.h"
#import "AFNetworking/AFNetworking.h"
#import "Book.h"

#define BASEURL @"http://121.42.174.184:8080/bookmgyun/servlet/"

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

- (void)getBookDataWithURL:(NSString *)bookurl bookState:(NSString *)bookState {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
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
            _updateTV(@"请求列表为空!");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        _updateTV(@"数据请求失败，请稍后重试！");
    }];
}

- (void)buildBookWithData:(NSArray *)ar bookState:(NSString *)bookstate {
    _bookArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [ar count]; i++) {
        Book *book = [[Book alloc]initWithDictionary:ar[i]];
        book.bookState = bookstate;
        [_bookArray addObject:book];
    }
    _updateTV(@"数据加载成功！");
}

- (NSMutableArray *)getBookArray {
    return _bookArray;
}

@end
