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
@property (nonatomic,copy) NSString *authorName;
@property (nonatomic,copy) NSString *bookName;
@property (nonatomic,copy) NSString *coverPath;
@property (nonatomic,copy) NSString *bookID;
@property (nonatomic,copy) NSString *isbn;
@property (nonatomic,copy) NSString *bookState;
@property (nonatomic,copy) NSString *step;
@property (nonatomic,copy) NSString *copyright_end;
@property (nonatomic,copy) NSString *copyright_owner;
@property (nonatomic,copy) NSString *copyright_contractid;
@property (nonatomic,copy) NSString *copyright_signature;

#pragma mark 初始化函数
- (Book *)initWithDictionary:(NSMutableDictionary *)dic;
- (Book *)initWithWillExpiredDictionary:(NSMutableDictionary *)dic;

@end
