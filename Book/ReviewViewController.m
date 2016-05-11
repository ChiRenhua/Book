//
//  ReviewViewController.m
//  Book
//
//  Created by Dreamylife on 16/3/18.
//  Copyright © 2016年 software. All rights reserved.
//

#import "ReviewViewController.h"
#import "AppDelegate.h"
#import "ListTableViewCell.h"
#import "GetBookInfo.h"
#import "BookDetialViewController.h"
#import "FCXRefreshFooterView.h"
#import "FCXRefreshHeaderView.h"
#import "UIScrollView+FCXRefresh.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size

@interface ReviewViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate>
@property (nonatomic,strong) UITableView *ReviewViewtableView;
@property (assign,atomic) BOOL isFirstreview;
@property (nonatomic, strong) FCXRefreshHeaderView *headerView;
@end

ListTableViewCell *ReviewViewcell;
AppDelegate *ReviewViewappdelegate;
GetBookInfo *ReviewViewbookinfo;
UISearchBar *ReviewViewSearchBar;                                                                                            // 搜索框
UISearchDisplayController *ReviewViewSearchDC;                                                                               // 搜索框界面控制器
NSMutableArray *ReviewViewSearchResult;                                                                                      // 搜索结果
@implementation ReviewViewController

- (id)init:(BOOL)isFirstReview {
    if (self = [super init]) {
        _isFirstreview = isFirstReview;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"审核中";
    //添加此方法后，页面布局不会自动适应，而是需要手动调节
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _ReviewViewtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 75) style:UITableViewStyleGrouped];                                                                                       // 初始化tableview填充整个屏幕
    _ReviewViewtableView.dataSource = self;                                                                                   // 设置tableview的数据代理
    _ReviewViewtableView.delegate = self;                                                                                     // 设置tableview代理
    [self.view addSubview:_ReviewViewtableView];                                                                              // 将tableview添加到屏幕上
    ReviewViewappdelegate = [[UIApplication sharedApplication]delegate];
    ReviewViewbookinfo = [[GetBookInfo alloc]init];
    [self addSearchBar];                                                                                                      // 添加搜索框
    [self addRefreshView];                                                                                                    // 添加下拉刷新View
    [_headerView startRefresh];

}
#pragma mark 添加下拉刷新View
- (void)addRefreshView {
    __weak __typeof(self)weakSelf = self;
    //下拉刷新
    _headerView = [_ReviewViewtableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshAction];
    }];
}
#pragma mark 添加下拉刷新动作
- (void)refreshAction {
    __weak UITableView *weakTableView = _ReviewViewtableView;
    __weak FCXRefreshHeaderView *weakHeaderView = _headerView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakTableView reloadData];
        [weakHeaderView endRefresh];
    });
}

#pragma mark 设置每组标题名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // 判断是否是搜索结果的tableView
    if (tableView == ReviewViewSearchDC.searchResultsTableView) {
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
    if (tableView==ReviewViewSearchDC.searchResultsTableView) {
        return ReviewViewSearchResult.count;
    }
    return [ReviewViewbookinfo.getPendingBooks count];
}
#pragma mark 设置单元格样式和内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Book *books;
    ReviewViewcell = [tableView dequeueReusableCellWithIdentifier:@"UIListTableViewCell"];                                                        // 从缓存池中取出cell
    if (!ReviewViewcell) {                                                                                                                        // 判断是否能取出cell
        ReviewViewcell = [[ListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UIListTableViewCell"];            // 如果cell为空则创建一个新的cell并放入缓存池中
    }else{                                                                                                                                        // 如果cell不为空（注意：以下操作很重要，不然会造成cell数据错乱）
        [ReviewViewcell removeCellView];                                                                                                          // 将之前cell界面上的view全部remove掉
        [ReviewViewcell initCellView];                                                                                                            // 重新初始化cell上的view
    }
    // 判断是否是搜索结果的tableView
    if (tableView == ReviewViewSearchDC.searchResultsTableView) {
        books = ReviewViewSearchResult[indexPath.row];
    }else {
        if (_isFirstreview) {
            books = ReviewViewbookinfo.getReviewBooks[indexPath.row];
        }else {
            books = ReviewViewbookinfo.getReReviewBooks[indexPath.row];
        }
    }
    [ReviewViewcell setBookInfo:books];
    return ReviewViewcell;
}
#pragma mark 添加行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Book *book;
    NSMutableArray *bookArray = [ReviewViewbookinfo getReviewBooks];
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
    [ReviewViewSearchBar resignFirstResponder];                                                                                                  // 退出键盘
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
    ReviewViewSearchResult = [[NSMutableArray alloc]init];
    [ReviewViewbookinfo.getPendingBooks enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Book *book = obj;
        if ([book.bookName.uppercaseString containsString:keyWord.uppercaseString] || [book.bookWriter.uppercaseString containsString:keyWord.uppercaseString]) {
            [ReviewViewSearchResult addObject:book];
        }
    }];
    
}



#pragma mark 添加搜索栏
- (void)addSearchBar {
    ReviewViewSearchBar = [[UISearchBar alloc]init];
    [ReviewViewSearchBar sizeToFit];                                                                                                             // 大小自适应
    ReviewViewSearchBar.placeholder = @"搜索";
    ReviewViewSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    // 添加搜索框到页眉位置
    ReviewViewSearchBar.delegate = self;
    _ReviewViewtableView.tableHeaderView = ReviewViewSearchBar;
    
    ReviewViewSearchDC = [[UISearchDisplayController alloc]initWithSearchBar:ReviewViewSearchBar contentsController:self];
    ReviewViewSearchDC.delegate = self;
    ReviewViewSearchDC.searchResultsDataSource=self;
    ReviewViewSearchDC.searchResultsDelegate=self;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
