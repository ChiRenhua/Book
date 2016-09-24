//
//  BookListCache.h
//  Book
//
//  Created by Renhuachi on 16/9/24.
//  Copyright © 2016年 software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookListCache : NSObject

+ (BookListCache *)sharedInstance;

- (NSMutableArray *)getBookListFromCache:(NSString *)key;

- (void)setBookListToCache:(NSMutableArray *)bookList key:(NSString *)key;

@end
