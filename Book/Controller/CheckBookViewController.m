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
#import "UIColor+AppConfig.h"
#import "BookListCache.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size
#define FIRST_CHECKING_BOOK @"firstCheckingBook"
#define FIRST_UNCHECKED_BOOK @"firstUncheckedBook"
#define FIRST_CHECKED_PASS_BOOK @"firstCheckedPassBook"
#define FIRST_CHECKED_UNPASS_BOOK @"firstCheckedUnpassBook"
#define REVIEW_UNCHECKED_BOOK @"reviewUncheckedBook"
#define REVIEW_CHECKING_BOOK @"reviewCheckingBook"
#define REVIEW_CHECKED_PASS_BOOK @"reviewCheckedPassBook"
#define REVIEW_CHECKED_UNPASS_BOOK @"reviewCheckedUnpassBook"

@interface CheckBookViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UITextFieldDelegate>
@property (retain,strong) UITableView *CheckBookViewtableView;
@property(strong, nonatomic) UISearchController *searchController;
@property(retain,nonatomic) MBProgressHUD *mbprogress;
@property(retain,nonatomic) AppDelegate *CheckbookDelegate;
@property(retain,nonatomic) UILabel *noDataLable;
@property(nonatomic,copy) NSString *navigationTitle;
@property(nonatomic,copy) NSString *searchID;
@property(retain,nonatomic) UITextField *searchTextField;
@property(nonatomic,copy) NSString *ViewTypeKey;
@property (nonatomic, strong) NSMutableArray *bookArray;
@end

ListTableViewCell *CheckBookViewcell;
NSMutableArray *searchResult;
int viewcode;
NSString *step;
NSString *bookState;

NSString *bookURL;

@implementation CheckBookViewController

- (id)init:(int)viewCode :(NSString *)title :(NSString *)searchid{
    if (self = [super init]) {
        viewcode = viewCode;
        [self setViewTypeKey];
        searchResult = [[NSMutableArray alloc]init];
        _searchID = [[NSString alloc]init];
        _CheckbookDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        _navigationTitle = [[NSString alloc]init];
        _navigationTitle = title;
        _searchID = searchid;
        [BookInfoModel sharedInstance].updateTV = ^(NSString *state,NSInteger errorcode){
            self.bookArray = [[BookInfoModel sharedInstance]getBookArray];
            if ([self.bookArray count]) {
                [_noDataLable setHidden:YES];
                [_CheckBookViewtableView.tableHeaderView setHidden:NO];
            }else {
                _noDataLable.text = @"暂无数据!";
                [_noDataLable setHidden:NO];
                if (viewcode != keyWordSearchBook) {
                    [_CheckBookViewtableView.tableHeaderView setHidden:YES];
                } 
            }
            
            //如果是审核中页面，才会执行本地数据同步
            if (errorcode == GET_BOOK_FROM_NET_SUCCESS) {
                [[BookReviewModel sharedInstance]synReviewbookDataWitharray:self.bookArray bookState:_ViewTypeKey];
            }
            
            //如果数据拉取失败，则展示缓存数据
            if (errorcode == GET_BOOK_FROM_NET_FAILED) {
                NSMutableArray *cacheArray = [[BookListCache sharedInstance] getBookListFromCache:_ViewTypeKey];
                self.bookArray = cacheArray;
                [_noDataLable setHidden:YES];
                [_CheckBookViewtableView.tableHeaderView setHidden:NO];
                [_CheckBookViewtableView reloadData];
            }
            
            [self.CheckBookViewtableView reloadData];
            [_CheckBookViewtableView.mj_header endRefreshing];
            
            [self showToastWithMessage:state];
        };
        [BookInfoModel sharedInstance].showLoginAlert = ^(){
            [_CheckBookViewtableView.mj_header endRefreshing];
            if (viewcode == searchResultBook) {
                [_CheckBookViewtableView.tableHeaderView setHidden:NO];
            }
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
            [self showToastWithMessage:@"离线模式，加载本地数据!"];
            [self loadLocalData];
        };
        _mbprogress = [[MBProgressHUD alloc]initWithView:self.view];
        _mbprogress.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.bookArray removeAllObjects];
    [searchResult removeAllObjects];

    [self getStep];
    [self getBookURL];

    _CheckBookViewtableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];                 // 初始化tableview填充整个屏幕
    _CheckBookViewtableView.dataSource = self;                                                                                   // 设置tableview的数据代理
    _CheckBookViewtableView.delegate = self;                                                                                     // 设置tableview代理
    
    //关键词搜索页不支持下拉刷新
    if (viewcode != keyWordSearchBook) {
        [self showPullRefreshView];
    }else {
        [self.view addSubview:_CheckBookViewtableView];
    }
    //搜索结果页面不展示搜索框
    if (viewcode != searchResultBook) {
        [self showSearchBar];
    }
    
    [self showNoDataView];

}


- (void)setViewTypeKey {
    switch (viewcode) {
        case firstUncheckedBook:
            _ViewTypeKey = FIRST_UNCHECKED_BOOK;
            break;
        case firstCheckingBook:
            _ViewTypeKey = FIRST_CHECKING_BOOK;
            break;
        case firstCheckedPassBook:
            _ViewTypeKey = FIRST_CHECKED_PASS_BOOK;
            break;
        case firstCheckedUnpassBook:
            _ViewTypeKey = FIRST_CHECKED_UNPASS_BOOK;
            break;
        case reviewUncheckedBook:
            _ViewTypeKey = REVIEW_UNCHECKED_BOOK;
            break;
        case reviewCheckingBook:
            _ViewTypeKey = REVIEW_CHECKING_BOOK;
            break;
        case reviewCheckedPassBook:
            _ViewTypeKey = REVIEW_CHECKED_PASS_BOOK;
            break;
        case reviewCheckedUnpassBook:
            _ViewTypeKey = REVIEW_CHECKED_UNPASS_BOOK;
            break;
        default:
            break;
    }
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
    }else if(viewcode == searchResultBook) {
        self.navigationItem.title = _navigationTitle;
        bookURL = [NSString stringWithFormat:@"getSearchBook.serv?username=%@&sessionid=%@&categorySecondId=%@",[[UserInfoModel sharedInstance]getUserName],[[UserInfoModel sharedInstance]getUserSessionid],_searchID];
    }else if (viewcode == keyWordSearchBook) {
        self.navigationItem.title = _navigationTitle;
    }else if (viewcode == willExpiredBook) {
        self.navigationItem.title = @"即将过期";
        bookURL = [NSString stringWithFormat:@"getMatureRemind.serv?username=%@&sessionid=%@&categorySecondId=%@",[[UserInfoModel sharedInstance]getUserName],[[UserInfoModel sharedInstance]getUserSessionid],_searchID];
    }
}
#pragma mark - 无数据View
- (void)showNoDataView {
    _noDataLable = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width/2 - 100, SCREEN_BOUNDS.height/2 - 25, 200, 50)];
    _noDataLable.textColor = [UIColor grayColor];
    _noDataLable.text = @"暂无数据!";
    _noDataLable.textColor = [UIColor bookLableColor];
    _noDataLable.textAlignment = NSTextAlignmentCenter;
    _noDataLable.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:_noDataLable];
    
    if (self.bookArray.count) {
        [_noDataLable setHidden:YES];
    }else {
        [_noDataLable setHidden:NO];
    }
}
#pragma mark - 搜索框
- (void)showSearchBar {
    //关键词搜索页默认展示搜索框
    if (viewcode == keyWordSearchBook) {
        _searchTextField = [[UITextField alloc]init];
        _searchTextField.frame = CGRectMake(0, 0, 0, 35);                                               // X,Y,长度设置都没用
        _searchTextField.backgroundColor = [UIColor whiteColor];
        _searchTextField.font = [UIFont systemFontOfSize:15];                                          // 设置文字大小
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;                            // 设置删除按钮出现时间
        _searchTextField.borderStyle = UITextBorderStyleRoundedRect;                                   // 设置边框样式
        _searchTextField.placeholder = @"请输入搜索内容";                                                // 添加默认文字，点击消失
        _searchTextField.returnKeyType = UIReturnKeySearch;                                            // return键样式更改
        _searchTextField.textAlignment = NSTextAlignmentCenter;                                        //文字居中
        _searchTextField.delegate = self;
        _CheckBookViewtableView.tableHeaderView = _searchTextField;
    }else{
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        //搜索结果处理函数代理
        _searchController.searchResultsUpdater = self;
        //是否显示背景
        _searchController.dimsBackgroundDuringPresentation = false;
        [_searchController.searchBar sizeToFit];
        //修改searchBar的默认文字
        _searchController.searchBar.placeholder = @"搜索";
        //修改取消按钮的颜色
        _searchController.searchBar.tintColor = [UIColor bookLableColor];
        //修改“Cancle按钮的默认文字”
        [_searchController.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
        //去掉搜索框边界线，背景图
        [_searchController.searchBar setBackgroundImage:[[UIImage alloc] init]];
        //将搜索框添加到tableHeaderView中
        _CheckBookViewtableView.tableHeaderView = self.searchController.searchBar;
        if (self.bookArray.count) {
            [_CheckBookViewtableView.tableHeaderView setHidden:NO];
        }else{
            [_CheckBookViewtableView.tableHeaderView setHidden:YES];
        }
        
    }
    
}
#pragma mark 重置键盘return按钮事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (![_searchTextField.text isEqualToString:@""]) {
        _noDataLable.text = @"正在搜索... ...";
        _noDataLable.textColor = [UIColor bookLableColor];
        NSString *bookURL = [NSString stringWithFormat:@"getKeySrarch.serv?username=%@&sessionid=%@&key=%@&value=%@",[[UserInfoModel sharedInstance]getUserName],[[UserInfoModel sharedInstance]getUserSessionid],_searchID,_searchTextField.text];
        [[BookInfoModel sharedInstance]getSearchResultWithURL:bookURL];
        [_searchTextField resignFirstResponder];
    }else {
        [self showToastWithMessage:@"请输入搜索内容!"];
    }
    return YES;
}

#pragma mark 滑动隐藏键盘
- (void)scrollViewWillBeginDragging:(UITableView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - 下拉刷新View
- (void)showPullRefreshView {
    // 下拉刷新
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _CheckBookViewtableView.mj_header = refreshHeader;
    refreshHeader.automaticallyChangeAlpha = YES;
    [self.view addSubview:_CheckBookViewtableView];
    
    // 检查是否有缓存，如果有读缓存数据，没有的话执行刷新操作
    NSMutableArray *cacheArray = [[BookListCache sharedInstance] getBookListFromCache:_ViewTypeKey];
    if (cacheArray.count) {
        self.bookArray = cacheArray;
        [_CheckBookViewtableView reloadData];
    }else {
        [_CheckBookViewtableView.mj_header beginRefreshing];
    }
    
}

#pragma mark - 下拉刷新执行函数
- (void)loadData {
    [self getStep];
    [self getBookURL];
    if (viewcode == searchResultBook) {
        [[BookInfoModel sharedInstance]getSearchResultWithURL:bookURL];
    }else if (viewcode == willExpiredBook) {
        [[BookInfoModel sharedInstance]getwillExpiredBookDataWithURL:bookURL];
    }else {
        [[BookInfoModel sharedInstance]getBookDataWithURL:bookURL bookState:bookState];
    }
}

#pragma mark - searchController delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [searchResult removeAllObjects];
    NSString *keyWord = [searchController .searchBar text];
    [self.bookArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
    if ([self.bookArray count]) {
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
    return [self.bookArray count];
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
            books = self.bookArray[indexPath.row];
        }else {
            books = self.bookArray[indexPath.row];
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
        book = self.bookArray[indexPath.row];
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
    
    //判断是初审还是复审的审核中页面
    if (viewcode == firstCheckingBook) {
        array = [[BookReviewModel sharedInstance]getReviewBookFromLocal:FIRST_CHECKING_BOOK];
    }else if (viewcode == reviewCheckingBook) {
        array = [[BookReviewModel sharedInstance]getReviewBookFromLocal:REVIEW_CHECKING_BOOK];
    }
    
    for (int i = 0; i < array.count; i++) {
        Book *book = [[Book alloc]initWithDictionary:array[i]];
        book.bookState = array[i][@"bookState"];
        [barray addObject:book];
    }
    self.bookArray = barray;
    if ([self.bookArray count]) {
        [_noDataLable setHidden:YES];
        [_CheckBookViewtableView.tableHeaderView setHidden:NO];
    }else {
        [_noDataLable setHidden:NO];
        [_CheckBookViewtableView.tableHeaderView setHidden:YES];
    }
    [_CheckBookViewtableView reloadData];
}
//展示Toast
- (void)showToastWithMessage:(NSString *)msg{
    _mbprogress.mode = MBProgressHUDModeText;                                                       // 设置toast的样式为文字
    _mbprogress.label.text = NSLocalizedString(msg, @"HUD message title");                          // 设置toast上的文字
    [self.view addSubview:_mbprogress];                                                             // 将toast添加到view中
    [self.view bringSubviewToFront:_mbprogress];                                                    // 让toast显示在view的最前端
    [_mbprogress showAnimated:YES];                                                                 // 显示toast
    [_mbprogress hideAnimated:YES afterDelay:1.0];                                                  // 1.0秒后销毁toast
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
