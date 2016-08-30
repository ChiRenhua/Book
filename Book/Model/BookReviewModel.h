//
//  BookReviewModel.h
//  Book
//
//  Created by Renhuachi on 16/8/30.
//  Copyright © 2016年 software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookReviewModel : NSObject

+ (BookReviewModel *)sharedInstance;

- (void)addBookReviewDataToLocalWithBookISBN:(NSString *)ISBN Dictionary:(NSMutableDictionary *)dic;
- (NSMutableDictionary *)getBookReviewDataToLocalWithBookISBN:(NSString *)ISBN;
- (NSDictionary *)getBookReviewDataToLocalWithURL:(NSString *)reviewurl;

@end
