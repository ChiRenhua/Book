//
//  GetBookInfo.h
//  Book
//
//  Created by Dreamylife on 16/3/22.
//  Copyright © 2016年 software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

@interface GetBookInfo : NSObject
#pragma mark 获取初审中不同审核状态的书籍
- (NSMutableArray *)getPendingBooks;
- (NSMutableArray *)getReviewBooks;
- (NSMutableArray *)getPassBooks;
- (NSMutableArray *)getUnpassBooks;
#pragma mark 获取复审中不同审核状态的书籍
- (NSMutableArray *)getRePendingBooks;
- (NSMutableArray *)getReReviewBooks;
- (NSMutableArray *)getRePassBooks;
- (NSMutableArray *)getReUnpassBooks;

- (NSMutableArray *)getReviewInfoList;

@end
