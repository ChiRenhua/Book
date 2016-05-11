//
//  BookReviewViewController.m
//  Book
//
//  Created by Dreamylife on 16/4/20.
//  Copyright © 2016年 software. All rights reserved.
//

#import "BookReviewViewController.h"
#import "RDRGrowingTextView.h"
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size
static NSString * const CellIdentifier = @"cell";
@interface BookReviewViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (retain,nonatomic) Book *detialBook;
@property (retain,strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *reviewInfoList;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *bookDetialArray;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) RDRGrowingTextView *textView;
@property (nonatomic, assign) BOOL isKeyboardShow;
@end

@implementation BookReviewViewController

- (id)init:(Book *) book{
    if (self = [super init]) {
        _detialBook = [[Book alloc]init];
        _detialBook = book;
        NSString *bookPicture = [[NSString alloc]initWithFormat:@"%@",_detialBook.bookPicture];
        NSString *bookWriter = [[NSString alloc]initWithFormat:@"%@%@",@"作    者：",_detialBook.bookWriter];
        NSString *bookName = [[NSString alloc]initWithFormat:@"%@%@",@"书    名：",_detialBook.bookName];
        NSString *bookPublishers = [[NSString alloc]initWithFormat:@"%@%@",@"出版商：",_detialBook.bookPublishers];
        NSString *bookSize = [[NSString alloc]initWithFormat:@"%@%@",@"大    小：",_detialBook.bookSize];
        NSString *bookPage = [[NSString alloc]initWithFormat:@"%@%@",@"页    数：",_detialBook.bookPages];
        NSString *bookLanguage = [[NSString alloc]initWithFormat:@"%@%@",@"语    言：",_detialBook.bookLanguage];
        NSString *bookCategory = [[NSString alloc]initWithFormat:@"%@%@",@"类    型：",_detialBook.bookCategory];
        NSString *bookTime = [[NSString alloc]initWithFormat:@"%@%@",@"时    间：",_detialBook.bookTime];
        NSString *bookSummary = [[NSString alloc]initWithFormat:@"%@%@",@"简    介：",_detialBook.bookSummary];
        _reviewInfoList = [[NSMutableArray alloc]initWithObjects:bookPicture,bookName,bookWriter,bookSummary,bookPublishers,bookCategory,bookTime,bookSize,bookPage,bookLanguage, nil];
        
        _titleArray = [[NSMutableArray alloc]initWithObjects:@"封皮",@"书名",@"作者",@"简介",@"出版商",@"类型",@"时间",@"大小",@"页数",@"语言", nil];
        
        
        NSString *bookDetialPicture = [[NSString alloc]initWithFormat:@"“%@”",_detialBook.bookPicture];
        NSString *bookDetialWriter = [[NSString alloc]initWithFormat:@"“%@”",_detialBook.bookWriter];
        NSString *bookDetialName = [[NSString alloc]initWithFormat:@"“%@”",_detialBook.bookName];
        NSString *bookDetialPublishers = [[NSString alloc]initWithFormat:@"“%@”",_detialBook.bookPublishers];
        NSString *bookDetialSize = [[NSString alloc]initWithFormat:@"“%@”",_detialBook.bookSize];
        NSString *bookDetialPage = [[NSString alloc]initWithFormat:@"“%@”",_detialBook.bookPages];
        NSString *bookDetialLanguage = [[NSString alloc]initWithFormat:@"“%@”",_detialBook.bookLanguage];
        NSString *bookDetialCategory = [[NSString alloc]initWithFormat:@"“%@”",_detialBook.bookCategory];
        NSString *bookDetialTime = [[NSString alloc]initWithFormat:@"“%@”",_detialBook.bookTime];
        NSString *bookDetialSummary = [[NSString alloc]initWithFormat:@"“%@”",_detialBook.bookSummary];
        _bookDetialArray = [[NSMutableArray alloc]initWithObjects:bookDetialPicture,bookDetialName,bookDetialWriter,bookDetialSummary,bookDetialPublishers,bookDetialCategory,bookDetialTime,bookDetialSize,bookDetialPage,bookDetialLanguage,nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // 添加NavigationBar
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, self.view.bounds.size.width, self.view.bounds.size.height - 65) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setNavigationBar];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    [self.view addSubview:_tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
#pragma mark Handle keyboard show/hide changes
- (void)keyboardWillShow: (NSNotification *)notification
{
    if (_isKeyboardShow) {
        CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        _tableView.frame = CGRectMake(0, 65, self.view.bounds.size.width, self.view.bounds.size.height - 65 - keyboardSize.height);
        [_tableView reloadData];
    }
    _isKeyboardShow = YES;
    

}

- (void)keyboardWillHide: (NSNotification *)notification
{
    _tableView.frame = CGRectMake(0, 65, self.view.bounds.size.width, self.view.bounds.size.height - 65);
    [_tableView reloadData];
}

#pragma mark - Overrides

- (BOOL)canBecomeFirstResponder
{
    return YES;
}
#pragma mark 输入框view
- (UIView *)inputAccessoryView
{
    if (_toolbar) {
        return _toolbar;
    }
    
    _toolbar = [UIToolbar new];
    
    _textView = [RDRGrowingTextView new];
    _textView.font = [UIFont systemFontOfSize:17.0f];
    _textView.textContainerInset = UIEdgeInsetsMake(4.0f, 3.0f, 3.0f, 3.0f);
    _textView.layer.cornerRadius = 4.0f;
    _textView.layer.borderColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:205.0f/255.0f alpha:1.0f].CGColor;
    _textView.layer.borderWidth = 1.0f;
    _textView.layer.masksToBounds = YES;
    [_toolbar addSubview:_textView];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    commitButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [commitButton setTitle:NSLocalizedString(@"提交", nil)
                  forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_toolbar addSubview:commitButton];
    NSDictionary *views = @{
                            @"commitButton" : commitButton,
                            @"textView" : _textView,
                            @"toolbar" : _toolbar};
    
    _textView.translatesAutoresizingMaskIntoConstraints = NO;
    commitButton.translatesAutoresizingMaskIntoConstraints = NO;
    _toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_toolbar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[textView]-0-[commitButton(40)]-3-|" options:0 metrics:nil views:views]];
    [_toolbar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[textView]-8-|" options:0 metrics:nil views:views]];
    [_toolbar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[commitButton]-8-|" options:0 metrics:nil views:views]];
    
    [_textView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_textView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [commitButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [commitButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [_toolbar setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [_toolbar addConstraint:[NSLayoutConstraint constraintWithItem:_toolbar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:150.0f]];
    
    return _toolbar;
}
#pragma mark 提交按钮点击事件
- (void)commitButtonAction {
    // 键盘收回判断
    _isKeyboardShow = NO;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"审核信息" message:_textView.text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    [alert addAction:okAction];
    [alert addAction:cancleAction];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark 添加NavigationBar
- (void)setNavigationBar {
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.width, 65)];
    navigationBar.backgroundColor = [UIColor whiteColor];
    //创建UINavigationItem
    UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"审核"];
    [self.view addSubview: navigationBar];
    //创建UIBarButton 可根据需要选择适合自己的样式
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    //设置barbutton
    navigationBarTitle.leftBarButtonItem = leftBarItem;
    [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
}
- (void)cancle {
    [self dismissViewControllerAnimated:YES completion:nil];                                                                                   // 登录成功后撤下登录界面
}
#pragma mark 设置每组标题名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"审核意见";
}
#pragma mark 设置分组标题内容高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SCREEN_BOUNDS.height / 20;
}
#pragma mark 设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _reviewInfoList.count;
}
#pragma mark 设置单元格样式和内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (indexPath.row == 0) {
        UILabel *bookPictureTitle = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width / 20, 15, 100, 20)];
        bookPictureTitle.text = @"封    皮：";
        bookPictureTitle.font = [UIFont systemFontOfSize:17];
        [cell.contentView addSubview:bookPictureTitle];
        
        UIImageView *bookPictureImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width / 4 - 5 , 5, 27, 40)];
        bookPictureImage.image = [UIImage imageNamed:_reviewInfoList[indexPath.row]];
        bookPictureImage.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:bookPictureImage];
    }else {
        UILabel *bookPictureTitle = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width / 20, 15, tableView.bounds.size.width - 100, 20)];
        bookPictureTitle.text = _reviewInfoList[indexPath.row];
        bookPictureTitle.font = [UIFont systemFontOfSize:17];
        [cell.contentView addSubview:bookPictureTitle];
    }
    // 是否合格
    UIImageView *isPassImage = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.bounds.size.width - 45, 5, 40, 40)];
    isPassImage.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:isPassImage];
    
    // 获取书籍合格状态列表
    NSMutableDictionary *bookDictionary = [[NSMutableDictionary alloc]init];
    NSString *bookDetialisPass = [[NSString alloc]init];
    bookDictionary = _detialBook.bookReviewInfo;
    
    switch (indexPath.row) {
        case 0:{
            bookDetialisPass = [bookDictionary objectForKey:@"bookPicture"];
        }
            break;
        case 1:{
            bookDetialisPass = [bookDictionary objectForKey:@"bookName"];
        }
            break;
        case 2:{
            bookDetialisPass = [bookDictionary objectForKey:@"bookWriter"];
        }
            break;
        case 3:{
            bookDetialisPass = [bookDictionary objectForKey:@"bookSummary"];
        }
            break;
        case 4:{
            bookDetialisPass = [bookDictionary objectForKey:@"bookPublishers"];
        }
            break;
        case 5:{
            bookDetialisPass = [bookDictionary objectForKey:@"bookCategory"];
        }
            break;
        case 6:{
            bookDetialisPass = [bookDictionary objectForKey:@"bookTime"];
        }
            break;
        case 7:{
            bookDetialisPass = [bookDictionary objectForKey:@"bookSize"];
        }
            break;
        case 8:{
            bookDetialisPass = [bookDictionary objectForKey:@"bookPages"];
        }
            break;
        case 9:{
            bookDetialisPass = [bookDictionary objectForKey:@"bookLanguage"];
        }
            break;
        default:
            break;
    }
    if ([bookDetialisPass isEqualToString:@"1"]) {
        isPassImage.image = [UIImage imageNamed:@"touxiang.png"];
    }else if ([bookDetialisPass isEqualToString:@"0"]) {
        isPassImage.image = [UIImage imageNamed:@"review.png"];
    }
    return cell;
}
#pragma mark 添加行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];                                                                                  // 取消选中的状态
    // 使用自定义的AlertView
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self createAlertViewWithIndexPath:indexPath]];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"不合格", @"合格", nil]];
    //[alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        // 获取书籍合格状态列表
        NSMutableDictionary *bookDictionary = [[NSMutableDictionary alloc]init];
        bookDictionary = _detialBook.bookReviewInfo;
        switch (buttonIndex) {
            case 0:{
                switch (indexPath.row) {
                    case 0:{
                        [bookDictionary setObject:@"0" forKey:@"bookPicture"];
                    }
                        break;
                    case 1:{
                        [bookDictionary setObject:@"0" forKey:@"bookName"];
                    }
                        break;
                    case 2:{
                        [bookDictionary setObject:@"0" forKey:@"bookWriter"];
                    }
                        break;
                    case 3:{
                        [bookDictionary setObject:@"0" forKey:@"bookSummary"];
                    }
                        break;
                    case 4:{
                        [bookDictionary setObject:@"0" forKey:@"bookPublishers"];
                    }
                        break;
                    case 5:{
                        [bookDictionary setObject:@"0" forKey:@"bookCategory"];
                    }
                        break;
                    case 6:{
                        [bookDictionary setObject:@"0" forKey:@"bookTime"];
                    }
                        break;
                    case 7:{
                        [bookDictionary setObject:@"0" forKey:@"bookSize"];
                    }
                        break;
                    case 8:{
                        [bookDictionary setObject:@"0" forKey:@"bookPages"];
                    }
                        break;
                    case 9:{
                        [bookDictionary setObject:@"0" forKey:@"bookLanguage"];
                    }
                        break;
                    default:
                        break;
                }

            }
                break;
            case 1:{
                switch (indexPath.row) {
                    case 0:{
                        [bookDictionary setObject:@"1" forKey:@"bookPicture"];
                    }
                        break;
                    case 1:{
                        [bookDictionary setObject:@"1" forKey:@"bookName"];
                    }
                        break;
                    case 2:{
                        [bookDictionary setObject:@"1" forKey:@"bookWriter"];
                    }
                        break;
                    case 3:{
                        [bookDictionary setObject:@"1" forKey:@"bookSummary"];
                    }
                        break;
                    case 4:{
                        [bookDictionary setObject:@"1" forKey:@"bookPublishers"];
                    }
                        break;
                    case 5:{
                        [bookDictionary setObject:@"1" forKey:@"bookCategory"];
                    }
                        break;
                    case 6:{
                        [bookDictionary setObject:@"1" forKey:@"bookTime"];
                    }
                        break;
                    case 7:{
                        [bookDictionary setObject:@"1" forKey:@"bookSize"];
                    }
                        break;
                    case 8:{
                        [bookDictionary setObject:@"1" forKey:@"bookPages"];
                    }
                        break;
                    case 9:{
                        [bookDictionary setObject:@"1" forKey:@"bookLanguage"];
                    }
                        break;
                    default:
                        break;
                }

            }
                break;
            default:
                break;
        }
        // 重新加载tableview数据
        [_tableView reloadData];
        [alertView close];
        // 重新加载输入框默认文本
        [self reloadTextview];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
    // 收回键盘
    [_textView resignFirstResponder];
    // 键盘收回判断
    _isKeyboardShow = NO;
}

- (void) reloadTextview {
    NSMutableDictionary *bookDictionary = [[NSMutableDictionary alloc]init];
    __block NSString *textviewText = [[NSString alloc]initWithFormat:@""];
    bookDictionary = _detialBook.bookReviewInfo;
    [bookDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@"0"]) {
            if ([key isEqualToString:@"bookSummary"]) {
                if ([textviewText isEqualToString:@""]) {
                    textviewText = [textviewText stringByAppendingString:@"简介：不合格"];
                }else {
                    textviewText = [textviewText stringByAppendingString:@"，简介：不合格"];
                }
            }
            if ([key isEqualToString:@"bookTime"]) {
                if ([textviewText isEqualToString:@""]) {
                    textviewText = [textviewText stringByAppendingString:@"时间：不合格"];
                }else {
                    textviewText = [textviewText stringByAppendingString:@"，时间：不合格"];
                }
            }
            if ([key isEqualToString:@"bookName"]) {
                if ([textviewText isEqualToString:@""]) {
                    textviewText = [textviewText stringByAppendingString:@"书名：不合格"];
                }else {
                    textviewText = [textviewText stringByAppendingString:@"，书名：不合格"];
                }
            }
            if ([key isEqualToString:@"bookPicture"]) {
                if ([textviewText isEqualToString:@""]) {
                    textviewText = [textviewText stringByAppendingString:@"封皮：不合格"];
                }else {
                    textviewText = [textviewText stringByAppendingString:@"，封皮：不合格"];
                }
            }
            if ([key isEqualToString:@"bookWriter"]) {
                if ([textviewText isEqualToString:@""]) {
                    textviewText = [textviewText stringByAppendingString:@"作者：不合格"];
                }else {
                    textviewText = [textviewText stringByAppendingString:@"，作者：不合格"];
                }
            }
            if ([key isEqualToString:@"bookPages"]) {
                if ([textviewText isEqualToString:@""]) {
                    textviewText = [textviewText stringByAppendingString:@"页数：不合格"];
                }else {
                    textviewText = [textviewText stringByAppendingString:@"，页数：不合格"];
                }
            }
            if ([key isEqualToString:@"bookPublishers"]) {
                if ([textviewText isEqualToString:@""]) {
                    textviewText = [textviewText stringByAppendingString:@"出版商：不合格"];
                }else {
                    textviewText = [textviewText stringByAppendingString:@"，出版商：不合格"];
                }
            }
            if ([key isEqualToString:@"bookCategory"]) {
                if ([textviewText isEqualToString:@""]) {
                    textviewText = [textviewText stringByAppendingString:@"类别：不合格"];
                }else {
                    textviewText = [textviewText stringByAppendingString:@"，类别：不合格"];
                }
            }
            if ([key isEqualToString:@"bookLanguage"]) {
                if ([textviewText isEqualToString:@""]) {
                    textviewText = [textviewText stringByAppendingString:@"语言：不合格"];
                }else {
                    textviewText = [textviewText stringByAppendingString:@"，语言：不合格"];
                }
            }
            if ([key isEqualToString:@"bookSize"]) {
                if ([textviewText isEqualToString:@""]) {
                    textviewText = [textviewText stringByAppendingString:@"大小：不合格"];
                }else {
                    textviewText = [textviewText stringByAppendingString:@"，大小：不合格"];
                }
            }
        }
    }];
    _textView.text = textviewText;
 }

- (UIView *)createAlertViewWithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 267, 357)];
        
        UILabel *alertTitle = [[UILabel alloc]initWithFrame:CGRectMake(alertView.bounds.size.width / 2 - 50, 10, 100, 20)];
        alertTitle.textAlignment = NSTextAlignmentCenter;
        alertTitle.text = _titleArray[indexPath.row];
        alertTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        [alertView addSubview:alertTitle];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 40, 197, 297)];
        [imageView setImage:[UIImage imageNamed:_detialBook.bookPicture]];
        [alertView addSubview:imageView];
        
        return alertView;
    }else {
        CGSize bookIntroduceSize = [_bookDetialArray[indexPath.row] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300.0f,CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
        // 计算文本高度
        UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 267, bookIntroduceSize.height + 60)];
        
        UILabel *alertTitle = [[UILabel alloc]initWithFrame:CGRectMake(alertView.bounds.size.width / 2 - 50, 10, 100, 20)];
        alertTitle.textAlignment = NSTextAlignmentCenter;
        alertTitle.text = _titleArray[indexPath.row];
        alertTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        [alertView addSubview:alertTitle];
        
        UILabel *alertDetial = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, alertView.bounds.size.width - 20, bookIntroduceSize.height + 20)];
        alertDetial.textAlignment = NSTextAlignmentCenter;
        alertDetial.text = _bookDetialArray[indexPath.row];
        alertDetial.lineBreakMode = NSLineBreakByWordWrapping;                                                                                         // 文字过长时显示全部
        alertDetial.numberOfLines = 0;
        alertDetial.font = [UIFont systemFontOfSize:14];
        [alertView addSubview:alertDetial];
        
        return alertView;

    }
    return nil;
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