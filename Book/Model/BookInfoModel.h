//
//  BookInfoModel.h
//  Book
//
//  Created by Renhuachi on 16/8/28.
//  Copyright © 2016年 software. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^updateTableView)();

@interface BookInfoModel : NSObject

@property(nonatomic,copy)updateTableView updateTV;

+ (BookInfoModel *)sharedInstance;

- (void)getBookDataWithUsername:(NSString *)userName Sessionid:(NSString *)sessionid step:(NSString *)step bookState:(NSString *)bookState;

- (NSMutableArray *)getBookArray;

@end
