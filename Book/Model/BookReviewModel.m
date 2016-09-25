//
//  BookReviewModel.m
//  Book
//
//  Created by Renhuachi on 16/8/30.
//  Copyright © 2016年 software. All rights reserved.
//

#import "BookReviewModel.h"
#import "AFNetworking/AFNetworking.h"
#import "UserInfoModel.h"
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

- (void)addBookReviewDataToLocalWithBookISBN:(NSString *)ISBN Array:(NSMutableArray *)array {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:ISBN];
    [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
    [array writeToFile:plistPath atomically:YES];
}

- (NSMutableArray *)getBookReviewDataToLocalWithBookISBN:(NSString *)ISBN {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:ISBN];
    NSMutableArray *array = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
    return array;
}

- (void)submitReviewDataWithURL:(NSString *)submitURL {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [BASEURL stringByAppendingString:submitURL];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
        int status = [responseObject[@"status"] intValue];
        if (status == 1000) {
            _submitSuccess();
        }else if(status == 1001) {
            _showLoginView();
        }else if(status == 1002) {
            _submitFailed();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        _failedLoadData(@"未知错误!请稍后重试!");
    }];
}

- (void)getBookReviewDataToLocalWithURL:(NSString *)reviewurl {
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
}

- (void)getBookReviewDataToLocalWithURL:(NSString *)reviewurl andBook:(Book *)book{
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
            //被小马同学坑，传回的第一个数据是封皮，不用本地加，但是本地逻辑已经写完，改动太大，只能暂时将传回的数组第一个数据剔除掉，所以i ＝ 1。
            for (int i = 1; i < [dic count]; i++) {
                [key addObject:dic[i][@"key"]];
                [value addObject:dic[i][@"value"]];
            }
            [self saveDictoinaryWithBook:book key:key value:value];
        }else if(status == 1001) {
            
        }else if(status == 1002) {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        
    }];
}

- (void)addReviewBookDataToLoaclWithBook:(Book *)book bookState:(NSString *)bookState{
    NSMutableArray *bookarray = [[NSMutableArray alloc]init];
    bookarray = [self getReviewBookFromLocal:bookState];
    if (bookarray == nil) {
        bookarray = [[NSMutableArray alloc]init];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [path objectAtIndex:0];
        NSString *plistPath = [filePath stringByAppendingPathComponent:bookState];
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        NSString *bookID = [NSString stringWithFormat:@"%@",book.bookID];
        [dic setValue:book.authorName forKey:@"authorName"];
        [dic setValue:book.bookName forKey:@"bookName"];
        [dic setValue:book.coverPath forKey:@"coverPath"];
        [dic setValue:bookID forKey:@"id"];
        [dic setValue:book.isbn forKey:@"isbn"];
        [dic setValue:book.bookState forKey:@"bookState"];
        [dic setValue:book.step forKey:@"step"];
        [bookarray addObject:dic];
        [bookarray writeToFile:plistPath atomically:YES];
        
        if ([self getBookReviewDataToLocalWithBookISBN:book.isbn] == nil) {
            NSString *url = [NSString stringWithFormat:@"getBookAllInfo.serv?username=%@&sessionid=%@&bookid=%@",[[UserInfoModel sharedInstance]getUserName],[[UserInfoModel sharedInstance]getUserSessionid],book.bookID];
            [self getBookReviewDataToLocalWithURL:url andBook:book];
        }
    }else {
        BOOL canAddtoLoacl = YES;
        for (int i = 0; i < bookarray.count; i++) {
            if ([bookarray[i][@"isbn"] isEqualToString:book.isbn]) {
                canAddtoLoacl = NO;
                break;
            }
        }
        if (canAddtoLoacl) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *filePath = [path objectAtIndex:0];
            NSString *plistPath = [filePath stringByAppendingPathComponent:bookState];
            [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            NSString *bookID = [NSString stringWithFormat:@"%@",book.bookID];
            [dic setValue:book.authorName forKey:@"authorName"];
            [dic setValue:book.bookName forKey:@"bookName"];
            [dic setValue:book.coverPath forKey:@"coverPath"];
            [dic setValue:bookID forKey:@"id"];
            [dic setValue:book.isbn forKey:@"isbn"];
            [dic setValue:book.bookState forKey:@"bookState"];
            [dic setValue:book.step forKey:@"step"];
            [bookarray addObject:dic];
            [bookarray writeToFile:plistPath atomically:YES];
            
            if ([self getBookReviewDataToLocalWithBookISBN:book.isbn] == nil) {
                NSString *url = [NSString stringWithFormat:@"getBookAllInfo.serv?username=%@&sessionid=%@&bookid=%@",[[UserInfoModel sharedInstance]getUserName],[[UserInfoModel sharedInstance]getUserSessionid],book.bookID];
                [self getBookReviewDataToLocalWithURL:url andBook:book];
            }
        }

    }
}

- (NSMutableArray *)getReviewBookFromLocal:(NSString *)bookState {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:bookState];
    NSMutableArray *array = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
    return array;
}
// 同步数据
- (void)synReviewbookDataWitharray:(NSMutableArray *)array bookState:(NSString *)bookState{
    NSMutableArray *nullarray = [[NSMutableArray alloc]init];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:bookState];
    [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
    [nullarray writeToFile:plistPath atomically:YES];
    
    for (int i = 0; i < array.count; i++) {
        [self addReviewBookDataToLoaclWithBook:array[i]bookState:bookState];
    }
}

// 保存
- (void)saveDictoinaryWithBook:(Book *)book key:(NSMutableArray *)key value:(NSMutableArray *)value {
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSString *book_image_url = [book.coverPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dic setObject:@"封皮" forKey:@"key"];
    [dic setObject:book_image_url forKey:@"value"];
    [dic setObject:@"1" forKey:@"result"];
    [array addObject:dic];
    for (int i = 0; i < [key count]; i++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:key[i] forKey:@"key"];
        [dic setObject:value[i] forKey:@"value"];
        [dic setObject:@"1" forKey:@"result"];
        [array addObject:dic];
    }
    [self addBookReviewDataToLocalWithBookISBN:book.isbn Array:array];
}

@end
