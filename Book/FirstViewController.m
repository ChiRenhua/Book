//
//  FirstViewController.m
//  Book
//
//  Created by Dreamylife on 16/3/18.
//  Copyright © 2016年 software. All rights reserved.
//

#import "FirstViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ListTableViewCell.h"
#import "GetBookInfo.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate>
@property (nonatomic,strong) UITableView *firstViewtableView;
@end

ListTableViewCell *firstViewcell;
AppDelegate *firstViewappdelegate;
GetBookInfo *firstViewbookinfo;
UISearchBar *firstViewSearchBar;                                                                                            // 搜索框
UISearchDisplayController *firstViewSearchDC;                                                                               // 搜索框界面控制器
NSMutableArray *firstViewSearchResult;                                                                                      // 搜索结果

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"待审核";
    _firstViewtableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];                 // 初始化tableview填充整个屏幕
    _firstViewtableView.dataSource = self;                                                                                   // 设置tableview的数据代理
    _firstViewtableView.delegate = self;                                                                                     // 设置tableview代理
    [self.view addSubview:_firstViewtableView];                                                                              // 将tableview添加到屏幕上
    firstViewappdelegate = [[UIApplication sharedApplication]delegate];
    firstViewbookinfo = [[GetBookInfo alloc]init];
    [self addSearchBar];                                                                                                     // 添加搜索框
}

- (void)viewWillAppear:(BOOL)animated {
    [self verificationLogin];                                                                                                // 进行登录验证
}

#pragma mark 验证登陆
- (void)verificationLogin {
    // 从plist文件中读取用户数据
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"userInfo.plist"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    NSString *userName = [userInfo objectForKey:@"userName"];
    NSString *userPassword = [userInfo objectForKey:@"userPassword"];
    // 如果用户信息核对错误，则弹出登陆界面
    if(![userName isEqualToString:@"Martin"] && ![userPassword isEqualToString:@"123456"]) {
        [self presentViewController:firstViewappdelegate.loginVC animated:YES completion:nil];
    }
    
}
#pragma mark 设置每组标题名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // 判断是否是搜索结果的tableView
    if (tableView == firstViewSearchDC.searchResultsTableView) {
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
    if (tableView==firstViewSearchDC.searchResultsTableView) {
        return firstViewSearchResult.count;
    }
    return [firstViewbookinfo.getPendingBooks count];
}
#pragma mark 设置单元格样式和内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Book *books;
    firstViewcell = [tableView dequeueReusableCellWithIdentifier:@"UIListTableViewCell"];                                                        // 从缓存池中取出cell
    if (!firstViewcell) {                                                                                                                        // 判断是否能取出cell
        firstViewcell = [[ListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UIListTableViewCell"];            // 如果cell为空则创建一个新的cell并放入缓存池中
    }else{                                                                                                                                       // 如果cell不为空（注意：以下操作很重要，不然会造成cell数据错乱）
        [firstViewcell removeCellView];                                                                                                          // 将之前cell界面上的view全部remove掉
        [firstViewcell initCellView];                                                                                                            // 重新初始化cell上的view
    }
    // 判断是否是搜索结果的tableView
    if (tableView == firstViewSearchDC.searchResultsTableView) {
        books = firstViewSearchResult[indexPath.row];
    }else {
        books = firstViewbookinfo.getPendingBooks[indexPath.row];
    }
    
    [firstViewcell setBookInfo:books];
    return firstViewcell;
}
#pragma mark 添加行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Book *book;
    NSMutableArray *bookArray = [firstViewbookinfo getPendingBooks];
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
    [firstViewSearchBar resignFirstResponder];                                                                                                  // 退出键盘
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
    firstViewSearchResult = [[NSMutableArray alloc]init];
    [firstViewbookinfo.getPendingBooks enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Book *book = obj;
        if ([book.bookName.uppercaseString containsString:keyWord.uppercaseString] || [book.bookWriter.uppercaseString containsString:keyWord.uppercaseString]) {
            [firstViewSearchResult addObject:book];
        }
    }];
    
}



#pragma mark 添加搜索栏
- (void)addSearchBar {
    firstViewSearchBar = [[UISearchBar alloc]init];
    [firstViewSearchBar sizeToFit];                                                                                                             // 大小自适应
    firstViewSearchBar.placeholder = @"搜索";
    firstViewSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    // 添加搜索框到页眉位置
    firstViewSearchBar.delegate = self;
    _firstViewtableView.tableHeaderView = firstViewSearchBar;
    
    firstViewSearchDC = [[UISearchDisplayController alloc]initWithSearchBar:firstViewSearchBar contentsController:self];
    firstViewSearchDC.delegate = self;
    firstViewSearchDC.searchResultsDataSource=self;
    firstViewSearchDC.searchResultsDelegate=self;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
