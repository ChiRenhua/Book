//
//  SecondViewController.m
//  Book
//
//  Created by Dreamylife on 16/3/18.
//  Copyright © 2016年 software. All rights reserved.
//

#import "SecondViewController.h"
#import "TableScrollViewCell.h"
#import "AppDelegate.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size

@interface SecondViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

UITableView *secondTableView;
TableScrollViewCell *scrollViewCell;
AppDelegate *secondAppdelegate;

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"审核中";
    secondTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.width, SCREEN_BOUNDS.height-25) style:UITableViewStyleGrouped];
    secondTableView.delegate = self;
    secondTableView.dataSource = self;
    [self.view addSubview:secondTableView];
    
    secondAppdelegate = [[UIApplication sharedApplication]delegate];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    scrollViewCell = [[TableScrollViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil]; 
    return scrollViewCell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"审核列表";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
