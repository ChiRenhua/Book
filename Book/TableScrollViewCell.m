//
//  TableScrollViewCell.m
//  Book
//
//  Created by Dreamylife on 16/3/24.
//  Copyright © 2016年 software. All rights reserved.
//

#import "TableScrollViewCell.h"
#import "AppDelegate.h"
#import "Book.h"
#define SCREEN_BOUNDS self.contentView.frame.size

@interface TableScrollViewCell()<UITableViewDataSource,UITableViewDelegate>

@end
UITableView *scrollTableView;
UILabel *title;                                                                                                     // 显示图书审核状态
UILabel *checkAll;                                                                                                  // 显示全部按钮
NSMutableArray *bookinfoArray;                                                                                      // 书籍信息数组
AppDelegate *scrollerViewAppdelegate;                                                                               // 全局变量

@implementation TableScrollViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier bookinfo:(NSMutableArray *) bookinfo {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        bookinfoArray = [[NSMutableArray alloc]init];
        bookinfoArray = bookinfo;
        scrollerViewAppdelegate = [[UIApplication sharedApplication] delegate];                                     // 获取全局变量
        [self initCellView];
    }
    return self;
}

#pragma mark 初始化cell上的view布局
- (void)initCellView {
    // 在cell上添加tableView布局
    scrollTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    scrollTableView.bounds = CGRectMake(0, 0, 200, [UIScreen mainScreen].bounds.size.width);                        // 后两个参数分别用来设置“宽度”“高度”
    scrollTableView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 130);                           // 设置tableView的中心点坐标
    scrollTableView.delegate = self;
    scrollTableView.dataSource = self;
    scrollTableView.showsVerticalScrollIndicator = NO;                                                              // 取消滚动条
    scrollTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);                                             // 将tableView翻转
    scrollTableView.separatorStyle = UITableViewCellSeparatorStyleNone;                                             // 取消分割线
    [self.contentView addSubview:scrollTableView];
    // 添加审核阶段title
    title = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_BOUNDS.width-60, 20)];
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:18];
    Book *book = bookinfoArray[0];
    title.text = book.bookState;
    [self.contentView addSubview:title];
    // 添加“查看全部”按钮
    checkAll = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width - 10, 10, 60, 20)];
    checkAll.textColor = [UIColor grayColor];
    checkAll.text = @"显示全部>";
    checkAll.font = [UIFont systemFontOfSize:12];
    checkAll.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAll)];
    [checkAll addGestureRecognizer:tap];
    [self.contentView addSubview:checkAll];
 
}

#pragma mark 设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
#pragma mark 设置单元格样式和内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"scrollCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"scrollCell"];
        cell.transform = CGAffineTransformMakeRotation(M_PI_2);                                                                         // 将cell上的内容翻转
        cell.selectionStyle = UITableViewCellSelectionStyleNone;                                                                        // 取消选中状态
    }
    
    Book *book = bookinfoArray[indexPath.row];
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];                                              // 每次初始化之前移除view上的所有布局
    
    // 在cell上添加imageView
    UIImageView *bookPicture = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 90, 135)];
    bookPicture.image = [UIImage imageNamed:book.bookPicture];
    bookPicture.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:bookPicture];
    
    // 在cell上添加图书名称
    UILabel *bookNameLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 140, 90, 50)];
    bookNameLable.lineBreakMode = NSLineBreakByWordWrapping;
    bookNameLable.numberOfLines = 0;
    bookNameLable.tag = 1;
    bookNameLable.font = [UIFont systemFontOfSize:15];
    bookNameLable.textColor = [UIColor blackColor];
    bookNameLable.text = book.bookName;
    [cell.contentView addSubview:bookNameLable];
    
    // 在cell上添加作者
    UILabel *writerLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 185, 90, 15)];
    writerLable.font = [UIFont systemFontOfSize:13];
    writerLable.tag = 2;
    writerLable.textColor = [UIColor grayColor];
    writerLable.text = book.bookWriter;
    [cell.contentView addSubview:writerLable];
    
    return cell;
}

#pragma mark 添加行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _scrollerBlockToDetial(bookinfoArray,indexPath.row);                                                                                        // 执行block，让父View来执行界面跳转
    [tableView deselectRowAtIndexPath:indexPath animated:YES];                                                                          // 取消选中的状态
}
#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
#pragma mark 显示所有书籍
- (void)showAll {
    _scrollerBlockToAllBook(bookinfoArray);
}



@end
