//
//  UIViewController+SearchViewController.m
//  Book
//
//  Created by Dreamylife on 16/4/17.
//  Copyright © 2016年 software. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchModel.h"
#import "UserInfoModel.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size
#define ROW_HIGHT SCREEN_BOUNDS.height / 9

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating>
@property (copy,nonatomic) NSMutableArray *searchArray;
@property (nonatomic,strong) UITableView *tableView;
@property(strong, nonatomic) UISearchController *searchController;
@property(strong, nonatomic) NSMutableArray *searchResult;
@property (nonatomic, retain) UIActivityIndicatorView *IndicatorView;
@property (nonatomic, retain) UILabel *errorLable;
@end


@implementation SearchViewController

- (id)init {
    if (self = [super init]) {
        [SearchModel sharedInstance].successLoadSearchData = ^(){
            [_IndicatorView stopAnimating];
            [_errorLable setHidden:YES];
            [_tableView.tableHeaderView setHidden:NO];
            [_tableView reloadData];
        };
        [SearchModel sharedInstance].failedLoadSearchData = ^(){
            [_IndicatorView stopAnimating];
            [_errorLable setHidden:NO];
            [_tableView.tableHeaderView setHidden:YES];
        };
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"搜索";
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self showSearchBar];
    [self getSearchData];
    [self addIndicatorView];
    [self addErrorLable];
}

- (void)getSearchData {
    NSString *url = [NSString stringWithFormat:@"getSearchTree.serv?userid=%@",[[UserInfoModel sharedInstance]getUserID]];
    [[SearchModel sharedInstance] getSearchDataWithURL:url];
    [_errorLable setHidden:YES];
    [_IndicatorView startAnimating];
}

// 数据加载失败lable
- (void)addErrorLable {
    _errorLable = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_BOUNDS.height/2 - 25, SCREEN_BOUNDS.width, 50)];
    _errorLable.textColor = [UIColor grayColor];
    _errorLable.text = @"数据加载失败\n点击重新加载!";
    _errorLable.numberOfLines = 0;
    _errorLable.textAlignment = NSTextAlignmentCenter;
    _errorLable.font = [UIFont systemFontOfSize:15];
    _errorLable.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getSearchData)];
    [_errorLable addGestureRecognizer:tapGesture];
    [self.view addSubview:_errorLable];
    [_errorLable setHidden:YES];
}
// 添加菊花
- (void)addIndicatorView {
    _IndicatorView = [[UIActivityIndicatorView alloc]init];
    _IndicatorView.center = CGPointMake(SCREEN_BOUNDS.width/2, SCREEN_BOUNDS.height/2);
    _IndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_IndicatorView];
    [_IndicatorView startAnimating];
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
    _searchController.searchBar.placeholder = @"关键字搜索";
    //修改“Cancle按钮的默认文字”
    [_searchController.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
    //将搜索框添加到tableHeaderView中
    _tableView.tableHeaderView = self.searchController.searchBar;
    [_tableView.tableHeaderView setHidden:YES];
}

#pragma mark - searchController delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    //搜索结果处理
    [_tableView reloadData];
}

#pragma mark 设置分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
#pragma mark 设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.searchController isActive]) {
        return _searchResult.count;
    }
    return _searchArray.count;
}
#pragma mark 设置单元格样式和内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *SearchViewcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    UIImageView *searchImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search"]];
    searchImageView.frame = CGRectMake(15, 20, ROW_HIGHT - 40, ROW_HIGHT - 40);
    searchImageView.contentMode = UIViewContentModeScaleAspectFit;
    [SearchViewcell.contentView addSubview:searchImageView];
    
    UIImageView *rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_black.png"]];
    rightImageView.frame = CGRectMake(SCREEN_BOUNDS.width / 10 * 9, 23, ROW_HIGHT - 46, ROW_HIGHT - 46);
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [SearchViewcell.contentView addSubview:rightImageView];
    // 搜索方法名字
    UILabel *searchName = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width / 5, ROW_HIGHT / 2 - 8.5, SCREEN_BOUNDS.width - 90, 20)];
    searchName.text = _searchArray[indexPath.row];
    searchName.font = [UIFont systemFontOfSize:17];
    searchName.textColor = [UIColor blackColor];
    [SearchViewcell.contentView addSubview:searchName];
    
    return SearchViewcell;
}
#pragma mark 设置每组标题名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self.searchController isActive]) {
        return @"搜索结果";
    }
    if (_searchArray.count != 0 ) {
        return @"分类搜索";
    }
    return nil;
}
#pragma mark 设置分组标题内容高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat headerHight = SCREEN_BOUNDS.height/20;
    if (section == 0) {
        return headerHight;
    }
    return 0;
}
#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HIGHT;
}
#pragma mark 行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];                                                                                  // 取消选中的状态
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end