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

@end
