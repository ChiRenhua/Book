//
//  UIViewController+SearchViewController.m
//  Book
//
//  Created by Dreamylife on 16/4/17.
//  Copyright © 2016年 software. All rights reserved.
//

#import "SearchViewController.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size
#define ROW_HIGHT SCREEN_BOUNDS.height / 9

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (copy,nonatomic) NSMutableArray *searchArray;
@property (nonatomic,strong) UITableView *tableView;

@end


@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"搜索";
    _searchArray = [[NSMutableArray alloc]initWithObjects:@"中图分类法", @"科图分类法", @"杜威十进制分类法", @"美国国会图书馆分类法",nil];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark 设置分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
#pragma mark 设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    return @"分类";
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