//
//  PendingViewController.m
//  Book
//
//  Created by Dreamylife on 16/3/18.
//  Copyright © 2016年 software. All rights reserved.
//

#import "PendingViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ListTableViewCell.h"
#import "GetBookInfo.h"
#import "BookDetialViewController.h"
#import "FCXRefreshFooterView.h"
#import "FCXRefreshHeaderView.h"
#import "UIScrollView+FCXRefresh.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size

@interface PendingViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate>
@property (retain,strong) UITableView *PendingViewtableView;
@property (assign,atomic) BOOL isFirstreview;
@property (nonatomic, strong) FCXRefreshHeaderView *headerView;
@end

ListTableViewCell *PendingViewcell;
AppDelegate *PendingViewappdelegate;
GetBookInfo *PendingViewbookinfo;
UISearchBar *PendingViewSearchBar;                                                                                            // 搜索框
UISearchDisplayController *PendingViewSearchDC;                                                                               // 搜索框界面控制器
NSMutableArray *PendingViewSearchResult;                                                                                      // 搜索结果

@implementation PendingViewController

- (id)init:(BOOL)isFirstReview {
    if (self = [super init]) {
        _isFirstreview = isFirstReview;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"待审核";
     //添加此方法后，页面布局不会自动适应，而是需要手动调节
        if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
        {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    _PendingViewtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 75) style:UITableViewStyleGrouped];                                                                                          // 初始化tableview填充整个屏幕
    _PendingViewtableView.dataSource = self;                                                                                   // 设置tableview的数据代理
    _PendingViewtableView.delegate = self;                                                                                     // 设置tableview代理
    [self.view addSubview:_PendingViewtableView];                                                                              // 将tableview添加到屏幕上
    PendingViewappdelegate = [[UIApplication sharedApplication]delegate];
    PendingViewbookinfo = [[GetBookInfo alloc]init];
    [self addSearchBar];                                                                                                       // 添加搜索框
    [self addRefreshView];                                                                                                     // 添加下拉刷新View
    [_headerView startRefresh];
}
#pragma mark 添加下拉刷新View
- (void)addRefreshView {
    __weak __typeof(self)weakSelf = self;
    //下拉刷新
    _headerView = [_PendingViewtableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshAction];
    }];
}
#pragma mark 添加下拉刷新动作
- (void)refreshAction {
    __weak UITableView *weakTableView = _PendingViewtableView;
    __weak FCXRefreshHeaderView *weakHeaderView = _headerView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakTableView reloadData];
        [weakHeaderView endRefresh];
    });
}
#pragma mark 设置每组标题名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // 判断是否是搜索结果的tableView
    if (tableView == PendingViewSearchDC.searchResultsTableView) {
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
    return SCREEN_BOUNDS.height / 20;
}

#pragma mark 设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 判断是否是搜索结果的tableView
    if (tableView==PendingViewSearchDC.searchResultsTableView) {
        return PendingViewSearchResult.count;
    }
    return [PendingViewbookinfo.getPendingBooks count];
}
#pragma mark 设置单元格样式和内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Book *books;
    PendingViewcell = [tableView dequeueReusableCellWithIdentifier:@"UIListTableViewCell"];                                                        // 从缓存池中取出cell
    if (!PendingViewcell) {                                                                                                                        // 判断是否能取出cell
        PendingViewcell = [[ListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UIListTableViewCell"];            // 如果cell为空则创建一个新的cell并放入缓存池中
    }else{                                                                                                                                       // 如果cell不为空（注意：以下操作很重要，不然会造成cell数据错乱）
        [PendingViewcell removeCellView];                                                                                                          // 将之前cell界面上的view全部remove掉
        [PendingViewcell initCellView];                                                                                                            // 重新初始化cell上的view
    }
    // 判断是否是搜索结果的tableView
    if (tableView == PendingViewSearchDC.searchResultsTableView) {
        books = PendingViewSearchResult[indexPath.row];
    }else {
        if (_isFirstreview) {
            books = PendingViewbookinfo.getPendingBooks[indexPath.row];
        }else {
            books = PendingViewbookinfo.getRePendingBooks[indexPath.row];
        }
    }
    
    [PendingViewcell setBookInfo:books];
    return PendingViewcell;
}
#pragma mark 添加行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Book *book;
    NSMutableArray *bookArray = [PendingViewbookinfo getPendingBooks];
    book = bookArray[indexPath.row];
    BookDetialViewController *bookDetialVC = [[BookDetialViewController alloc]init:book];
    [self.navigationController pushViewController:bookDetialVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];                                                                                  // 取消选中的状态
}
#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
#pragma mark 选中之前
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [PendingViewSearchBar resignFirstResponder];                                                                                                  // 退出键盘
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
    PendingViewSearchResult = [[NSMutableArray alloc]init];
    [PendingViewbookinfo.getPendingBooks enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Book *book = obj;
        if ([book.bookName.uppercaseString containsString:keyWord.uppercaseString] || [book.bookWriter.uppercaseString containsString:keyWord.uppercaseString]) {
            [PendingViewSearchResult addObject:book];
        }
    }];
    
}



#pragma mark 添加搜索栏
- (void)addSearchBar {
    PendingViewSearchBar = [[UISearchBar alloc]init];
    [PendingViewSearchBar sizeToFit];                                                                                                             // 大小自适应
    PendingViewSearchBar.placeholder = @"搜索";
    PendingViewSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    // 添加搜索框到页眉位置
    PendingViewSearchBar.delegate = self;
    _PendingViewtableView.tableHeaderView = PendingViewSearchBar;
    
    PendingViewSearchDC = [[UISearchDisplayController alloc]initWithSearchBar:PendingViewSearchBar contentsController:self];
    PendingViewSearchDC.delegate = self;
    PendingViewSearchDC.searchResultsDataSource=self;
    PendingViewSearchDC.searchResultsDelegate=self;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
