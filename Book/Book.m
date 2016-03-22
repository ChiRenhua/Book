//
//  Book.m
//  Book
//
//  Created by Dreamylife on 16/3/22.
//  Copyright © 2016年 software. All rights reserved.
//

#import "Book.h"

@implementation Book
#pragma mark 初始化函数
- (Book *)initWithDictionary:(NSMutableDictionary *)dic {
    if (self = [super init]) {
        _bookName = [dic objectForKey:@"bookName"];
        _bookWriter = [dic objectForKey:@"bookWriter"];
        _bookTime = [dic objectForKey:@"bookTime"];
        _bookSummary = [dic objectForKey:@"bookSummary"];
        _bookSize = [dic objectForKey:@"bookSize"];
        _bookPages = [dic objectForKey:@"bookPages"];
        _bookCategory = [dic objectForKey:@"bookCategory"];
        _bookPicture = [dic objectForKey:@"bookPicture"];
        _bookState = [dic objectForKey:@"bookState"];
    }
    return self;
}
#pragma mark 静态初始化函数
+ (Book *)staticInitWithDictionary:(NSMutableDictionary *)dic {
    Book *book = [[Book alloc]initWithDictionary:dic];
    return book;
}

@end
