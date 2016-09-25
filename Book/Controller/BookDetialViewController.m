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
#import "UserInfoModel.h"
#import "BookDetialModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"
#import "BookReviewModel.h"
#import "UIColor+AppConfig.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size
#define FIRST_CELL_HIGHT SCREEN_BOUNDS.height / 4
#define FIRST_CHECKING_BOOK @"firstCheckingBook"
#define REVIEW_CHECKING_BOOK @"reviewCheckingBook"
#define BOOK_IMAGEBASEURL @"http://121.42.174.184:8080/bookmgyun/"

@interface BookDetialViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (retain,nonatomic) UITableView *bookDetialTableView;
@property (retain,nonatomic) Book *detialBook;
@property (copy,nonatomic) NSString *step;
@property (copy,nonatomic) UILabel *bookReviewInfo;
@property(retain,nonatomic) AppDelegate *bookDetialAppDelegate;
@property(nonatomic,retain)  MBProgressHUD *mbprogress;
@property (nonatomic, retain) UILabel *errorLable;
@property (nonatomic, retain) UIActivityIndicatorView *IndicatorView;

@end
int reviewTextHeight;

@implementation BookDetialViewController

- (id)init:(Book *) book step:(NSString *)step{
    if (self = [super init]) {
        _step = step;
        _detialBook = [[Book alloc]init];
        _bookDetialAppDelegate = [[UIApplication sharedApplication]delegate];
        _detialBook = book;
        [BookDetialModel sharedInstance].updateReason = ^(NSString * reason){
            // 计算文本高度
            CGSize bookIntroduceSize = [reason sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300.0f,CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
            _bookReviewInfo.frame = CGRectMake(SCREEN_BOUNDS.width / 20 + 70, 50, SCREEN_BOUNDS.width - SCREEN_BOUNDS.width / 20 - 90, bookIntroduceSize.height + 20);
            reviewTextHeight = bookIntroduceSize.height;
            [_errorLable setHidden:YES];
            [_IndicatorView stopAnimating];
            _bookReviewInfo.text = reason;
        };
        [BookDetialModel sharedInstance].bookDetialShowLoginView = ^(){
            [self showLoginView];
            [_IndicatorView stopAnimating];
            [_errorLable setHidden:NO];
        };
        [BookDetialModel sharedInstance].failedUpdateReason = ^(){
            [_IndicatorView stopAnimating];
            [_errorLable setHidden:NO];
        };
        _mbprogress = [[MBProgressHUD alloc]initWithView:self.view];
        _mbprogress.delegate = self;
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
    
    [self addIndicatorView];
    [self addErrorLable];
    [self getData];
}

- (void)addErrorLable {
    _errorLable = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_BOUNDS.height/2 - 25 + FIRST_CELL_HIGHT/2, SCREEN_BOUNDS.width, 50)];
    _errorLable.textColor = [UIColor grayColor];
    _errorLable.text = @"数据加载失败\n点击重新加载!";
    _errorLable.numberOfLines = 0;
    _errorLable.textAlignment = NSTextAlignmentCenter;
    _errorLable.font = [UIFont systemFontOfSize:15];
    _errorLable.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickErrorLable)];
    [_errorLable addGestureRecognizer:tapGesture];
    [self.view addSubview:_errorLable];
    [_errorLable setHidden:YES];
}

- (void)onClickErrorLable {
    [_errorLable setHidden:YES];
    [_IndicatorView startAnimating];
    [self getData];
}

- (void)getData {
    NSString *url = [NSString stringWithFormat:@"getNotPassReason.serv?username=%@&sessionid=%@&step=%@&bookid=%@",[[UserInfoModel sharedInstance]getUserName],[[UserInfoModel sharedInstance]getUserSessionid],_step,_detialBook.bookID];
    [[BookDetialModel sharedInstance] getBookreasonWithURL:url by:bookReasonModule];
}

- (void)addIndicatorView {
    _IndicatorView = [[UIActivityIndicatorView alloc]init];
    _IndicatorView.center = CGPointMake(SCREEN_BOUNDS.width/2, SCREEN_BOUNDS.height/2 + FIRST_CELL_HIGHT/2);
    _IndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_IndicatorView];
    [_IndicatorView startAnimating];
}

#pragma mark 设置分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
#pragma mark 设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_detialBook.bookState isEqualToString:@"已通过"] || [_detialBook.bookState isEqualToString:@"未通过"] || _detialBook.bookState == nil) {
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
            NSString *coverPath = [BOOK_IMAGEBASEURL stringByAppendingString:_detialBook.coverPath];
            NSString *book_image_url = [coverPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [bookImageView sd_setImageWithURL:[NSURL URLWithString:book_image_url] placeholderImage:[UIImage imageNamed:@"default_bookimage"]];
            [bookDetialViewCell.contentView addSubview:bookImageView];
            // 图书名字
            UILabel *bookName = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width / 3, 10, SCREEN_BOUNDS.width - 200, 50)];
            bookName.text = _detialBook.bookName;
            bookName.font = [UIFont systemFontOfSize:19];
            bookName.textColor = [UIColor blackColor];
            bookName.lineBreakMode = NSLineBreakByWordWrapping;                                                                                         // 文字过长时显示全部
            bookName.numberOfLines = 0;                                                                                                                 // 可以换行
            [bookDetialViewCell.contentView addSubview:bookName];
            // 作者名字
            UILabel *writerName = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width / 3, FIRST_CELL_HIGHT / 2 - 10, SCREEN_BOUNDS.width - 200, 50)];
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
                bookState.textColor = [UIColor bookGreenColor];
            }else if ([_detialBook.bookState isEqualToString:@"未通过"]) {
                bookState.textColor = [UIColor bookRedColor];
            }else if ([_detialBook.bookState isEqualToString:@"审核中"]) {
                // 设置文字颜色为蓝色
                bookState.textColor = [UIColor bookBlueColor];
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
                bookDetialViewCell.textLabel.textColor = [UIColor bookLableColor];
                bookDetialViewCell.textLabel.textAlignment = NSTextAlignmentCenter;
            }else if ([_detialBook.bookState isEqualToString:@"审核中"]) {
                bookDetialViewCell.textLabel.text = @"继续审核";
                // 设置文字颜色为蓝色
                bookDetialViewCell.textLabel.textColor = [UIColor bookLableColor];
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
        if ([_detialBook.bookState isEqualToString:@"待审核"]) {
            _mbprogress.mode = MBProgressHUDModeIndeterminate;                                                                          // 设置toast的样式为文字
            _mbprogress.label.text = NSLocalizedString(@"加审中", @"HUD message title");                                                 // 设置toast上的文字
            [self.view addSubview:_mbprogress];                                                                                         // 将toast添加到view中
            [self.view bringSubviewToFront:_mbprogress];                                                                                // 让toast显示在view的最前端
            [_mbprogress showAnimated:YES];                                                                                             // 显示toast
            
            NSString *addReviewURL = [NSString stringWithFormat:@"addAudit.serv?username=%@&sessionid=%@&bookid=%@&step=%@",[[UserInfoModel sharedInstance]getUserName],[[UserInfoModel sharedInstance]getUserSessionid],_detialBook.bookID,_step];
            [[BookDetialModel sharedInstance] getBookreasonWithURL:addReviewURL by:addReviewButtonModule];
            [BookDetialModel sharedInstance].showToast = ^(NSString *message){
                //[_mbprogress hideAnimated:YES];
                _mbprogress.mode = MBProgressHUDModeText;
                _mbprogress.label.text = NSLocalizedString(message, @"HUD completed title");
                //[_mbprogress showAnimated:YES];                                                                                         // 显示toast
                [_mbprogress hideAnimated:YES afterDelay:1.5];                                                                          // 1.5秒后销毁toast
            };
            [BookDetialModel sharedInstance].showReviewView = ^(){
                [_mbprogress hideAnimated:YES];
                UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                _mbprogress.customView = imageView;
                _mbprogress.mode = MBProgressHUDModeCustomView;
                _mbprogress.label.text = NSLocalizedString(@"加审成功", @"HUD completed title");
                [_mbprogress showAnimated:YES];                                                                                         // 显示toast
                [self performSelector:@selector(showReviewView) withObject:nil afterDelay:1.0f];
                _detialBook.bookState = @"审核中";
                
                if ([_step integerValue]) {
                    [[BookReviewModel sharedInstance]addReviewBookDataToLoaclWithBook:_detialBook bookState:REVIEW_CHECKING_BOOK];
                }else {
                    [[BookReviewModel sharedInstance]addReviewBookDataToLoaclWithBook:_detialBook bookState:FIRST_CHECKING_BOOK];
                }
                
                [self getData];
                [_bookDetialTableView reloadData];
            };
        }else if ([_detialBook.bookState isEqualToString:@"审核中"]) {
            //继续审核
            [self showReviewView];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];                                                                      // 取消选中的状态
}
#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return FIRST_CELL_HIGHT;
            break;
        case 1: {
            int height;
            if ([_detialBook.bookState isEqualToString:@"已通过"] || [_detialBook.bookState isEqualToString:@"未通过"] || _detialBook.bookState == nil) {
                height = SCREEN_BOUNDS.height - FIRST_CELL_HIGHT - 113;
            }else {
                height = SCREEN_BOUNDS.height - FIRST_CELL_HIGHT - 163;
            }
            if (reviewTextHeight > height) {
                height = reviewTextHeight + 20;
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

- (void)showLoginView {
    UIAlertController *loginAlert = [UIAlertController alertControllerWithTitle:@"错误!" message:@"登录态失效，请重新登陆!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        [self presentViewController:_bookDetialAppDelegate.loginVC animated:YES completion:nil];
    }];
    UIAlertAction *calcleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    [loginAlert addAction:loginAction];
    [loginAlert addAction:calcleAction];
    [self presentViewController:loginAlert animated:YES completion:nil];
}

- (void)showReviewView {
    if (_mbprogress) {
        [_mbprogress removeFromSuperview];
    }
    BookReviewViewController *bookReviewViewController;
    _detialBook.step = _step;
    bookReviewViewController = [[BookReviewViewController alloc]init:_detialBook];
    [self presentViewController:bookReviewViewController animated:YES completion:nil];
    bookReviewViewController.submitsuccess = ^(NSString *bookstate){
        [self getData];
        _detialBook.bookState = bookstate;
        [_bookDetialTableView reloadData];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
