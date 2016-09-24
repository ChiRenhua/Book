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
typedef void (^SubmitSuccess)();
typedef void (^SubmitFailed)();

@interface BookReviewModel : NSObject

@property(nonatomic,copy) UpdataReviewView updataReviewView;
@property(nonatomic,copy) ShowLoginView showLoginView;
@property(nonatomic,copy) NoBookInfo noBookInfo;
@property(nonatomic,copy) FailedLoadData failedLoadData;
@property(nonatomic,copy) SubmitSuccess submitSuccess;
@property(nonatomic,copy) SubmitFailed submitFailed;

+ (BookReviewModel *)sharedInstance;

- (void)addBookReviewDataToLocalWithBookISBN:(NSString *)ISBN Array:(NSMutableArray *)array;
- (NSMutableArray *)getBookReviewDataToLocalWithBookISBN:(NSString *)ISBN;
- (void)getBookReviewDataToLocalWithURL:(NSString *)reviewurl;
- (void)addReviewBookDataToLoaclWithBook:(Book *)book bookState:(NSString *)bookState;
- (NSMutableArray *)getReviewBookFromLocal:(NSString *)bookState;
- (void)synReviewbookDataWitharray:(NSMutableArray *)array bookState:(NSString *)bookState;
- (void)submitReviewDataWithURL:(NSString *)submitURL;

@end
