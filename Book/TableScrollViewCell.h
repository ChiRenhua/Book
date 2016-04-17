//
//  TableScrollViewCell.h
//  Book
//
//  Created by Dreamylife on 16/3/24.
//  Copyright © 2016年 software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

#pragma mark 定义block用来回调View中的方法来实现界面跳转
typedef void (^scrollerViewPushBookDetialView)(NSInteger bookstate,NSInteger index);

@interface TableScrollViewCell : UITableViewCell
#pragma mark 定义初始化函数
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier booksResult:(NSString *)result isFirstReview:(BOOL)isfirstreview;
#pragma mark 定义block变量
@property (nonatomic,copy) scrollerViewPushBookDetialView scrollerBlockToDetial;

@end