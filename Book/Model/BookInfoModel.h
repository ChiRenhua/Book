//
//  BookInfoModel.h
//  Book
//
//  Created by Renhuachi on 16/8/28.
//  Copyright © 2016年 software. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GET_BOOK_FROM_NET_SUCCESS 1
#define GET_BOOK_FROM_NET_FAILED 0

typedef void (^updateTableView)(NSString *state,NSInteger errorcode);
typedef void (^ShowLoginAlert)();
typedef void (^OfflineMode)();

@interface BookInfoModel : NSObject

@property(nonatomic,copy)updateTableView updateTV;
@property(nonatomic,copy)ShowLoginAlert showLoginAlert;
@property(nonatomic,copy)OfflineMode offlineMode;

+ (BookInfoModel *)sharedInstance;

- (void)getSearchResultWithURL:(NSString*)searchURL;
- (void)getBookDataWithURL:(NSString *)bookurl bookState:(NSString *)bookState;

- (NSMutableArray *)getBookArray;

@end
