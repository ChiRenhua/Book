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

- (void)addReviewBookDataToLoaclWithBook:(Book *)book {
    NSMutableArray *bookarray = [[NSMutableArray alloc]init];
    bookarray = [self getReviewBookFromLocal];
    if (bookarray == nil) {
        bookarray = [[NSMutableArray alloc]init];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [path objectAtIndex:0];
        NSString *plistPath = [filePath stringByAppendingPathComponent:@"localbookinfo"];
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:book.authorName forKey:@"authorName"];
        [dic setValue:book.bookName forKey:@"bookName"];
        [dic setValue:book.coverPath forKey:@"coverPath"];
        [dic setValue:book.bookID forKey:@"bookID"];
        [dic setValue:book.isbn forKey:@"isbn"];
        [dic setValue:book.bookState forKey:@"bookState"];
        [bookarray addObject:dic];
        [bookarray writeToFile:plistPath atomically:YES];
        
        bookarray = [self getReviewBookFromLocal];
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
            NSString *plistPath = [filePath stringByAppendingPathComponent:@"localbookinfo"];
            [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setValue:book.authorName forKey:@"authorName"];
            [dic setValue:book.bookName forKey:@"bookName"];
            [dic setValue:book.coverPath forKey:@"coverPath"];
            [dic setValue:book.bookID forKey:@"bookID"];
            [dic setValue:book.isbn forKey:@"isbn"];
            [dic setValue:book.bookState forKey:@"bookState"];
            [bookarray addObject:dic];
            [bookarray writeToFile:plistPath atomically:YES];
        }

    }
}

- (NSMutableArray *)getReviewBookFromLocal {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"localbookinfo"];
    NSMutableArray *array = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
    return array;
}

@end
