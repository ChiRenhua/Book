//
//  SecondViewController.m
//  Book
//
//  Created by Dreamylife on 16/3/18.
//  Copyright © 2016年 software. All rights reserved.
//

#import "SecondViewController.h"
#import "AppDelegate.h"
#import "ListTableViewCell.h"
#import "GetBookInfo.h"
#import "BookDetialViewController.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size

@interface SecondViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *secondViewtableView;
@end

ListTableViewCell *secondViewcell;
AppDelegate *secondViewappdelegate;
GetBookInfo *secondViewbookinfo;

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"审核中";
    _secondViewtableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];                 // 初始化tableview填充整个屏幕
    _secondViewtableView.dataSource = self;                                                                                   // 设置tableview的数据代理
    _secondViewtableView.delegate = self;                                                                                     // 设置tableview代理
    [self.view addSubview:_secondViewtableView];                                                                              // 将tableview添加到屏幕上
    secondViewappdelegate = [[UIApplication sharedApplication]delegate];
    secondViewbookinfo = [[GetBookInfo alloc]init];

}

#pragma mark 设置每组标题名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"书籍信息";
}
#pragma mark 设置分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
#pragma mark 设置分组标题内容高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

#pragma mark 设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [secondViewbookinfo.getPendingBooks count];
}
#pragma mark 设置单元格样式和内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    secondViewcell = [tableView dequeueReusableCellWithIdentifier:@"UIListTableViewCell"];                                                        // 从缓存池中取出cell
    if (!secondViewcell) {                                                                                                                        // 判断是否能取出cell
        secondViewcell = [[ListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UIListTableViewCell"];            // 如果cell为空则创建一个新的cell并放入缓存池中
    }else{                                                                                                                                        // 如果cell不为空（注意：以下操作很重要，不然会造成cell数据错乱）
        [secondViewcell removeCellView];                                                                                                          // 将之前cell界面上的view全部remove掉
        [secondViewcell initCellView];                                                                                                            // 重新初始化cell上的view
    }
    Book *books = secondViewbookinfo.getReviewBooks[indexPath.row];
    [secondViewcell setBookInfo:books];
    return secondViewcell;
}
#pragma mark 添加行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Book *book;
    NSMutableArray *bookArray = [secondViewbookinfo getReviewBooks];
    book = bookArray[indexPath.row];
    BookDetialViewController *bookDetialVC = [[BookDetialViewController alloc]init:book];
    [self.navigationController pushViewController:bookDetialVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];                                                                          // 取消选中的状态
}
#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
