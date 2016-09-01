//
//  Book.m
//  Book
//
//  Created by Dreamylife on 16/3/22.
//  Copyright © 2016年 software. All rights reserved.
//

#import "Book.h"

#define BOOK_IMAGEBASEURL @"http://121.42.174.184:8080/bookmgyun/"

@implementation Book
#pragma mark 初始化函数
- (Book *)initWithDictionary:(NSMutableDictionary *)dic {
    if (self = [super init]) {
        _authorName = [dic objectForKey:@"authorName"];
        _bookName = [dic objectForKey:@"bookName"];
        _coverPath = [BOOK_IMAGEBASEURL stringByAppendingString:[dic objectForKey:@"coverPath"]];
        _bookID = [dic objectForKey:@"id"];
        _isbn = [dic objectForKey:@"isbn"];
        _bookState = @"";
    }
    return self;
}
#pragma mark 静态初始化函数
+ (Book *)staticInitWithDictionary:(NSMutableDictionary *)dic {
    Book *book = [[Book alloc]initWithDictionary:dic];
    return book;
}

@end
