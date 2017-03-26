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
        _authorName = [dic objectForKey:@"authorName"];
        _bookName = [dic objectForKey:@"bookName"];
        _coverPath = [dic objectForKey:@"coverPath"];
        _bookID = [dic objectForKey:@"id"];
        _isbn = [dic objectForKey:@"isbn"];
        _bookState = @"";
        _step = @"";
    }
    return self;
}

- (Book *)initWithWillExpiredDictionary:(NSMutableDictionary *)dic {
    if (self = [super init]) {
        _authorName = [dic objectForKey:@"authors"];
        _bookName = [dic objectForKey:@"book_name"];
        _coverPath = @"";
        _bookID = [dic objectForKey:@"book_id"];
        _isbn = @"";
        _bookState = @"";
        _step = @"";
        _copyright_end = [dic objectForKey:@"copyright_end"];
        _copyright_owner = [dic objectForKey:@"copyright_owner"];
        _copyright_signature = [dic objectForKey:@"copyright_signature"];
        _copyright_contractid = [dic objectForKey:@"copyright_contractid"];
    }
    return self;
}

@end
