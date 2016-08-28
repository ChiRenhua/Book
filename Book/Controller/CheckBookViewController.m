//
//  CheckBookViewController.m
//  Book
//
//  Created by Dreamylife on 16/3/18.
//  Copyright © 2016年 software. All rights reserved.
//

#import "CheckBookViewController.h"
#import "AppDelegate.h"
#import "ListTableViewCell.h"
#import "BookDetialViewController.h"
#import "BookInfoModel.h"
#import "UserInfoModel.h"
#import "MJRefreshStateHeader.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size

@interface CheckBookViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate>
@property (retain,strong) UITableView *CheckBookViewtableView;
@end

ListTableViewCell *CheckBookViewcell;
AppDelegate *CheckBookViewappdelegate;
UISearchBar *CheckBookViewSearchBar;                                                                                            // 搜索框
UISearchDisplayController *CheckBookViewSearchDC;                                                                               // 搜索框界面控制器
NSMutableArray *CheckBookViewSearchResult;                                                                                      // 搜索结果
int viewcode;
NSString *step;
NSString *bookState;
NSMutableArray *bookArray;

@implementation CheckBookViewController

- (id)init:(int)viewCode {
    if (self = [super init]) {
        viewcode = viewCode;
        [BookInfoModel sharedInstance].updateTV = ^(){
            bookArray = [[BookInfoModel sharedInstance]getBookArray];
            [self.CheckBookViewtableView reloadData];
            [_CheckBookViewtableView.mj_header endRefreshing];
        };
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (viewcode == firstUncheckedBook || viewcode == reviewUncheckedBook) {
        self.navigationItem.title = @"待审核";
        bookState = @"待审核";
    }else if(viewcode == firstCheckingBook || viewcode == reviewCheckingBook) {
        self.navigationItem.title = @"审核中";
        bookState = @"审核中";
    }else if(viewcode == firstCheckedPassBook || viewcode == reviewCheckedPassBook) {
        self.navigationItem.title = @"已通过";
        bookState = @"已通过";
    }else if(viewcode == firstCheckedUnpassBook || viewcode == reviewCheckedUnpassBook) {
        self.navigationItem.title = @"未通过";
        bookState = @"未通过";
    }
    
     //添加此方法后，页面布局不会自动适应，而是需要手动调节
        if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
        {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    _CheckBookViewtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 75) style:UITableViewStyleGrouped];                                                                                          // 初始化tableview填充整个屏幕
    _CheckBookViewtableView.dataSource = self;                                                                                   // 设置tableview的数据代理
    _CheckBookViewtableView.delegate = self;                                                                                     // 设置tableview代理
    [self.view addSubview:_CheckBookViewtableView];                                                                              // 将tableview添加到屏幕上
    CheckBookViewappdelegate = [[UIApplication sharedApplication]delegate];
    [self addSearchBar];                                                                                                       // 添加搜索框
    
    if (viewcode == firstUncheckedBook) {
        step = @"0";
    }else if(viewcode == reviewUncheckedBook) {
        step = @"1";
    }
    MJRefreshStateHeader *refreshHeader = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    refreshHeader.automaticallyChangeAlpha = YES;
    _CheckBookViewtableView.mj_header = refreshHeader;
    [[BookInfoModel sharedInstance]getBookDataWithUsername:[[UserInfoModel sharedInstance]getUserName] Sessionid:[[UserInfoModel sharedInstance]getUserSessionid] step:step bookState:bookState];
}
- (void)loadData {
    [[BookInfoModel sharedInstance]getBookDataWithUsername:[[UserInfoModel sharedInstance]getUserName] Sessionid:[[UserInfoModel sharedInstance]getUserSessionid] step:step bookState:bookState];
}
#pragma mark 设置每组标题名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // 判断是否是搜索结果的tableView
    if (tableView == CheckBookViewSearchDC.searchResultsTableView) {
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
    if (tableView==CheckBookViewSearchDC.searchResultsTableView) {
        return CheckBookViewSearchResult.count;
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
    if (tableView == CheckBookViewSearchDC.searchResultsTableView) {
        books = CheckBookViewSearchResult[indexPath.row];
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
    [CheckBookViewSearchBar resignFirstResponder];                                                                                                  // 退出键盘
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
    CheckBookViewSearchResult = [[NSMutableArray alloc]init];
    [bookArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Book *book = obj;
        if ([book.bookName.uppercaseString containsString:keyWord.uppercaseString] || [book.authorName.uppercaseString containsString:keyWord.uppercaseString]) {
            [CheckBookViewSearchResult addObject:book];
        }
    }];
    
}



#pragma mark 添加搜索栏
- (void)addSearchBar {
    CheckBookViewSearchBar = [[UISearchBar alloc]init];
    [CheckBookViewSearchBar sizeToFit];                                                                                                             // 大小自适应
    CheckBookViewSearchBar.placeholder = @"搜索";
    CheckBookViewSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    // 添加搜索框到页眉位置
    CheckBookViewSearchBar.delegate = self;
    _CheckBookViewtableView.tableHeaderView = CheckBookViewSearchBar;
    
    CheckBookViewSearchDC = [[UISearchDisplayController alloc]initWithSearchBar:CheckBookViewSearchBar contentsController:self];
    CheckBookViewSearchDC.delegate = self;
    CheckBookViewSearchDC.searchResultsDataSource=self;
    CheckBookViewSearchDC.searchResultsDelegate=self;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
