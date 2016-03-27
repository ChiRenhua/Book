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
#pragma mark 获取不同审核状态的书籍
- (NSMutableArray *)getPendingBooks;
- (NSMutableArray *)getFirstReviewBooks;
- (NSMutableArray *)getReviewBooks;
- (NSMutableArray *)getSecondReviewBooks;
- (NSMutableArray *)getPassBooks;
- (NSMutableArray *)getUnpassBooks;

@end
