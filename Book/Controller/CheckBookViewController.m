//
//  CheckBookViewController.m
//  Book
//
//  Created by Dreamylife on 16/3/18.
//  Copyright © 2016年 software. All rights reserved.
//

#import "CheckBookViewController.h"
#import "ListTableViewCell.h"
#import "BookDetialViewController.h"
#import "BookInfoModel.h"
#import "UserInfoModel.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "BookReviewModel.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size

@interface CheckBookViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating>
@property (retain,strong) UITableView *CheckBookViewtableView;
@property(strong, nonatomic) UISearchController *searchController;
@property(retain,nonatomic) MBProgressHUD *mbprogress;
@property(retain,nonatomic) AppDelegate *CheckbookDelegate;
@property(retain,nonatomic) UILabel *noDataLable;
@end

ListTableViewCell *CheckBookViewcell;
NSMutableArray *searchResult;                                                                                      // 搜索结果
int viewcode;
NSString *step;
NSString *bookState;
NSMutableArray *bookArray;
NSString *bookURL;

@implementation CheckBookViewController

- (id)init:(int)viewCode {
    if (self = [super init]) {
        viewcode = viewCode;
        searchResult = [[NSMutableArray alloc]init];
        _CheckbookDelegate = [[UIApplication sharedApplication]delegate];
        _mbprogress = [[MBProgressHUD alloc]initWithView:self.view];
        _mbprogress.delegate = self;
        [BookInfoModel sharedInstance].updateTV = ^(NSString *state){
            bookArray = [[BookInfoModel sharedInstance]getBookArray];
            if ([bookArray count]) {
                [_noDataLable setHidden:YES];
                [_CheckBookViewtableView.tableHeaderView setHidden:NO];
            }else {
                [_noDataLable setHidden:NO];
                [_CheckBookViewtableView.tableHeaderView setHidden:YES];
            }
            [self.CheckBookViewtableView reloadData];
            [_CheckBookViewtableView.mj_header endRefreshing];
            
            _mbprogress.mode = MBProgressHUDModeText;                                                       // 设置toast的样式为文字
            _mbprogress.label.text = NSLocalizedString(state, @"HUD message title");                        // 设置toast上的文字
            [self.view addSubview:_mbprogress];                                                             // 将toast添加到view中
            [self.view bringSubviewToFront:_mbprogress];                                                    // 让toast显示在view的最前端
            [_mbprogress showAnimated:YES];                                                                 // 显示toast
            [_mbprogress hideAnimated:YES afterDelay:1.0];                                                  // 1.5秒后销毁toast
        };
        [BookInfoModel sharedInstance].showLoginAlert = ^(){
            [_CheckBookViewtableView.mj_header endRefreshing];
            UIAlertController *loginAlert = [UIAlertController alertControllerWithTitle:@"错误!" message:@"登录态失效，请重新登陆!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
                [self presentViewController:_CheckbookDelegate.loginVC animated:YES completion:nil];
            }];
            UIAlertAction *calcleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                
            }];
            [loginAlert addAction:loginAction];
            [loginAlert addAction:calcleAction];
            [self presentViewController:loginAlert animated:YES completion:nil];
        };
        [BookInfoModel sharedInstance].offlineMode = ^() {
            [_CheckBookViewtableView.mj_header endRefreshing];
            
            _mbprogress.mode = MBProgressHUDModeText;                                                       // 设置toast的样式为文字
            _mbprogress.label.text = NSLocalizedString(@"离线模式，加载本地数据!", @"HUD message title");       // 设置toast上的文字
            [self.view addSubview:_mbprogress];                                                             // 将toast添加到view中
            [self.view bringSubviewToFront:_mbprogress];                                                    // 让toast显示在view的最前端
            [_mbprogress showAnimated:YES];                                                                 // 显示toast
            [_mbprogress hideAnimated:YES afterDelay:1.0];                                                  // 1.5秒后销毁toast
            [self loadLocalData];
        };
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [bookArray removeAllObjects];
    [searchResult removeAllObjects];

    [self getStep];
    [self getBookURL];

    _CheckBookViewtableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];                 // 初始化tableview填充整个屏幕
    _CheckBookViewtableView.dataSource = self;                                                                                   // 设置tableview的数据代理
    _CheckBookViewtableView.delegate = self;                                                                                     // 设置tableview代理
    
    [self showPullRefreshView];
    [self showSearchBar];
    [self showNoDataView];
}

- (void)getStep {
    if (viewcode == firstUncheckedBook || viewcode == firstCheckingBook || viewcode == firstCheckedPassBook || viewcode == firstCheckedUnpassBook) {
        step = @"0";
    }else if(viewcode == reviewUncheckedBook || viewcode == reviewCheckingBook || viewcode == reviewCheckedPassBook || viewcode == reviewCheckedUnpassBook) {
        step = @"1";
    }
}

- (void)getBookURL {
    if (viewcode == firstUncheckedBook || viewcode == reviewUncheckedBook) {
        self.navigationItem.title = @"待审核";
        bookState = @"待审核";
        bookURL = [NSString stringWithFormat:@"getUnExamineList.serv?username=%@&sessionid=%@&step=%@",[[UserInfoModel sharedInstance]getUserName],[[UserInfoModel sharedInstance]getUserSessionid],step];
    }else if(viewcode == firstCheckingBook || viewcode == reviewCheckingBook) {
        self.navigationItem.title = @"审核中";
        bookState = @"审核中";
        bookURL = [NSString stringWithFormat:@"getExaminingList.serv?username=%@&sessionid=%@&step=%@",[[UserInfoModel sharedInstance]getUserName],[[UserInfoModel sharedInstance]getUserSessionid],step];
    }else if(viewcode == firstCheckedPassBook || viewcode == reviewCheckedPassBook) {
        self.navigationItem.title = @"已通过";
        bookState = @"已通过";
        bookURL = [NSString stringWithFormat:@"getPassdList.serv?username=%@&sessionid=%@&step=%@",[[UserInfoModel sharedInstance]getUserName],[[UserInfoModel sharedInstance]getUserSessionid],step];
    }else if(viewcode == firstCheckedUnpassBook || viewcode == reviewCheckedUnpassBook) {
        self.navigationItem.title = @"未通过";
        bookState = @"未通过";
        bookURL = [NSString stringWithFormat:@"getNotPassdList.serv?username=%@&sessionid=%@&step=%@",[[UserInfoModel sharedInstance]getUserName],[[UserInfoModel sharedInstance]getUserSessionid],step];
    }
}
#pragma mark - 无数据View
- (void)showNoDataView {
    _noDataLable = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width/2 - 100, SCREEN_BOUNDS.height/2 - 25, 200, 50)];
    _noDataLable.textColor = [UIColor grayColor];
    _noDataLable.text = @"暂无数据!";
    _noDataLable.textAlignment = NSTextAlignmentCenter;
    _noDataLable.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:_noDataLable];
}
#pragma mark - 搜索框
- (void)showSearchBar {
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    //搜索结果处理函数代理
    _searchController.searchResultsUpdater = self;
    //是否显示背景
    _searchController.dimsBackgroundDuringPresentation = false;
    [_searchController.searchBar sizeToFit];
    //修改searchBar的默认文字
    _searchController.searchBar.placeholder = @"搜索";
    //修改“Cancle按钮的默认文字”
    [_searchController.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
    //将搜索框添加到tableHeaderView中
    _CheckBookViewtableView.tableHeaderView = self.searchController.searchBar;
    [_CheckBookViewtableView.tableHeaderView setHidden:YES];
}
#pragma mark - 下拉刷新View
- (void)showPullRefreshView {
    // 下拉刷新
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _CheckBookViewtableView.mj_header = refreshHeader;
    refreshHeader.automaticallyChangeAlpha = YES;
    [self.view addSubview:_CheckBookViewtableView];                                                                              // 将tableview添加到屏幕上
    [_CheckBookViewtableView.mj_header beginRefreshing];
}

#pragma mark - 下拉刷新执行函数
- (void)loadData {
    [self getStep];
    [self getBookURL];
    [[BookInfoModel sharedInstance]getBookDataWithURL:bookURL bookState:bookState];
}

#pragma mark - searchController delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [searchResult removeAllObjects];
    NSString *keyWord = [searchController .searchBar text];
    [bookArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Book *book = obj;
        if ([book.bookName.uppercaseString containsString:keyWord.uppercaseString] || [book.authorName.uppercaseString containsString:keyWord.uppercaseString]) {
            [searchResult addObject:book];
        }
    }];
    [_CheckBookViewtableView reloadData];
}
#pragma mark 设置每组标题名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // 判断是否是搜索结果的tableView
    if ([self.searchController isActive]) {
        return @"搜索结果";
    }
    if ([bookArray count]) {
        return @"书籍信息";
    }
    return nil;
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
    if ([self.searchController isActive]) {
        return searchResult.count;
    }
    return [bookArray count];
}
#pragma mark 设置单元格样式和内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Book *books;
    CheckBookViewcell = [tableView dequeueReusableCellWithIdentifier:@"UIListTableViewCell"];                                                        // 从缓存池中取出cell
    if (!CheckBookViewcell) {                                                                                                                        // 判断是否能取出cell
        CheckBookViewcell = [[ListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UIListTableViewCell"];            // 如果cell为空则创建一个新的cell并放入缓存池中
    }else{                                                                                                                                           // 如果cell不为空（注意：以下操作很重要，不然会造成cell数据错乱）
        [CheckBookViewcell removeCellView];                                                                                                          // 将之前cell界面上的view全部remove掉
        [CheckBookViewcell initCellView];                                                                                                            // 重新初始化cell上的view
    }
    // 判断是否是搜索结果的tableView
    if ([self.searchController isActive]) {
        books = searchResult[indexPath.row];
    }else {
        if (viewcode) {
            books = bookArray[indexPath.row];
        }else {
            books = bookArray[indexPath.row];
        }
    }
    
    [CheckBookViewcell setBookInfo:books];
    return CheckBookViewcell;
}
#pragma mark 添加行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Book *book;
    if ([_searchController isActive]) {
        book = searchResult[indexPath.row];
    }else {
        book = bookArray[indexPath.row];
    }
    BookDetialViewController *bookDetialVC = [[BookDetialViewController alloc]init:book step:step];
    [self.navigationController pushViewController:bookDetialVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];                                                                                  // 取消选中的状态
}
#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

#pragma mark 重写状态样式方法
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
// 加载本地数据
- (void)loadLocalData {
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSMutableArray *barray = [[NSMutableArray alloc]init];
    array = [[BookReviewModel sharedInstance]getReviewBookFromLocal];
    for (int i = 0; i < array.count; i++) {
        Book *book = [[Book alloc]initWithDictionary:array[i]];
        book.bookState = array[i][@"bookState"];
        [barray addObject:book];
    }
    bookArray = barray;
    if ([bookArray count]) {
        [_noDataLable setHidden:YES];
        [_CheckBookViewtableView.tableHeaderView setHidden:NO];
    }else {
        [_noDataLable setHidden:NO];
        [_CheckBookViewtableView.tableHeaderView setHidden:YES];
    }
    [_CheckBookViewtableView reloadData];
}
// 离开页面销毁搜索框
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
