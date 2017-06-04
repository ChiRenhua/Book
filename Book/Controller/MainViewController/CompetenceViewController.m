//
//  CompetenceViewController.m
//  Book
//
//  Created by 迟人华 on 2017/6/4.
//  Copyright © 2017年 software. All rights reserved.
//

#import "CompetenceViewController.h"
#import "UserInfoModel.h"

@interface CompetenceViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) __block NSMutableArray *noCompetenceArray;

@end

@implementation CompetenceViewController

- (id)init {
    if (self = [super init]) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        self.navigationItem.title = @"权限";
        
        [self setData];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

#pragma mark - tableViewDelegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"拥有的权限";
        case 1:
            return @"未拥有的权限";
        default:
            break;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [[UserInfoModel sharedInstance] getUserCompetence].count;
        case 1:
            return [[UserInfoModel sharedInstance] getCompetenceDictionnary].count - [[UserInfoModel sharedInstance] getUserCompetence].count;
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"compentenceCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"compentenceCell"];
    }
    
    switch (indexPath.section) {
        case 0: {
            NSNumber *key = [[UserInfoModel sharedInstance] getUserCompetence] [indexPath.row];
            cell.textLabel.text = [[[UserInfoModel sharedInstance] getCompetenceDictionnary] objectForKey:key];
            cell.textLabel.textColor = [UIColor blackColor];
            break;
        }
        case 1: {
            NSNumber *key = self.noCompetenceArray [indexPath.row];
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.text = [[[UserInfoModel sharedInstance] getCompetenceDictionnary] objectForKey:key];
            break;
        }
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (void)setData {
    NSArray *competenceArray = [[UserInfoModel sharedInstance] getUserCompetence];
    NSMutableDictionary *totleCompetenceDic = [[UserInfoModel sharedInstance] getCompetenceDictionnary];
    NSArray *totleCompetenceKeys = [totleCompetenceDic allKeys];
    self.noCompetenceArray = [[NSMutableArray alloc] init];
    
    [totleCompetenceKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block int key = [(NSNumber *)obj intValue];
        __block BOOL contain = NO;
        
        [competenceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            int k = [(NSNumber *)obj intValue];
            
            if (key == k) {
                contain = YES;
            }
        }];
        
        if (!contain) {
            [self.noCompetenceArray addObject:obj];
        }
        
    }];
}

@end
