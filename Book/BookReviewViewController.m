//
//  BookReviewViewController.m
//  Book
//
//  Created by Dreamylife on 16/4/20.
//  Copyright © 2016年 software. All rights reserved.
//

#import "BookReviewViewController.h"
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size
@interface BookReviewViewController ()
@property (retain,nonatomic) Book *detialBook;
@end

@implementation BookReviewViewController

- (id)init:(Book *) book{
    if (self = [super init]) {
        _detialBook = [[Book alloc]init];
        _detialBook = book;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // 添加NavigationBar
    [self setNavigationBar];
    
}

- (void)setNavigationBar {
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.width, 65)];
    navigationBar.backgroundColor = [UIColor whiteColor];
    //创建UINavigationItem
    UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"审核"];
    [self.view addSubview: navigationBar];
    //创建UIBarButton 可根据需要选择适合自己的样式
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(commit)];
    //设置barbutton
    navigationBarTitle.leftBarButtonItem = leftBarItem;
    navigationBarTitle.rightBarButtonItem = rightBarItem;
    [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
}
#pragma mark 取消按钮实现
- (void)cancle {
    [self dismissViewControllerAnimated:YES completion:nil];                                                                            // 点击取消撤下界面
}
#pragma mark 提交按钮实现
- (void)commit {
    [self dismissViewControllerAnimated:YES completion:nil];                                                                            // 点击提交撤下界面
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end