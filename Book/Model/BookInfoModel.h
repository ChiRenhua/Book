//
//  BookInfoModel.h
//  Book
//
//  Created by Renhuachi on 16/8/28.
//  Copyright © 2016年 software. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^updateTableView)(NSString *state);
typedef void (^ShowLoginAlert)();

@interface BookInfoModel : NSObject

@property(nonatomic,copy)updateTableView updateTV;
@property(nonatomic,copy)ShowLoginAlert showLoginAlert;

+ (BookInfoModel *)sharedInstance;

- (void)getBookDataWithURL:(NSString *)bookurl bookState:(NSString *)bookState;

- (NSMutableArray *)getBookArray;

@end
