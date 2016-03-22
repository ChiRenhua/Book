//
//  ListTableViewCell
//  Book
//
//  Created by Dreamylife on 16/3/22.
//  Copyright © 2016年 software. All rights reserved.
//

#import "ListTableViewCell.h"
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size

@interface ListTableViewCell()


@end
UIImageView *bookPictureImage;
UILabel *bookNameLable;
UILabel *bookWriterLable;
UILabel *bookTimeLable;
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
    bookNameLable.font = [UIFont systemFontOfSize:20];
    bookNameLable.frame = CGRectMake(90, 10, SCREEN_BOUNDS.width - 60, 25);
    [self.contentView addSubview:bookNameLable];
    // 作者
    bookWriterLable = [[UILabel alloc]init];
    bookWriterLable.textColor = [UIColor grayColor];
    bookWriterLable.font = [UIFont systemFontOfSize:15];
    bookWriterLable.frame = CGRectMake(90, 45, SCREEN_BOUNDS.width - 60, 15);
    [self.contentView addSubview:bookWriterLable];
    // 提交时间
    bookTimeLable = [[UILabel alloc]init];
    bookTimeLable.textColor = [UIColor grayColor];
    bookTimeLable.font = [UIFont systemFontOfSize:15];
    bookTimeLable.frame = CGRectMake(90, 75, SCREEN_BOUNDS.width - 60, 15);
    [self.contentView addSubview:bookTimeLable];
    // 状态
    bookStateLable = [[UILabel alloc]init];
    bookStateLable.textColor = [UIColor blackColor];
    bookStateLable.font = [UIFont systemFontOfSize:15];
    bookStateLable.frame = CGRectMake(SCREEN_BOUNDS.width - 50, 45, 50, 10);
    [self.contentView addSubview:bookStateLable];
    
}
#pragma mark 为cell上的view布局添加文字或图片信息
- (void) setBookInfo:(Book *)book{
    bookPictureImage.image = [UIImage imageNamed:book.bookPicture];
    bookNameLable.text = book.bookName;
    bookWriterLable.text = book.bookWriter;
    bookTimeLable.text = book.bookTime;
    bookStateLable.text = book.bookState;
}
#pragma mark remove掉当前cell上的所有view布局
- (void)removeCellView {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

@end
