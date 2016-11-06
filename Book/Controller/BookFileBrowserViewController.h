//
//  BookFileBrowserViewController.h
//  Book
//
//  Created by Renhuachi on 2016/11/5.
//  Copyright © 2016年 software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

typedef NS_ENUM(NSUInteger, BookFileBrowserType) {
    BookFileBrowserType_Image,
    BookFileBrowserType_PDF,
};

typedef NS_ENUM(NSUInteger, BookDownloadStatue) {
    BookDownloadStatue_UnStart,
    BookDownloadStatue_Downloading,
    BookDownloadStatue_Done,
    BookDownloadStatue_Failed,
};

@interface BookFileBrowserViewController : UIViewController

- (id)initWithBookInfo:(Book *)bookInfo bookFileBrowserType:(BookFileBrowserType) type;

@end
