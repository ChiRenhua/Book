//
//  ListTableViewCell
//  Book
//
//  Created by Dreamylife on 16/3/22.
//  Copyright © 2016年 software. All rights reserved.
//

#import "ListTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+AppConfig.h"
#import "Utils.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size
#define BOOK_IMAGEBASEURL @"http://121.42.174.184:8080/bookmgyun/"

@interface ListTableViewCell()


@end
UIImageView *bookPictureImage;
UILabel *bookNameLable;
UILabel *bookWriterLable;
UILabel *bookISBN;
UILabel *bookStateLable;

@implementation ListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCellView];
    }
    return self;
}

#pragma mark 初始化cell上的view布局
- (void)initCellView {
    // 书籍封皮
    bookPictureImage = [[UIImageView alloc]init];
    bookPictureImage.frame = CGRectMake(15, 10, 55, 80);
    [self.contentView addSubview:bookPictureImage];
    // 书名
    bookNameLable = [[UILabel alloc]init];
    bookNameLable.textColor = [UIColor blackColor];
    bookNameLable.font = [UIFont systemFontOfSize:18];
    bookNameLable.frame = CGRectMake(90, 10, SCREEN_BOUNDS.width - 150, 25);
    [self.contentView addSubview:bookNameLable];
    // 作者
    bookWriterLable = [[UILabel alloc]init];
    bookWriterLable.textColor = [UIColor grayColor];
    bookWriterLable.font = [UIFont systemFontOfSize:15];
    bookWriterLable.frame = CGRectMake(90, 45, SCREEN_BOUNDS.width - 150, 16);
    [self.contentView addSubview:bookWriterLable];
    // 提交时间
    bookISBN = [[UILabel alloc]init];
    bookISBN.textColor = [UIColor grayColor];
    bookISBN.font = [UIFont systemFontOfSize:15];
    bookISBN.frame = CGRectMake(90, 75, SCREEN_BOUNDS.width - 60, 15);
    [self.contentView addSubview:bookISBN];
    // 状态
    bookStateLable = [[UILabel alloc]init];
    bookStateLable.font = [UIFont systemFontOfSize:14];
    bookStateLable.frame = CGRectMake(SCREEN_BOUNDS.width - 50, 45, 50, 15);
    [self.contentView addSubview:bookStateLable];
    
}
#pragma mark 为cell上的view布局添加文字或图片信息
- (void) setBookInfo:(Book *)book{
    NSString *coverPath = [BOOK_IMAGEBASEURL stringByAppendingString:book.coverPath];
    NSString *book_image_url = [Utils UTF8URL:coverPath];
    [bookPictureImage sd_setImageWithURL:[NSURL URLWithString:book_image_url] placeholderImage:[UIImage imageNamed:@"default_bookimage"]];
    bookNameLable.text = book.bookName;
    bookWriterLable.text = book.authorName;
    bookISBN.text = [@"ISBN:"stringByAppendingString:book.isbn];
    // 判断图书的审核状态，如果通过文字颜色为绿色，如果没通过则为红色，待审核为蓝色
    if ([book.bookState isEqualToString:@"已通过"]) {
        //设置文字颜色为绿色
        bookStateLable.textColor = [UIColor bookGreenColor];
    }else if ([book.bookState isEqualToString:@"未通过"]) {
        bookStateLable.textColor = [UIColor redColor];
    }else if ([book.bookState isEqualToString:@"审核中"]) {
        // 设置文字颜色为蓝色
        bookStateLable.textColor = [UIColor bookBlueColor];
    }else if ([book.bookState isEqualToString:@"待审核"]) {
        bookStateLable.textColor = [UIColor grayColor];
    }
    bookStateLable.text = book.bookState;
}
#pragma mark remove掉当前cell上的所有view布局
- (void)removeCellView {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

@end
