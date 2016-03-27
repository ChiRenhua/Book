//
//  ThirdViewController.m
//  Book
//
//  Created by Dreamylife on 16/3/18.
//  Copyright © 2016年 software. All rights reserved.
//

#import "ThirdViewController.h"
#import "TableScrollViewCell.h"
#import "AppDelegate.h"
#import "GetBookInfo.h"
#import "BookInfoViewController.h"
#import "BookDetialViewController.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size

@interface ThirdViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

UITableView *thirdTableView;
TableScrollViewCell *scrollViewCell;
AppDelegate *thirdAppdelegate;
GetBookInfo *bookinfo;

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];                                                                                                                   // 添加navigation的title
    self.navigationItem.title = @"已审核";
    thirdTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.width, SCREEN_BOUNDS.height-25) style:UITableViewStyleGrouped];
    thirdTableView.delegate = self;
    thirdTableView.dataSource = self;
    [self.view addSubview:thirdTableView];
    
    thirdAppdelegate = [[UIApplication sharedApplication]delegate];
}
#pragma mark 设置分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
#pragma mark 设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
#pragma mark 设置单元格样式和内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    bookinfo = [[GetBookInfo alloc]init];
    // 第一组显示已通过的图书列表
    if (indexPath.section == 0) {
        scrollViewCell = [[TableScrollViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil booksResult:@"已通过"];
    }
    // 第二组显示未通过的图书列表
    if (indexPath.section == 1){
        scrollViewCell = [[TableScrollViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil booksResult:@"未通过"];
    }
    // 点击图书页面跳转的回调函数
    scrollViewCell.scrollerBlockToDetial = ^(NSInteger bookstate,NSInteger index){
        // 判断用户点击的第几个图片
        NSMutableArray *bookInfo = [[NSMutableArray alloc]init];
        Book *book = [[Book alloc]init];
        if (bookstate == 0) {
            bookInfo = [bookinfo getPassBooks];
        }else if (bookstate == 1) {
            bookInfo = [bookinfo getUnpassBooks];
        }
        book = bookInfo[index];
        BookDetialViewController *bookDetialVC = [[BookDetialViewController alloc]init:book];
        [self.navigationController pushViewController:bookDetialVC animated:YES];
    };
    // 取消选中状态
    scrollViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return scrollViewCell;
}
#pragma mark 设置每组标题名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *titleArray = [[NSArray alloc]initWithObjects:@"审核已通过",@"审核未通过", nil];
    return [titleArray objectAtIndex:section];
}
#pragma mark 设置分组标题内容高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
#pragma mark 设置分组标尾内容高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 240;
}
#pragma mark 行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *bookInfo = [[NSMutableArray alloc]init];
    // 判断点击的是第几个分组
    if (indexPath.section == 0) {
        bookInfo = [bookinfo getPassBooks];
    }else if (indexPath.section == 1) {
        bookInfo = [bookinfo getUnpassBooks];
    }
    BookInfoViewController *bookInfoVC = [[BookInfoViewController alloc]init:bookInfo];
    [self.navigationController pushViewController:bookInfoVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
