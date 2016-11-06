//
//  BookDownloadModel.h
//  Book
//
//  Created by Renhuachi on 2016/11/5.
//  Copyright © 2016年 software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"
#import "UserInfoModel.h"

typedef void (^ShowLoginAlert)();
typedef void (^GetBookDataSuccess)(NSArray *data);
typedef void (^GetBookDataFailed)(NSError *error);

typedef void (^DownloadBookFileFailed)(NSError *error, NSUInteger index);
typedef void (^DownloadBookFileComplete)(NSUInteger index);
typedef void (^DownloadingBookFileWithProgress)(float progress, NSUInteger index);

@interface BookDownloadModel : NSObject

@property(nonatomic,copy)ShowLoginAlert showLoginAlert;
@property(nonatomic,copy)GetBookDataSuccess getBookDataSuccess;
@property(nonatomic,copy)GetBookDataFailed getBookDataFailed;

@property(nonatomic,copy)DownloadBookFileFailed downloadBookFileFailed;
@property(nonatomic,copy)DownloadBookFileComplete downloadBookFileComplete;
@property(nonatomic,copy)DownloadingBookFileWithProgress downloadingBookFileWithProgress;

+ (BookDownloadModel *)sharedInstance;

- (void)getBookImageListWithBookInfo:(Book *)bookInfo;
- (void)getBookFileListWithBookInfo:(Book *)bookInfo;

- (void)downloadBookFileWithBookInfo:(Book *)bookInfo url:(NSURL *)url indexPath:(NSUInteger)index;
- (NSString *)getBookDownloadPathWithBookID:(NSString *)bookID;

@end
