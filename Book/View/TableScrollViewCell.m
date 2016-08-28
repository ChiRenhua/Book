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
#import "GetBookInfo.h"
#define SCREEN_BOUNDS self.contentView.frame.size

@interface TableScrollViewCell()<UITableViewDataSource,UITableViewDelegate>
@property (assign ,nonatomic) BOOL isFirstReview;
@end
UILabel *title;                                                                                                     // 显示图书审核状态
UILabel *checkAll;                                                                                                  // 显示全部按钮
NSMutableArray *bookinfoArray;                                                                                      // 书籍信息数组
AppDelegate *scrollerViewAppdelegate;                                                                               // 全局变量
GetBookInfo *bookInfo;
NSString *booksResult;                                                                                              // 图书审核结果

@implementation TableScrollViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier booksResult:(NSString *)result isFirstReview:(BOOL)isfirstreview{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _isFirstReview = isfirstreview;
        bookinfoArray = [[NSMutableArray alloc]init];
        scrollerViewAppdelegate = [[UIApplication sharedApplication] delegate];                                     // 获取全局变量
        bookInfo = [[GetBookInfo alloc]init];
        booksResult = result;
        [self initScrollCellView];
    }
    return self;
}

#pragma mark 初始化cell上的view布局
- (void)initScrollCellView {
    // 添加审核阶段title
    title = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_BOUNDS.width-60, 20)];
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:18];
    title.text = booksResult;
    [self.contentView addSubview:title];
    // 添加“查看全部”按钮
    checkAll = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 10, 60, 20)];
    checkAll.textColor = [UIColor grayColor];
    checkAll.text = @"显示全部>";
    checkAll.font = [UIFont systemFontOfSize:12];
    checkAll.userInteractionEnabled = NO;                                                                           // 屏蔽掉Lable的点击事件
    [self.contentView addSubview:checkAll];
    // 在cell上添加tableView布局
    UITableView *scrollTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    scrollTableView.bounds = CGRectMake(0, 0, 200, [UIScreen mainScreen].bounds.size.width);                        // 后两个参数分别用来设置“宽度”“高度”
    scrollTableView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 130);                           // 设置tableView的中心点坐标
    scrollTableView.delegate = self;
    scrollTableView.dataSource = self;
    scrollTableView.showsVerticalScrollIndicator = NO;                                                              // 取消滚动条
    scrollTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);                                             // 将tableView翻转
    scrollTableView.separatorStyle = UITableViewCellSeparatorStyleNone;                                             // 取消分割线
    // 给每个ScrollTableView加上标签，来确定以后加载什么数据
    if ([booksResult isEqualToString:@"已通过"]) {
        scrollTableView.tag = 0;
    }else if([booksResult isEqualToString:@"未通过"]){
        scrollTableView.tag = 1;
    }
    [self.contentView addSubview:scrollTableView];
 
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
        cell.transform = CGAffineTransformMakeRotation(M_PI_2);                                                                                 // 将cell上的内容翻转
        cell.selectionStyle = UITableViewCellSelectionStyleNone;                                                                                // 取消选中状态
    }
    // 根据不同的tag来加载不用的数据
    if (tableView.tag == 0) {
        if (_isFirstReview) {
            bookinfoArray = [bookInfo getPassBooks];
        }else {
            bookinfoArray = [bookInfo getRePassBooks];
        }
    }else if(tableView.tag == 1){
        if (_isFirstReview) {
            bookinfoArray = [bookInfo getUnpassBooks];
        }else {
            bookinfoArray = [bookInfo getReUnpassBooks];
        }
    }
    Book *book = bookinfoArray[indexPath.row];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];                                                      // 每次初始化之前移除view上的所有布局
    
    // 在cell上添加imageView
    UIImageView *bookPicture = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 90, 135)];
    bookPicture.image = [UIImage imageNamed:book.bookPicture];
    bookPicture.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:bookPicture];
    
    // 在cell上添加图书名称
    UILabel *bookNameLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 140, 95, 60)];
    bookNameLable.lineBreakMode = NSLineBreakByTruncatingTail;                                                                                    // 文字过长时显示全部
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
    _scrollerBlockToDetial(tableView.tag,indexPath.row);                                                                                        // 执行block，让父View来执行界面跳转
    [tableView deselectRowAtIndexPath:indexPath animated:YES];                                                                                  // 取消选中的状态
}
#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
@end