//
//  TableScrollViewCell.h
//  Book
//
//  Created by Dreamylife on 16/3/24.
//  Copyright © 2016年 software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface TableScrollViewCell : UITableViewCell
#pragma mark 为cell上的view布局添加文字或图片信息
- (void)setBookInfo:(Book *)book;
#pragma mark 初始化cell上的view布局
- (void)initCellView;
#pragma mark remove掉当前cell上的所有view布局
- (void)removeCellView;

@end