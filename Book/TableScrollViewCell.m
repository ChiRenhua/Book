//
//  TableScrollViewCell.m
//  Book
//
//  Created by Dreamylife on 16/3/24.
//  Copyright © 2016年 software. All rights reserved.
//

#import "TableScrollViewCell.h"
#define SCREEN_BOUNDS self.contentView.frame.size

@interface TableScrollViewCell()<UITableViewDataSource,UITableViewDelegate>

@end
UITableView *scrollTableView;
UILabel *title;
UILabel *checkAll;

@implementation TableScrollViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCellView];
    }
    return self;
}

#pragma mark 初始化cell上的view布局
- (void)initCellView {
    scrollTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, self.contentView.frame.size.width) style:UITableViewStylePlain];
//    scrollTableView.bounds = CGRectMake(0, 0, 100, self.contentView.frame.size.width);
//    scrollTableView.center = CGPointMake(CGRectGetMidX(self.contentView.frame), 100 / 2);
    scrollTableView.delegate = self;
    scrollTableView.dataSource = self;
    scrollTableView.showsVerticalScrollIndicator = NO;
    scrollTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    scrollTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:scrollTableView];
    // 添加审核阶段title
    title = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_BOUNDS.width-60, 20)];
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:18];
    title.text = @"asdfasdfdas";
    [self.contentView addSubview:title];
    // 添加“查看全部”按钮
    checkAll = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width - 50, 10, 50, 11)];
    checkAll.textColor = [UIColor grayColor];
    checkAll.text = @"显示全部>";
    checkAll.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:checkAll];
    
    
}
#pragma mark 为cell上的view布局添加文字或图片信息
- (void) setBookInfo:(Book *)book{
    title.text = book.bookState;
}
#pragma mark remove掉当前cell上的所有view布局
- (void)removeCellView {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


#pragma mark 设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
#pragma mark 设置单元格样式和内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text=@"sdfasdfsf";
    return cell;
}
#pragma mark 添加行点击事件
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self.navigationController pushViewController:bookDetialVC animated:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];                                                                          // 取消选中的状态
//}
#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}



@end
