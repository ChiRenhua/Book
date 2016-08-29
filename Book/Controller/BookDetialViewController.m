//
//  BookDetialViewController.m
//  Book
//
//  Created by Dreamylife on 16/3/23.
//  Copyright © 2016年 software. All rights reserved.
//

#import "BookDetialViewController.h"
#import "BookReviewViewController.h"
#import "Book.h"
#import "AppDelegate.h"
#import "AFNetworking/AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UserInfoModel.h"
#import "BookDetialModel.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size
#define FIRST_CELL_HIGHT SCREEN_BOUNDS.height / 4

@interface BookDetialViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (retain,nonatomic) UITableView *bookDetialTableView;
@property (retain,nonatomic) Book *detialBook;
@property (retain,nonatomic) AppDelegate *appdelegate;
@property (copy,nonatomic) NSString *step;
@property (copy,nonatomic) UILabel *bookReviewInfo;
@property(retain,nonatomic) AppDelegate *bookDetialAppDelegate;

@end
int reviewTextHeight;

@implementation BookDetialViewController

- (id)init:(Book *) book step:(NSString *)step{
    if (self = [super init]) {
        _step = step;
        _detialBook = [[Book alloc]init];
        _bookDetialAppDelegate = [[UIApplication sharedApplication]delegate];
        _detialBook = book;
        _appdelegate = [[UIApplication sharedApplication]delegate];
        [BookDetialModel sharedInstance].updateReason = ^(NSString * reason){
            // 计算文本高度
            CGSize bookIntroduceSize = [reason sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(300.0f,CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
            _bookReviewInfo.frame = CGRectMake(SCREEN_BOUNDS.width / 20 + 70, 50, SCREEN_BOUNDS.width - 20, bookIntroduceSize.height);
            reviewTextHeight = bookIntroduceSize.height;
            _bookReviewInfo.text = reason;
        };
        [BookDetialModel sharedInstance].bookDetialShowLoginView = ^(){
            UIAlertController *loginAlert = [UIAlertController alertControllerWithTitle:@"错误！" message:@"登录态失效，请重新登陆！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
                [self presentViewController:_bookDetialAppDelegate.loginVC animated:YES completion:nil];
            }];
            UIAlertAction *calcleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                
            }];
            [loginAlert addAction:loginAction];
            [loginAlert addAction:calcleAction];
            [self presentViewController:loginAlert animated:YES completion:nil];
        };
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _bookDetialTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -35, SCREEN_BOUNDS.width, [UIScreen mainScreen].bounds.size.height + 73) style:UITableViewStyleGrouped];
    _bookDetialTableView.delegate = self;
    _bookDetialTableView.dataSource = self;
    _bookDetialTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bookDetialTableView];
    
    NSString *url = [NSString stringWithFormat:@"getNotPassReason.serv?username=%@&sessionid=%@&step=%@&bookid=%@",[[UserInfoModel sharedInstance]getUserName],[[UserInfoModel sharedInstance]getUserSessionid],_detialBook.bookID,_step];
    [[BookDetialModel sharedInstance] getBookreasonWithURL:url by:bookReasonModule];
    
}

#pragma mark 设置分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
#pragma mark 设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_detialBook.bookState isEqualToString:@"已通过"] || [_detialBook.bookState isEqualToString:@"未通过"] ) {
        return 2;
    }else {
        return 3;
    }
}
#pragma mark 设置单元格样式和内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *bookDetialViewCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (indexPath.row != 2) {
        bookDetialViewCell.selectionStyle = UITableViewCellSelectionStyleNone;                                                                           //取消选中状态
    }
    [bookDetialViewCell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];                                                 // 每次初始化之前移除view上的所有布局
    switch (indexPath.row) {
        case 0: {
            // 书籍封面
            UIImageView *bookImageView = [[UIImageView alloc]init];
            bookImageView.frame = CGRectMake(SCREEN_BOUNDS.width / 20, 15, (FIRST_CELL_HIGHT - 30 ) / 3 * 2, FIRST_CELL_HIGHT - 30);
            NSString *book_image_url = [_detialBook.coverPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [bookImageView setImageWithURL:[NSURL URLWithString:book_image_url] placeholderImage:[UIImage imageNamed:@"default_bookimage"]];
            [bookDetialViewCell.contentView addSubview:bookImageView];
            // 图书名字
            UILabel *bookName = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width / 3, 20, SCREEN_BOUNDS.width - 200, 60)];
            bookName.text = _detialBook.bookName;
            bookName.font = [UIFont systemFontOfSize:19];
            bookName.textColor = [UIColor blackColor];
            bookName.lineBreakMode = NSLineBreakByWordWrapping;                                                                                         // 文字过长时显示全部
            bookName.numberOfLines = 0;                                                                                                                 // 可以换行
            [bookDetialViewCell.contentView addSubview:bookName];
            // 作者名字
            UILabel *writerName = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width / 3, FIRST_CELL_HIGHT / 2 - 7.5, SCREEN_BOUNDS.width - 200, 50)];
            writerName.text = _detialBook.authorName;
            writerName.font = [UIFont systemFontOfSize:14];
            writerName.textColor = [UIColor grayColor];
            writerName.numberOfLines = 0;
            writerName.lineBreakMode = NSLineBreakByWordWrapping;
            [bookDetialViewCell.contentView addSubview:writerName];
            // 书籍ISBN
            UILabel *bookISBN = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width / 3, FIRST_CELL_HIGHT - 35, SCREEN_BOUNDS.width - 90, 15)];
            bookISBN.text = _detialBook.isbn;
            bookISBN.font = [UIFont systemFontOfSize:14];
            bookISBN.textColor = [UIColor grayColor];
            [bookDetialViewCell.contentView addSubview:bookISBN];
            // 书籍状态
            UILabel *bookState = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width - 50, FIRST_CELL_HIGHT / 2 - 8, 50, 16)];
            bookState.text = _detialBook.bookState;
            bookState.font = [UIFont systemFontOfSize:15];
            // 判断图书的审核状态，如果通过文字颜色为绿色，如果没通过则为红色，待审核为蓝色
            if ([_detialBook.bookState isEqualToString:@"已通过"]) {
                // 设置文字颜色为绿色
                bookState.textColor = [UIColor colorWithRed:0.0f/255.0f
                                                      green:200.0f/255.0f
                                                       blue:0.0f/255.0f
                                                      alpha:1.0f];
            }else if ([_detialBook.bookState isEqualToString:@"未通过"]) {
                bookState.textColor = [UIColor redColor];
            }else if ([_detialBook.bookState isEqualToString:@"审核中"]) {
                // 设置文字颜色为蓝色
                bookState.textColor = [UIColor colorWithRed:28.0f/255.0f
                                                      green:134.0f/255.0f
                                                       blue:238.0f/255.0f
                                                      alpha:1.0f];
            }else if ([_detialBook.bookState isEqualToString:@"待审核"]) {
                bookState.textColor = [UIColor grayColor];
            }
            [bookDetialViewCell.contentView addSubview:bookState];
            
        }
            break;
        case 1: {
            // 审核信息标题
            UILabel *bookReviewInfoTitle = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width / 20, 15, SCREEN_BOUNDS.width - 10, 20)];
            bookReviewInfoTitle.text = @"审核信息";
            bookReviewInfoTitle.font = [UIFont systemFontOfSize:17];
            bookReviewInfoTitle.textColor = [UIColor blackColor];
            [bookDetialViewCell.contentView addSubview:bookReviewInfoTitle];
            // 审核信息内容
            _bookReviewInfo = [[UILabel alloc]init];
            _bookReviewInfo.lineBreakMode = NSLineBreakByWordWrapping;                                                                                         // 文字过长时显示全部
            _bookReviewInfo.numberOfLines = 0;                                                                                                                 // 取消行数限制
            _bookReviewInfo.font = [UIFont systemFontOfSize:15];

            _bookReviewInfo.textColor = [UIColor grayColor];
            [bookDetialViewCell.contentView addSubview:_bookReviewInfo];
        }
            break;
        case 2: {
            // 审核按钮
            if ([_detialBook.bookState isEqualToString:@"待审核"]) {
                bookDetialViewCell.textLabel.text = @"开始审核";
                // 设置文字颜色为蓝色
                bookDetialViewCell.textLabel.textColor = [UIColor colorWithRed:28.0f/255.0f
                                                                         green:134.0f/255.0f
                                                                          blue:238.0f/255.0f
                                                                         alpha:1.0f];
                bookDetialViewCell.textLabel.textAlignment = NSTextAlignmentCenter;
            }else if ([_detialBook.bookState isEqualToString:@"审核中"]) {
                bookDetialViewCell.textLabel.text = @"继续审核";
                // 设置文字颜色为蓝色
                bookDetialViewCell.textLabel.textColor = [UIColor colorWithRed:28.0f/255.0f
                                                                         green:134.0f/255.0f
                                                                          blue:238.0f/255.0f
                                                                         alpha:1.0f];
                bookDetialViewCell.textLabel.textAlignment = NSTextAlignmentCenter;
            }
            break;
        }
        default: {
            
        }
            break;
    }
    return bookDetialViewCell;
}
#pragma mark 添加行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        BookReviewViewController *bookReviewViewController;
            bookReviewViewController = [[BookReviewViewController alloc]init:_detialBook];
            _appdelegate.bookReviewVC = bookReviewViewController;
        
        [self presentViewController:bookReviewViewController animated:YES completion:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];                                                                                  // 取消选中的状态
}
#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return FIRST_CELL_HIGHT;
            break;
        case 1: {
            int height;
            if ([_detialBook.bookState isEqualToString:@"已通过"] || [_detialBook.bookState isEqualToString:@"未通过"] ) {
                height = SCREEN_BOUNDS.height - FIRST_CELL_HIGHT - 93 - 20;
            }else {
                height = SCREEN_BOUNDS.height - FIRST_CELL_HIGHT - 50 - 93 - 20;
            }
            if (reviewTextHeight > height) {
                height = reviewTextHeight;
            }
            return height;
            break;
        }
        case 2: {
            return 50;
            break;
        }
        default:
            break;
    }
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end