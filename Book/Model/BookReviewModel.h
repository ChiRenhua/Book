//
//  BookReviewModel.h
//  Book
//
//  Created by Renhuachi on 16/8/30.
//  Copyright © 2016年 software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

typedef void (^UpdataReviewView)(NSMutableArray *key,NSMutableArray *value);
typedef void (^ShowLoginView)();
typedef void (^NoBookInfo)(NSString *error);
typedef void (^FailedLoadData)(NSString *error);

@interface BookReviewModel : NSObject

@property(nonatomic,copy) UpdataReviewView updataReviewView;
@property(nonatomic,copy) ShowLoginView showLoginView;
@property(nonatomic,copy) NoBookInfo noBookInfo;
@property(nonatomic,copy) FailedLoadData failedLoadData;

+ (BookReviewModel *)sharedInstance;

- (void)addBookReviewDataToLocalWithBookISBN:(NSString *)ISBN Array:(NSMutableArray *)array;
- (NSMutableArray *)getBookReviewDataToLocalWithBookISBN:(NSString *)ISBN;
- (void)getBookReviewDataToLocalWithURL:(NSString *)reviewurl;
- (void)addReviewBookDataToLoaclWithBook:(Book *)book;
- (NSMutableArray *)getReviewBookFromLocal;
- (void)synReviewbookDataWitharray:(NSMutableArray *)array;

@end
