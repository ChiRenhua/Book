//
//  BookReviewViewController.m
//  Book
//
//  Created by Dreamylife on 16/4/20.
//  Copyright © 2016年 software. All rights reserved.
//

#import "BookReviewViewController.h"
#import "RDRGrowingTextView.h"
#import "UserInfoModel.h"
#import "BookReviewModel.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size
static NSString * const CellIdentifier = @"cell";
@interface BookReviewViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (retain,nonatomic) Book *detialBook;
@property (retain,strong) UITableView *tableView;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) RDRGrowingTextView *textView;
@property (nonatomic, assign) BOOL isKeyboardShow;
@property (nonatomic, retain) UIActivityIndicatorView *IndicatorView;
@property (nonatomic, retain) UILabel *errorLable;
@property (nonatomic, copy) NSMutableArray *reviewkey;
@property (nonatomic, copy) NSMutableArray *reviewvalue;
@property (nonatomic, copy) NSMutableArray *reviewkey_SD;
@property (nonatomic, copy) NSMutableArray *reviewvalue_SD;
@property (nonatomic, copy) NSMutableArray *reviewResult_SD;
@property(retain,nonatomic) MBProgressHUD *mbprogress;
@property (nonatomic, strong) AppDelegate *reviewDelegate;

@end

@implementation BookReviewViewController

- (id)init:(Book *) book{
    if (self = [super init]) {
        _reviewDelegate = [[UIApplication sharedApplication]delegate];
        _reviewkey_SD = [[NSMutableArray alloc]init];
        _reviewvalue_SD = [[NSMutableArray alloc]init];
        _reviewResult_SD = [[NSMutableArray alloc]init];
        _detialBook = [[Book alloc]init];
        _detialBook = book;
        _mbprogress = [[MBProgressHUD alloc]initWithView:self.view];
        _mbprogress.delegate = self;
        [BookReviewModel sharedInstance].updataReviewView = ^(NSMutableArray *key,NSMutableArray *value){
            _reviewkey = key;
            _reviewvalue = value;
            [_IndicatorView removeFromSuperview];
            [_errorLable setHidden:YES];
            [self saveDictoinary];
            [_tableView reloadData];
        };
        [BookReviewModel sharedInstance].showLoginView = ^(){
            UIAlertController *loginAlert = [UIAlertController alertControllerWithTitle:@"错误!" message:@"登录态失效，请重新登陆!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
                [self presentViewController:_reviewDelegate.loginVC animated:YES completion:nil];
            }];
            UIAlertAction *calcleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                
            }];
            [loginAlert addAction:loginAction];
            [loginAlert addAction:calcleAction];
            [self presentViewController:loginAlert animated:YES completion:nil];
            [_IndicatorView removeFromSuperview];
            [_errorLable setHidden:NO];
        };
        [BookReviewModel sharedInstance].noBookInfo = ^(NSString *error){
            UIAlertController *loginAlert = [UIAlertController alertControllerWithTitle:@"错误!" message:error preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *calcleAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [loginAlert addAction:calcleAction];
            [self presentViewController:loginAlert animated:YES completion:nil];
        };
        [BookReviewModel sharedInstance].failedLoadData = ^(NSString *error){
            [_IndicatorView removeFromSuperview];
            [_errorLable setHidden:NO];
        };
        [BookReviewModel sharedInstance].submitSuccess = ^(){
            [self showToastWithMessage:@"提交成功"];
            [self performSelector:@selector(cancle) withObject:nil afterDelay:1.0f];
        };
        [BookReviewModel sharedInstance].submitFailed = ^(){
            [self showToastWithMessage:@"提交失败!请稍后重试!"];
        };
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // 添加NavigationBar
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, self.view.bounds.size.width, self.view.bounds.size.height - 100) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setNavigationBar];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    [self.view addSubview:_tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self addIndicatorView];
    [self addErrorLable];
    if ([_detialBook.bookState isEqualToString:@"审核中"]) {
        NSMutableArray *array = [[BookReviewModel sharedInstance]getBookReviewDataToLocalWithBookISBN:_detialBook.isbn];
        if (array == nil) {
            [self getData];
        }else {
            for (int i = 0; i < [array count]; i++) {
                [_reviewkey_SD addObject:array[i][@"key"]];
                [_reviewvalue_SD addObject:array[i][@"value"]];
                [_reviewResult_SD addObject:array[i][@"result"]];
            }
            [_IndicatorView removeFromSuperview];
            [_tableView reloadData];
        }
    }else if ([_detialBook.bookState isEqualToString:@"待审核"]) {
        [self getData];
    }
}
// 数据加载失败lable
- (void)addErrorLable {
    _errorLable = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_BOUNDS.height/2 - 25, SCREEN_BOUNDS.width, 50)];
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
// lable点击事件
- (void)onClickErrorLable {
    [_errorLable setHidden:YES];
    [self addIndicatorView];
    [self getData];
}
// 添加菊花
- (void)addIndicatorView {
    _IndicatorView = [[UIActivityIndicatorView alloc]init];
    _IndicatorView.center = CGPointMake(SCREEN_BOUNDS.width/2, SCREEN_BOUNDS.height/2);
    _IndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_IndicatorView];
    [_IndicatorView startAnimating];
}
// 服务器拉取数据
- (void)getData {
    NSString *url = [NSString stringWithFormat:@"getBookAllInfo.serv?username=%@&sessionid=%@&bookid=%@",[[UserInfoModel sharedInstance]getUserName],[[UserInfoModel sharedInstance]getUserSessionid],_detialBook.bookID];
    [[BookReviewModel sharedInstance]getBookReviewDataToLocalWithURL:url];
}
// 首次加载保存
- (void)saveDictoinary {
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSString *book_image_url = [_detialBook.coverPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dic setObject:@"封皮" forKey:@"key"];
    [dic setObject:book_image_url forKey:@"value"];
    [dic setObject:@"1" forKey:@"result"];
    [_reviewkey_SD addObject:@"封皮"];
    [_reviewvalue_SD addObject:book_image_url];
    [_reviewResult_SD addObject:@"1"];
    [array addObject:dic];
    for (int i = 0; i < [_reviewkey count]; i++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:_reviewkey[i] forKey:@"key"];
        [dic setObject:_reviewvalue[i] forKey:@"value"];
        [dic setObject:@"1" forKey:@"result"];
        [_reviewkey_SD addObject:_reviewkey[i]];
        [_reviewvalue_SD addObject:_reviewvalue[i]];
        [_reviewResult_SD addObject:@"1"];
        [array addObject:dic];
    }
    [[BookReviewModel sharedInstance]addBookReviewDataToLocalWithBookISBN:_detialBook.isbn Array:array];
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
    
    [_toolbar addConstraint:[NSLayoutConstraint constraintWithItem:_toolbar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:90.0f]];
    [self resetTextfied];
    return _toolbar;
}
#pragma mark 提交按钮点击事件
- (void)commitButtonAction {
    // 键盘收回判断
    _isKeyboardShow = NO;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"审核信息" message:_textView.text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSString *pendingResultText = [[NSString alloc]init];
        if ([_textView.text isEqualToString:@""]) {
            NSString *url = [NSString stringWithFormat:@"postResult.serv?username=%@&sessionid=%@&step=%@&pass=%@&reason=%@&bookid=%@",[[UserInfoModel sharedInstance]getUserName],[[UserInfoModel sharedInstance]getUserSessionid],_detialBook.step,@"0",@"",_detialBook.bookID];
            [[BookReviewModel sharedInstance]submitReviewDataWithURL:url];
        }else {
            NSString *url = [NSString stringWithFormat:@"postResult.serv?username=%@&sessionid=%@&step=%@&pass=%@&reason=%@&bookid=%@",[[UserInfoModel sharedInstance]getUserName],[[UserInfoModel sharedInstance]getUserSessionid],_detialBook.step,@"1",_textView.text,_detialBook.bookID];
            NSString *book_submit_url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[BookReviewModel sharedInstance]submitReviewDataWithURL:book_submit_url];
        }
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
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    navigationBarTitle.rightBarButtonItem = rightBarItem;
    [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    navigationBarTitle.leftBarButtonItem = leftBarItem;
    [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
}
- (void)save {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancle {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 设置每组标题名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([_reviewkey_SD count]) {
        return @"审核意见";
    }
    return nil;
}
#pragma mark 设置分组标题内容高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SCREEN_BOUNDS.height / 20;
}
#pragma mark 设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_reviewkey_SD.count == 0) {
        return 0;
    }
    return _reviewkey_SD.count;
}
#pragma mark 设置单元格样式和内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reviewcell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reviewcell"];
    }else {
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    // 审核标题
    UILabel *bookReviewTitle = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width / 20, 15, (tableView.bounds.size.width - 60)/2, 20)];
    bookReviewTitle.text = _reviewkey_SD[indexPath.row];
    bookReviewTitle.font = [UIFont systemFontOfSize:17];
    [cell.contentView addSubview:bookReviewTitle];
    // 审核内容
    UILabel *bookReviewSubtitle = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width / 20 + (tableView.bounds.size.width - 60)/2, 15, (tableView.bounds.size.width - 60)/2, 20)];
    bookReviewSubtitle.text = _reviewvalue_SD[indexPath.row];
    bookReviewSubtitle.font = [UIFont systemFontOfSize:17];
    bookReviewSubtitle.textColor = [UIColor grayColor];
    bookReviewSubtitle.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:bookReviewSubtitle];
    // 是否合格
    UIImageView *isPassImage = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.bounds.size.width - 40, 10, 30, 30)];
    isPassImage.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:isPassImage];
    if ([_reviewResult_SD[indexPath.row] isEqualToString:@"1"]) {
        [isPassImage setImage:[UIImage imageNamed:@"pass"]];
    }else if([_reviewResult_SD[indexPath.row] isEqualToString:@"0"]) {
        [isPassImage setImage:[UIImage imageNamed:@"unpass"]];
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
        switch (buttonIndex) {
            case 0:{
                int state = [_reviewResult_SD[indexPath.row]intValue];
                if (state == 1) {
                    _reviewResult_SD[indexPath.row] = @"0";
                }
            }
                break;
            case 1:{
                int state = [_reviewResult_SD[indexPath.row]intValue];
                if (state == 0) {
                    _reviewResult_SD[indexPath.row] = @"1";
                }
            }
                break;
            default:
                break;
        }
        [self resetTextfied];
        [self changeAndSave];
        // 重新加载tableview数据
        [_tableView reloadData];
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
    // 收回键盘
    [_textView resignFirstResponder];
    // 键盘收回判断
    _isKeyboardShow = NO;
}

- (void)resetTextfied {
    NSString *str = [[NSString alloc]init];
    for (int i = 0; i < [_reviewkey_SD count]; i++) {
        if ([_reviewResult_SD[i]intValue] == 0) {
            str = [str stringByAppendingString:_reviewkey_SD[i]];
            str = [str stringByAppendingString:@"：不合格；"];
        }
    }
    [_textView setText:str];
}

// 进行审核时，每次操作都要去保存
- (void)changeAndSave {
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i = 0; i < [_reviewkey_SD count]; i++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:_reviewkey_SD[i] forKey:@"key"];
        [dic setObject:_reviewvalue_SD[i] forKey:@"value"];
        [dic setObject:_reviewResult_SD[i] forKey:@"result"];
        [array addObject:dic];
    }
    [[BookReviewModel sharedInstance]addBookReviewDataToLocalWithBookISBN:_detialBook.isbn Array:array];
}

- (UIView *)createAlertViewWithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 267, 357)];
        
        UILabel *alertTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, alertView.bounds.size.width, 20)];
        alertTitle.textAlignment = NSTextAlignmentCenter;
        alertTitle.text = @"封皮";
        alertTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        [alertView addSubview:alertTitle];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 40, 197, 297)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:_reviewvalue_SD[indexPath.row]] placeholderImage:[UIImage imageNamed:@"default_bookimage"]];
        [alertView addSubview:imageView];
        
        return alertView;
    }else {
        CGSize bookIntroduceSize = [_reviewvalue[indexPath.row - 1] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300.0f,CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
        // 计算文本高度
        UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 267, bookIntroduceSize.height + 60)];
        
        UILabel *alertTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, alertView.bounds.size.width, 20)];
        alertTitle.textAlignment = NSTextAlignmentCenter;
        alertTitle.text = _reviewkey_SD[indexPath.row];
        alertTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        [alertView addSubview:alertTitle];
        
        UILabel *alertDetial = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, alertView.bounds.size.width - 20, bookIntroduceSize.height + 20)];
        alertDetial.textAlignment = NSTextAlignmentCenter;
        alertDetial.text = _reviewvalue_SD[indexPath.row];
        alertDetial.lineBreakMode = NSLineBreakByWordWrapping;                                                                                         // 文字过长时显示全部
        alertDetial.numberOfLines = 0;
        alertDetial.font = [UIFont systemFontOfSize:14];
        [alertView addSubview:alertDetial];
        
        return alertView;

    }
    return nil;
}

- (void)showToastWithMessage:(NSString *)message {
    _mbprogress.mode = MBProgressHUDModeText;                                                       // 设置toast的样式为文字
    _mbprogress.label.text = NSLocalizedString(message, @"HUD message title");                        // 设置toast上的文字
    [self.view addSubview:_mbprogress];                                                             // 将toast添加到view中
    [self.view bringSubviewToFront:_mbprogress];                                                    // 让toast显示在view的最前端
    [_mbprogress showAnimated:YES];                                                                 // 显示toast
    [_mbprogress hideAnimated:YES afterDelay:1.0];                                                  // 1.5秒后销毁toast
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