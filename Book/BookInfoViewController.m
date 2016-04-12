//
//  BookInfoViewController.m
//  Book
//
//  Created by Dreamylife on 16/3/27.
//  Copyright © 2016年 software. All rights reserved.
//

#import "BookInfoViewController.h"
#import "AppDelegate.h"
#import "ListTableViewCell.h"
#import "GetBookInfo.h"
#import "BookDetialViewController.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size

@interface BookInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate>
@property (nonatomic,strong) UITableView *bookInfoTableView;
@end

ListTableViewCell *bookInfoViewcell;
AppDelegate *bookInfoAppdelegate;
NSMutableArray *bookInfoArray;
UISearchBar *bookInfoViewSearchBar;                                                                                            // 搜索框
UISearchDisplayController *bookInfoViewSearchDC;                                                                               // 搜索框界面控制器
NSMutableArray *bookInfoViewSearchResult;                                                                                      // 搜索结果

@implementation BookInfoViewController

- (instancetype)init:(NSMutableArray *)BI {
    self = [super init];
    if (self) {
        bookInfoArray = BI;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    Book *bookTemp = bookInfoArray[0];
    self.navigationItem.title = bookTemp.bookState;                                                                         // 获取图书状态显示在navigation上
    _bookInfoTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];                 // 初始化tableview填充整个屏幕
    _bookInfoTableView.dataSource = self;                                                                                   // 设置tableview的数据代理
    _bookInfoTableView.delegate = self;                                                                                     // 设置tableview代理
    [self.view addSubview:_bookInfoTableView];                                                                              // 将tableview添加到屏幕上
    bookInfoAppdelegate = [[UIApplication sharedApplication]delegate];
    [self addSearchBar];                                                                                                    // 添加搜索框
    
}

#pragma mark 设置每组标题名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // 判断是否是搜索结果的tableView
    if (tableView == bookInfoViewSearchDC.searchResultsTableView) {
        return @"搜索结果";
    }
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
    // 判断是否是搜索结果的tableView
    if (tableView==bookInfoViewSearchDC.searchResultsTableView) {
        return bookInfoViewSearchResult.count;
    }
    return [bookInfoArray count];
}
#pragma mark 设置单元格样式和内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Book *books;
    bookInfoViewcell = [tableView dequeueReusableCellWithIdentifier:@"UIListTableViewCell"];                                                        // 从缓存池中取出cell
    if (!bookInfoViewcell) {                                                                                                                        // 判断是否能取出cell
        bookInfoViewcell = [[ListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UIListTableViewCell"];            // 如果cell为空则创建一个新的cell并放入缓存池中
    }else{                                                                                                                                         // 如果cell不为空（注意：以下操作很重要，不然会造成cell数据错乱）
        [bookInfoViewcell removeCellView];                                                                                                          // 将之前cell界面上的view全部remove掉
        [bookInfoViewcell initCellView];                                                                                                            // 重新初始化cell上的view
    }
    // 判断是否是搜索结果的tableView
    if (tableView == bookInfoViewSearchDC.searchResultsTableView) {
        books = bookInfoViewSearchResult[indexPath.row];
    }else {
         books = bookInfoArray[indexPath.row];
    }
    [bookInfoViewcell setBookInfo:books];
    return bookInfoViewcell;
}
#pragma mark 添加行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Book *book = bookInfoArray[indexPath.row];
    BookDetialViewController *bookDetialVC = [[BookDetialViewController alloc]init:book];
    [self.navigationController pushViewController:bookDetialVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];                                                                          // 取消选中的状态
}
#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

#pragma mark 选中之前
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [bookInfoViewSearchBar resignFirstResponder];                                                                                                  // 退出键盘
    return indexPath;
}
#pragma mark - UISearchDisplayController代理方法
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self searchDataWithKeyWord:searchString];
    return YES;
}

#pragma mark 重写状态样式方法
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark 搜索形成新数据
-(void)searchDataWithKeyWord:(NSString *)keyWord{
    bookInfoViewSearchResult = [[NSMutableArray alloc]init];
    [bookInfoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Book *book = obj;
        if ([book.bookName.uppercaseString containsString:keyWord.uppercaseString] || [book.bookWriter.uppercaseString containsString:keyWord.uppercaseString]) {
            [bookInfoViewSearchResult addObject:book];
        }
    }];
    
}



#pragma mark 添加搜索栏
- (void)addSearchBar {
    bookInfoViewSearchBar = [[UISearchBar alloc]init];
    [bookInfoViewSearchBar sizeToFit];                                                                                                             // 大小自适应
    bookInfoViewSearchBar.placeholder = @"搜索";
    bookInfoViewSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    // 添加搜索框到页眉位置
    bookInfoViewSearchBar.delegate = self;
    _bookInfoTableView.tableHeaderView = bookInfoViewSearchBar;
    
    bookInfoViewSearchDC = [[UISearchDisplayController alloc]initWithSearchBar:bookInfoViewSearchBar contentsController:self];
    bookInfoViewSearchDC.delegate = self;
    bookInfoViewSearchDC.searchResultsDataSource=self;
    bookInfoViewSearchDC.searchResultsDelegate=self;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end