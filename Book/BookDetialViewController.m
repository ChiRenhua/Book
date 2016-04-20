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

@interface BookDetialViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (retain,nonatomic) UITableView *bookDetialTableView;
@property (retain,nonatomic) Book *detialBook;
@end

@implementation BookDetialViewController

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
    _bookDetialTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -35, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height + 40) style:UITableViewStyleGrouped];
    _bookDetialTableView.delegate = self;
    _bookDetialTableView.dataSource = self;
    _bookDetialTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bookDetialTableView];
    
}

#pragma mark 设置分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
#pragma mark 设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_detialBook.bookState isEqualToString:@"通过"] || [_detialBook.bookState isEqualToString:@"未通过"] ) {
        return 4;
    }else {
        return 5;
    }
}
#pragma mark 设置单元格样式和内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *bookDetialViewCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (indexPath.row != 4) {
        bookDetialViewCell.selectionStyle = UITableViewCellSelectionStyleNone;                                                                           //取消选中状态
    }
    [bookDetialViewCell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];                                                 // 每次初始化之前移除view上的所有布局
    switch (indexPath.row) {
        case 0: {
            // 书籍封面
            UIImageView *bookImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_detialBook.bookPicture]];
            bookImageView.frame = CGRectMake(15, 10, 89, 130);
            bookImageView.contentMode = UIViewContentModeScaleAspectFit;
            [bookDetialViewCell.contentView addSubview:bookImageView];
            // 图书名字
            UILabel *bookName = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, self.view.bounds.size.width - 90, 45)];
            bookName.text = _detialBook.bookName;
            bookName.font = [UIFont systemFontOfSize:20];
            bookName.textColor = [UIColor blackColor];
            bookName.lineBreakMode = NSLineBreakByWordWrapping;                                                                                         // 文字过长时显示全部
            bookName.numberOfLines = 0;                                                                                                                 // 可以换行
            [bookDetialViewCell.contentView addSubview:bookName];
            // 作者名字
            UILabel *writerName = [[UILabel alloc]initWithFrame:CGRectMake(110, 60, self.view.bounds.size.width - 90, 20)];
            writerName.text = _detialBook.bookWriter;
            writerName.font = [UIFont systemFontOfSize:15];
            writerName.textColor = [UIColor grayColor];
            [bookDetialViewCell.contentView addSubview:writerName];
            // 书籍完成时间
            UILabel *bookTime = [[UILabel alloc]initWithFrame:CGRectMake(110, 115, self.view.bounds.size.width - 90, 20)];
            bookTime.text = _detialBook.bookTime;
            bookTime.font = [UIFont systemFontOfSize:15];
            bookTime.textColor = [UIColor grayColor];
            [bookDetialViewCell.contentView addSubview:bookTime];
            // 书籍状态
            UILabel *bookState = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 50, 60, 50, 20)];
            bookState.text = _detialBook.bookState;
            bookState.font = [UIFont systemFontOfSize:15];
            // 判断图书的审核状态，如果通过文字颜色为绿色，如果没通过则为红色，待审核为蓝色
            if ([_detialBook.bookState isEqualToString:@"通过"]) {
                bookState.textColor = [UIColor greenColor];
            }else if ([_detialBook.bookState isEqualToString:@"未通过"]) {
                bookState.textColor = [UIColor redColor];
            }else if ([_detialBook.bookState isEqualToString:@"审核中"]) {
                bookState.textColor = [UIColor blueColor];
            }else if ([_detialBook.bookState isEqualToString:@"待审核"]) {
                bookState.textColor = [UIColor grayColor];
            }
            [bookDetialViewCell.contentView addSubview:bookState];
            
        }
            break;
        case 1: {
            // 书籍简介标题
            UILabel *bookIntroduceTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, self.view.bounds.size.width - 10, 20)];
            bookIntroduceTitle.text = @"书籍简介";
            bookIntroduceTitle.font = [UIFont systemFontOfSize:18];
            bookIntroduceTitle.textColor = [UIColor blackColor];
            [bookDetialViewCell.contentView addSubview:bookIntroduceTitle];
            // 书籍简介内容
            UILabel *bookIntroduce = [[UILabel alloc]init];
            bookIntroduce.text = _detialBook.bookSummary;
            bookIntroduce.lineBreakMode = NSLineBreakByWordWrapping;                                                                                         // 文字过长时显示全部
            bookIntroduce.numberOfLines = 0;                                                                                                                 // 取消行数限制
            bookIntroduce.font = [UIFont systemFontOfSize:13];
            // 计算文本高度
            CGSize bookIntroduceSize = [_detialBook.bookSummary sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(300.0f,CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
            bookIntroduce.frame = CGRectMake(15, 40, self.view.bounds.size.width - 20, bookIntroduceSize.height);
            bookIntroduce.textColor = [UIColor grayColor];
            [bookDetialViewCell.contentView addSubview:bookIntroduce];
        }
            break;
        case 2: {
            // 审核信息标题
            UILabel *bookReviewInfoTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, self.view.bounds.size.width - 10, 20)];
            bookReviewInfoTitle.text = @"审核信息";
            bookReviewInfoTitle.font = [UIFont systemFontOfSize:18];
            bookReviewInfoTitle.textColor = [UIColor blackColor];
            [bookDetialViewCell.contentView addSubview:bookReviewInfoTitle];
            // 审核信息内容
            UILabel *bookReviewInfo = [[UILabel alloc]init];
            bookReviewInfo.text = _detialBook.bookReviewInfo;
            bookReviewInfo.lineBreakMode = NSLineBreakByWordWrapping;                                                                                         // 文字过长时显示全部
            bookReviewInfo.numberOfLines = 0;                                                                                                                 // 取消行数限制
            bookReviewInfo.font = [UIFont systemFontOfSize:13];
            // 计算文本高度
            CGSize bookIntroduceSize = [_detialBook.bookReviewInfo sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(300.0f,CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
            bookReviewInfo.frame = CGRectMake(15, 40, self.view.bounds.size.width - 20, bookIntroduceSize.height);
            bookReviewInfo.textColor = [UIColor grayColor];
            [bookDetialViewCell.contentView addSubview:bookReviewInfo];
        }
            break;
        case 3: {
            // 书籍简介标题
            UILabel *bookIntroduceTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, self.view.bounds.size.width - 10, 20)];
            bookIntroduceTitle.text = @"书籍信息";
            bookIntroduceTitle.font = [UIFont systemFontOfSize:18];
            bookIntroduceTitle.textColor = [UIColor blackColor];
            [bookDetialViewCell.contentView addSubview:bookIntroduceTitle];
            // 出版商标题
            UILabel *bookPublishersTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, 70, 15)];
            bookPublishersTitle.text = @"出版商";
            bookPublishersTitle.textAlignment = NSTextAlignmentRight;
            bookPublishersTitle.font = [UIFont systemFontOfSize:14];
            bookPublishersTitle.textColor = [UIColor grayColor];
            [bookDetialViewCell.contentView addSubview:bookPublishersTitle];
            // 图书类别标题
            UILabel *bookCategoryTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 75, 70, 15)];
            bookCategoryTitle.text = @"类别";
            bookCategoryTitle.textAlignment = NSTextAlignmentRight;
            bookCategoryTitle.font = [UIFont systemFontOfSize:14];
            bookCategoryTitle.textColor = [UIColor grayColor];
            [bookDetialViewCell.contentView addSubview:bookCategoryTitle];
            // 图书日期标题
            UILabel *bookTimeTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 100, 70, 15)];
            bookTimeTitle.text = @"日期";
            bookTimeTitle.textAlignment = NSTextAlignmentRight;
            bookTimeTitle.font = [UIFont systemFontOfSize:14];
            bookTimeTitle.textColor = [UIColor grayColor];
            [bookDetialViewCell.contentView addSubview:bookTimeTitle];
            // 图书大小标题
            UILabel *bookSizeTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 125, 70, 15)];
            bookSizeTitle.text = @"大小";
            bookSizeTitle.textAlignment = NSTextAlignmentRight;
            bookSizeTitle.font = [UIFont systemFontOfSize:14];
            bookSizeTitle.textColor = [UIColor grayColor];
            [bookDetialViewCell.contentView addSubview:bookSizeTitle];
            // 图书页数标题
            UILabel *bookPageTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 150, 70, 15)];
            bookPageTitle.text = @"页数";
            bookPageTitle.textAlignment = NSTextAlignmentRight;
            bookPageTitle.font = [UIFont systemFontOfSize:14];
            bookPageTitle.textColor = [UIColor grayColor];
            [bookDetialViewCell.contentView addSubview:bookPageTitle];
            // 图书语言标题
            UILabel *bookLanguageTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 175, 70, 15)];
            bookLanguageTitle.text = @"语言";
            bookLanguageTitle.textAlignment = NSTextAlignmentRight;
            bookLanguageTitle.font = [UIFont systemFontOfSize:14];
            bookLanguageTitle.textColor = [UIColor grayColor];
            [bookDetialViewCell.contentView addSubview:bookLanguageTitle];
            
            // 出版商
            UILabel *bookPublishers = [[UILabel alloc]initWithFrame:CGRectMake(110, 50, 200, 15)];
            bookPublishers.text = _detialBook.bookPublishers;
            bookPublishers.font = [UIFont systemFontOfSize:14];
            bookPublishers.textColor = [UIColor blackColor];
            [bookDetialViewCell.contentView addSubview:bookPublishers];
            // 图书类别
            UILabel *bookCategory = [[UILabel alloc]initWithFrame:CGRectMake(110, 75, 200, 15)];
            bookCategory.text = _detialBook.bookCategory;
            bookCategory.font = [UIFont systemFontOfSize:14];
            bookCategory.textColor = [UIColor blackColor];
            [bookDetialViewCell.contentView addSubview:bookCategory];
            // 图书日期
            UILabel *bookTime = [[UILabel alloc]initWithFrame:CGRectMake(110, 100, 200, 15)];
            bookTime.text = _detialBook.bookTime;
            bookTime.font = [UIFont systemFontOfSize:14];
            bookTime.textColor = [UIColor blackColor];
            [bookDetialViewCell.contentView addSubview:bookTime];
            // 图书大小
            UILabel *bookSize = [[UILabel alloc]initWithFrame:CGRectMake(110, 125, 200, 15)];
            bookSize.text = _detialBook.bookSize;
            bookSize.font = [UIFont systemFontOfSize:14];
            bookSize.textColor = [UIColor blackColor];
            [bookDetialViewCell.contentView addSubview:bookSize];
            // 图书页数
            UILabel *bookPage = [[UILabel alloc]initWithFrame:CGRectMake(110, 150, 200, 15)];
            bookPage.text = _detialBook.bookPages;
            bookPage.font = [UIFont systemFontOfSize:14];
            bookPage.textColor = [UIColor blackColor];
            [bookDetialViewCell.contentView addSubview:bookPage];
            // 图书语言
            UILabel *bookLanguage = [[UILabel alloc]initWithFrame:CGRectMake(110, 175, 200, 15)];
            bookLanguage.text = _detialBook.bookLanguage;
            bookLanguage.font = [UIFont systemFontOfSize:14];
            bookLanguage.textColor = [UIColor blackColor];
            [bookDetialViewCell.contentView addSubview:bookLanguage];
        }
            break;
        case 4: {
            // 审核按钮
            if ([_detialBook.bookState isEqualToString:@"待审核"]) {
                bookDetialViewCell.textLabel.text = @"开始审核";
                bookDetialViewCell.textLabel.textAlignment = NSTextAlignmentCenter;
            }else if ([_detialBook.bookState isEqualToString:@"审核中"]) {
                bookDetialViewCell.textLabel.text = @"继续审核";
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
    if (indexPath.row == 4) {
        BookReviewViewController *bookReviewViewController = [[BookReviewViewController alloc]init:_detialBook];
        [self presentViewController:bookReviewViewController animated:YES completion:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];                                                                                  // 取消选中的状态
}
#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 150;
            break;
        case 1: {
            // 获得文字的高度
            CGSize bookIntroduceSize = [_detialBook.bookSummary sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300.0f,CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
            return bookIntroduceSize.height + 55;
            break;
        }
        case 2: {
            // 获得文字的高度
            CGSize bookIntroduceSize = [_detialBook.bookReviewInfo sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300.0f,CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
            return bookIntroduceSize.height + 55;
            break;
        }
        case 3:
            return 220;
            break;
        case 4:
            return 50;
            break;
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