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
        _bookName = [dic objectForKey:@"bookName"];                         // 图书名称
        _bookWriter = [dic objectForKey:@"bookWriter"];                     // 图书作者
        _bookTime = [dic objectForKey:@"bookTime"];                         // 图书完成时间
        _bookSummary = [dic objectForKey:@"bookSummary"];                   // 图书简介
        _bookSize = [dic objectForKey:@"bookSize"];                         // 图书大小
        _bookPages = [dic objectForKey:@"bookPages"];                       // 图书页数
        _bookCategory = [dic objectForKey:@"bookCategory"];                 // 图书种类
        _bookPicture = [dic objectForKey:@"bookPicture"];                   // 图书封皮
        _bookState = [dic objectForKey:@"bookState"];                       // 审核状态
        _bookPublishers = [dic objectForKey:@"bookPublishers"];             // 出版商
        _bookLanguage = [dic objectForKey:@"bookLanguage"];                 // 图书语言
        _bookReviewInfo = [dic objectForKey:@"bookReviewInfo"];             // 图书审核信息
        _bookReviewInfoShow = [dic objectForKey:@"bookReviewInfoShow"];
        
    }
    return self;
}
#pragma mark 静态初始化函数
+ (Book *)staticInitWithDictionary:(NSMutableDictionary *)dic {
    Book *book = [[Book alloc]initWithDictionary:dic];
    return book;
}

@end
