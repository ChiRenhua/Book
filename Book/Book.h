//
//  Book.h
//  Book
//
//  Created by Dreamylife on 16/3/22.
//  Copyright © 2016年 software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject
#pragma mark - 属性
@property (nonatomic,copy) NSString *bookName;                                      // 书名
@property (nonatomic,copy) NSString *bookWriter;                                    // 作者
@property (nonatomic,copy) NSString *bookTime;                                      // 申请日期
@property (nonatomic,copy) NSString *bookSummary;                                   // 图书简介
@property (nonatomic,copy) NSString *bookCategory;                                  // 图书类别
@property (nonatomic,copy) NSString *bookPages;                                     // 图书页数
@property (nonatomic,copy) NSString *bookSize;                                      // 图书大小
@property (nonatomic,copy) NSString *bookPicture;                                   // 图书封皮
@property (nonatomic,copy) NSString *bookState;                                     // 图书状态
@property (nonatomic,copy) NSString *bookPublishers;                                // 图书出版商
@property (nonatomic,copy) NSString *bookLanguage;                                  // 图书语言
@property (nonatomic,copy) NSMutableDictionary *bookReviewInfo;                     // 图书审核信息
@property (nonatomic,copy) NSString *bookReviewInfoShow;                            // 图书审核信息展示

#pragma mark 初始化函数
- (Book *)initWithDictionary:(NSMutableDictionary *)dic;
#pragma mark 静态初始化函数
+ (Book *)staticInitWithDictionary:(NSMutableDictionary *)dic;

@end
