//
//  SearchSonViewController.m
//  Book
//
//  Created by Renhuachi on 16/9/3.
//  Copyright © 2016年 software. All rights reserved.
//

#import "SearchSonViewController.h"
#import "SearchModel.h"
#import "UserInfoModel.h"
#import "CheckBookViewController.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size
#define ROW_HIGHT SCREEN_BOUNDS.height / 10

@interface SearchSonViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (copy,nonatomic) NSMutableArray *searchArray;
@property (nonatomic,strong) UITableView *tableView;
@property(strong, nonatomic) UISearchController *searchController;
@property(strong, nonatomic) NSMutableArray *searchResult;
@property (copy,nonatomic) NSString *navigationTitle;
@property (copy,nonatomic) NSArray *keyworldArray;
@end
NSInteger searchtype;

@implementation SearchSonViewController

- (id)init:(NSMutableArray *)array :(NSString *)title :(NSInteger)searchType{
    if (self = [super init]) {
        _searchArray = [[NSMutableArray alloc]init];
        _searchResult = [[NSMutableArray alloc]init];
        _navigationTitle = [[NSString alloc]init];
        _searchArray = array;
        _navigationTitle = title;
        searchtype = searchType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = _navigationTitle;
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self buildSearchKeywordData];
}

- (void)buildSearchKeywordData {
    _keyworldArray = [[NSArray alloc]initWithObjects:@"按书名搜索",@"按作者搜索",@"按ISBN号搜索", nil];
}

#pragma mark 设置分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
#pragma mark 设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (searchtype == searchKeyword) {
        return 3;
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
    rightImageView.frame = CGRectMake(SCREEN_BOUNDS.width / 10 * 9, ROW_HIGHT/2 - (ROW_HIGHT - 35)/2, ROW_HIGHT - 35, ROW_HIGHT - 35);
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [SearchViewcell.contentView addSubview:rightImageView];
    // 搜索方法名字
    UILabel *searchName = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width / 7, ROW_HIGHT / 2 - 8.5, SCREEN_BOUNDS.width - 2 * ROW_HIGHT + 35, 20)];
    if (searchtype == searchKeyword) {
        searchName.text = _keyworldArray[indexPath.row];
    }else {
        searchName.text = _searchArray[indexPath.row][@"name"];
    }
    searchName.font = [UIFont systemFontOfSize:17];
    searchName.textColor = [UIColor blackColor];
    [SearchViewcell.contentView addSubview:searchName];
    
    return SearchViewcell;
}
#pragma mark 设置每组标题名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_searchArray.count != 0 ) {
        return @"分类搜索";
    }
    if (searchtype == searchKeyword) {
        return @"关键词";
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
    if (searchtype == searchKeyword) {
        switch (indexPath.row) {
            case 0:
                
                break;
            case 1:
                
                break;
            case 2:
                
                break;
            default:
                break;
        }
    }else if(searchtype == classifiedSearch){
        NSMutableArray *array = _searchArray [indexPath.row][@"tree"];
        if (array.count == 0) {
            CheckBookViewController *resultVC = [[CheckBookViewController alloc]init:searchResultBook :_searchArray [indexPath.row][@"name"]:_searchArray [indexPath.row][@"id"]];
            [self.navigationController pushViewController:resultVC animated:YES];
        }else {
            SearchSonViewController *searchVC = [[SearchSonViewController alloc]init:array :_searchArray [indexPath.row][@"name"]:classifiedSearch];
            [self.navigationController pushViewController:searchVC animated:YES];
        }

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
