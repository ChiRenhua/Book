//
//  BookListCache.m
//  Book
//
//  Created by Renhuachi on 16/9/24.
//  Copyright © 2016年 software. All rights reserved.
//

#import "BookListCache.h"
#import "Book.h"

@implementation BookListCache

+ (BookListCache *)sharedInstance {
    static BookListCache *instance;
    static dispatch_once_t token;
    dispatch_once(&token,^{
        instance = [[BookListCache alloc]init];
    });
    return instance;
}

- (NSMutableArray *)getBookListFromCache:(NSString *)key {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:key];
    NSMutableArray *array = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
    
    NSMutableArray *bookArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < array.count; i++) {
        Book *book = [[Book alloc]initWithDictionary:array[i]];
        book.bookState = array[i][@"bookState"];
        [bookArray addObject:book];
    }
    return bookArray;
}

- (void)setBookListToCache:(NSMutableArray *)bookList key:(NSString *)key {
    NSMutableArray *nullarray = [[NSMutableArray alloc]init];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:key];
    [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
    [nullarray writeToFile:plistPath atomically:YES];
    
    for (int i = 0; i < bookList.count; i++) {
        [self addBookDataToCacheWithBook:bookList[i]key:key];
    }
}

- (void)addBookDataToCacheWithBook:(Book *)book key:(NSString *)key{
    NSMutableArray *bookarray = [[NSMutableArray alloc]init];
    BOOL canAddtoLoacl = YES;
    bookarray = [self getBookListFromCache:key];
    if (bookarray == nil) {
        bookarray = [[NSMutableArray alloc]init];
    }else {
        for (int i = 0; i < bookarray.count; i++) {
            if ([bookarray[i][@"isbn"] isEqualToString:book.isbn]) {
                canAddtoLoacl = NO;
                break;
            }
        }
    }
    if (canAddtoLoacl) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [path objectAtIndex:0];
        NSString *plistPath = [filePath stringByAppendingPathComponent:key];
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:book.authorName forKey:@"authorName"];
        [dic setValue:book.bookName forKey:@"bookName"];
        [dic setValue:book.coverPath forKey:@"coverPath"];
        [dic setValue:book.bookID forKey:@"bookID"];
        [dic setValue:book.isbn forKey:@"isbn"];
        [dic setValue:book.bookState forKey:@"bookState"];
        [dic setValue:book.step forKey:@"step"];
        [bookarray addObject:dic];
        [bookarray writeToFile:plistPath atomically:YES];
    }
}

@end
