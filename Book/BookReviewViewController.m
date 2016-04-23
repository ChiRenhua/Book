//
//  BookReviewViewController.m
//  Book
//
//  Created by Dreamylife on 16/4/20.
//  Copyright © 2016年 software. All rights reserved.
//

#import "BookReviewViewController.h"
#import "RDRStickyKeyboardView.h"
#import "GetBookInfo.h"
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size
@interface BookReviewViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (retain,nonatomic) Book *detialBook;
@property (retain,strong) UITableView *tableView;
@property (nonatomic, strong) RDRStickyKeyboardView *Keyboard;
@property (nonatomic, strong) GetBookInfo *bookInfo;
@property (nonatomic, strong) NSMutableArray *reviewInfoList;
@end

@implementation BookReviewViewController

- (id)init:(Book *) book{
    if (self = [super init]) {
        _detialBook = [[Book alloc]init];
        _bookInfo = [[GetBookInfo alloc]init];
        _reviewInfoList = [[NSMutableArray alloc]init];
        _detialBook = book;
        _reviewInfoList = _bookInfo.getReviewInfoList;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // 添加NavigationBar
    _tableView = [[UITableView alloc]initWithFrame:CGRectNull style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setupKeyboard];
    
}
- (void)setupKeyboard {
    _Keyboard = [[RDRStickyKeyboardView alloc] initWithScrollView:self.tableView];
    __weak __typeof(self)weakSelf = self;
    _Keyboard.cancleBlock = ^(){
        [weakSelf dismissViewControllerAnimated:YES completion:nil];                                                                            // 点击取消撤下界面
    };
    _Keyboard.showAlertViewBlock = ^(UIAlertController *alert) {
        [weakSelf presentViewController:alert animated:YES completion:nil];
    };
    _Keyboard.frame = self.view.bounds;
    _Keyboard.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_Keyboard];
}
#pragma mark 设置每组标题名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"审核意见";
}
#pragma mark 设置分组标题内容高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
#pragma mark 设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _reviewInfoList.count;
}
#pragma mark 设置单元格样式和内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = _reviewInfoList[indexPath.row];
    return cell;
}
#pragma mark 添加行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end