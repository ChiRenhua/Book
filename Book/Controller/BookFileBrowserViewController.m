//
//  BookFileBrowserViewController.m
//  Book
//
//  Created by Renhuachi on 2016/11/5.
//  Copyright © 2016年 software. All rights reserved.
//

#import "BookFileBrowserViewController.h"
#import "UIColor+AppConfig.h"
#import "BookDownloadModel.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "IDMPhotoBrowser.h"
#import "ReaderViewController.h"
#import "MBProgressHUD.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size
#define CELL_HEIGHT 50

@interface BookFileBrowserViewController ()<UITableViewDelegate, UITableViewDataSource, ReaderViewControllerDelegate>
@property (nonatomic, assign) BookFileBrowserType type;
@property (nonatomic, assign) BookDownloadStatue downloadStatus;
@property (nonatomic, retain) Book *bookInfo;
@property (nonatomic, retain) UILabel *noDataLable;
@property (nonatomic, retain) UILabel *errorLable;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIActivityIndicatorView *IndicatorView;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSArray *fileArray;
@property (nonatomic, retain) UIProgressView *downLoadProgressView;
@property (nonatomic, strong) UILabel *downloadStatusLable;
@property (nonatomic, strong) NSMutableArray *downloadStatusArray;
@property (nonatomic, strong) NSMutableArray *downloadProgressArray;
@property (nonatomic, retain) MBProgressHUD *mbprogress;
@end

@implementation BookFileBrowserViewController

- (id)initWithBookInfo:(Book *)bookInfo bookFileBrowserType:(BookFileBrowserType)type {
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.type = type;
        self.bookInfo = bookInfo;
        self.noDataLable = [[UILabel alloc] init];
        self.tableView = [[UITableView alloc] init];
        self.fileArray = [[NSArray alloc] init];
        self.downloadStatusArray = [[NSMutableArray alloc] init];
        self.downloadProgressArray = [[NSMutableArray alloc] init];
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _mbprogress = [[MBProgressHUD alloc]initWithView:self.view];                                // 初始化toast
        _mbprogress.delegate = self;                                                                // 设置toast代理为当前类
        [BookDownloadModel sharedInstance].showLoginAlert = ^() {
            [self showLoginView];
        };
        [BookDownloadModel sharedInstance].getBookDataSuccess = ^(NSArray *data) {
            if (data.count == 0) {
                _noDataLable.text = @"暂无数据";
                [_IndicatorView stopAnimating];
                [_noDataLable setHidden:NO];
            }else {
                self.fileArray = data;
                for (int i = 0; i < data.count; i++) {
                    [self.downloadProgressArray addObject:@(0)];
                    [self.downloadStatusArray addObject:@(BookDownloadStatue_UnStart)];
                }
                [self CheckBookFileInLocalFolder];
                [self.view addSubview:self.tableView];
                [_noDataLable setHidden:YES];
                [_IndicatorView stopAnimating];
                [self.tableView reloadData];
            }
        };
        [BookDownloadModel sharedInstance].getBookDataFailed = ^(NSError *error) {
            [_noDataLable setHidden:YES];
            [_IndicatorView stopAnimating];
            [_errorLable setHidden:NO];
        };
        [BookDownloadModel sharedInstance].downloadingBookFileWithProgress = ^(float progress, NSUInteger index) {
            self.downloadStatus = BookDownloadStatue_Downloading;
            [self.downloadProgressArray replaceObjectAtIndex:index withObject:@(progress)];
            [self.tableView reloadData];
        };
        [BookDownloadModel sharedInstance].downloadBookFileComplete = ^(NSUInteger index) {
            [self.downloadStatusArray replaceObjectAtIndex:index withObject:@(BookDownloadStatue_Done)];
            [self.tableView reloadData];
        };
        [BookDownloadModel sharedInstance].downloadBookFileFailed = ^(NSError *error, NSUInteger index) {
            self.downloadStatus = BookDownloadStatue_Failed;
            [self.downloadStatusArray replaceObjectAtIndex:index withObject:@(BookDownloadStatue_Failed)];
            [self.tableView reloadData];
        };
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addIndicatorView];
    [self setNavigationBar];
    [self addErrorLable];
    [self addNoDataLable];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, self.view.bounds.size.width, self.view.bounds.size.height - 65) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self loadBookFileData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - tableView
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (self.type) {
        case BookFileBrowserType_Image:
            return @"图片列表";
            break;
        case BookFileBrowserType_PDF:
            return @"PDF列表";
            break;
        default:
            break;
    }
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fileArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIBookFileListCell"];
    NSDictionary *dic = [self.fileArray objectAtIndex:indexPath.row];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UIBookFileListCell"];
    }else {
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    switch (self.type) {
        case BookFileBrowserType_Image: {
            UIImageView *imagelogo = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 23, 30)];
            imagelogo.image = [UIImage imageNamed:@"jpgLogo.png"];
            [cell.contentView addSubview:imagelogo];
            
            UILabel *imageLable = [[UILabel alloc]initWithFrame:CGRectMake(imagelogo.bounds.size.width + 25, (CELL_HEIGHT - 15) / 2, cell.bounds.size.width / 2 - 20, 15)];
            imageLable.text = [dic objectForKey:@"key"];
            imageLable.font = [UIFont systemFontOfSize:15];
            imageLable.textColor = [UIColor blackColor];
            [cell.contentView addSubview:imageLable];
        }
            break;
        case BookFileBrowserType_PDF: {
             UIImageView *pdflogo = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 23, 30)];
             pdflogo.image = [UIImage imageNamed:@"pdfLogo.png"];
             [cell.contentView addSubview:pdflogo];
             
             UILabel *bookNameLable = [[UILabel alloc]initWithFrame:CGRectMake(pdflogo.bounds.size.width + 25, (CELL_HEIGHT - 15) / 2, cell.bounds.size.width / 2 - 20, 15)];
             bookNameLable.text = [dic objectForKey:@"key"];
             bookNameLable.font = [UIFont systemFontOfSize:15];
             bookNameLable.textColor = [UIColor blackColor];
             [cell.contentView addSubview:bookNameLable];
            
            CGSize textSize = [Utils stringWedith:@"下载" size:15];
             _downloadStatusLable = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width - textSize.width - 10, 0, textSize.width, CELL_HEIGHT)];
            _downloadStatusLable.font = [UIFont systemFontOfSize:15];
            switch ([self.downloadStatusArray[indexPath.row] longValue]) {
                case BookDownloadStatue_UnStart:
                    _downloadStatusLable.textColor = [UIColor bookLableColor];
                    _downloadStatusLable.text = @"下载";
                    break;
                case BookDownloadStatue_Downloading:
                    _downloadStatusLable.textColor = [UIColor bookLableColor];
                    _downloadStatusLable.text = @"...";
                    break;
                case BookDownloadStatue_Failed:
                    _downloadStatusLable.textColor = [UIColor bookRedColor];
                    _downloadStatusLable.text = @"重试";
                    break;
                case BookDownloadStatue_Done:
                    _downloadStatusLable.textColor = [UIColor bookGreenColor];
                    _downloadStatusLable.text = @"查看";
                    break;
                default:
                    break;
            }
             [cell.contentView addSubview:_downloadStatusLable];
             
             _downLoadProgressView = [[UIProgressView alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width / 2, CELL_HEIGHT / 2, SCREEN_BOUNDS.width / 2 - _downloadStatusLable.bounds.size.width - 20, 1)];
            _downLoadProgressView.progress = [self.downloadProgressArray[indexPath.row] floatValue];
            if ([self.downloadStatusArray[indexPath.row] longValue] == BookDownloadStatue_Downloading) {
                [_downLoadProgressView setHidden:NO];
            }else {
                [_downLoadProgressView setHidden:YES];
            }
             [cell.contentView addSubview:_downLoadProgressView];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.type) {
        case BookFileBrowserType_Image: {
            NSMutableArray *imageURLArray = [[NSMutableArray alloc]init];
            [self.fileArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = (NSDictionary *)obj;
                NSString *url = [NSString stringWithFormat:@"%@/bookmgyun/%@", [Utils getServerAddress], dic[@"value"]];
                NSString *UTF8url = [Utils UTF8URL:url];
                NSURL *bookImageUrl = [NSURL URLWithString:UTF8url];
                [imageURLArray addObject:bookImageUrl];
            }];
            
            NSMutableArray *photos = [NSMutableArray new];
            
            for (int i = 0; i < imageURLArray.count; i++) {
                IDMPhoto *photo = [IDMPhoto photoWithURL:imageURLArray[i]];
                photo.caption = self.fileArray[i][@"key"];
                [photos addObject:photo];
            }
            
            IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
            browser.displayArrowButton = YES;
            browser.displayCounterLabel = YES;
            browser.displayToolbar = NO;
            [browser setInitialPageIndex:indexPath.row];
            [self presentViewController:browser animated:YES completion:nil];
            
        }
            break;
        case BookFileBrowserType_PDF: {
            switch ([self.downloadStatusArray[indexPath.row] longValue]) {
                case BookDownloadStatue_UnStart: {
                    [self downLoadBookFile:indexPath];
                }
                    break;
                case BookDownloadStatue_Downloading: {
                    
                }
                    break;
                case BookDownloadStatue_Done: {
                    [self openPDFFileWithIndex:indexPath];
                }
                    break;
                case BookDownloadStatue_Failed: {
                    [self downLoadBookFile:indexPath];
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
- (void)openPDFFileWithIndex:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.fileArray[indexPath.row];
    NSString *bookFile = dic[@"key"];
    NSString *filePath = [[BookDownloadModel sharedInstance] getBookDownloadPathWithBookID:self.bookInfo.bookID];
    NSString * bookFilePath = [NSString stringWithFormat:@"%@/%@",filePath,bookFile];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:bookFilePath]) {
        [self.downloadStatusArray replaceObjectAtIndex:indexPath.row withObject:@(BookDownloadStatue_UnStart)];
        [self.tableView reloadData];
        [self showToastWithMessage:@"文件损坏，请重新下载"];
    }else {
        ReaderDocument *document = [ReaderDocument withDocumentFilePath:bookFilePath password:nil];
        
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        readerViewController.delegate = self;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:readerViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)downLoadBookFile:(NSIndexPath *)indexPath {
    [_downLoadProgressView setHidden:NO];
    NSDictionary *dic = self.fileArray[indexPath.row];
    NSString *url = [NSString stringWithFormat:@"%@/bookmgyun/%@", [Utils getServerAddress], dic[@"value"]];
    NSString *UTF8url = [Utils UTF8URL:url];
    NSURL *bookFileUrl = [NSURL URLWithString:UTF8url];
    [[BookDownloadModel sharedInstance] downloadBookFileWithBookInfo:self.bookInfo url:bookFileUrl indexPath:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SCREEN_BOUNDS.height / 20;
}

#pragma mark - NavigationBar
- (void)setNavigationBar {
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.width, 65)];
    navigationBar.barTintColor = [UIColor bookAppColor];
    //创建UINavigationItem
    UINavigationItem * navigationBarTitle;
    switch (self.type) {
        case BookFileBrowserType_Image:
            navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"图片"];
            break;
        case BookFileBrowserType_PDF:
            navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"PDF"];
            break;
        default:
            break;
    }
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.view addSubview: navigationBar];
    //创建UIBarButton 可根据需要选择适合自己的样式
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    navigationBarTitle.leftBarButtonItem = leftBarItem;
    leftBarItem.tintColor = [UIColor whiteColor];
    [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
}

- (void)cancle {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
// 添加菊花
- (void)addIndicatorView {
    _IndicatorView = [[UIActivityIndicatorView alloc]init];
    _IndicatorView.center = CGPointMake(SCREEN_BOUNDS.width/2, SCREEN_BOUNDS.height/2);
    _IndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_IndicatorView];
    [_IndicatorView startAnimating];
}

- (void)addNoDataLable {
    _noDataLable = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width/2 - 100, SCREEN_BOUNDS.height/2 - 25, 200, 50)];
    _noDataLable.textColor = [UIColor grayColor];
    _noDataLable.text = @"暂无数据!";
    _noDataLable.textColor = [UIColor bookLableColor];
    _noDataLable.textAlignment = NSTextAlignmentCenter;
    _noDataLable.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:_noDataLable];
    [_noDataLable setHidden:YES];
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
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadBookFileData)];
    [_errorLable addGestureRecognizer:tapGesture];
    [self.view addSubview:_errorLable];
    [_errorLable setHidden:YES];
}

- (void)loadBookFileData {
    [_IndicatorView startAnimating];
    [_errorLable setHidden:YES];
    switch (self.type) {
        case BookFileBrowserType_Image:
            [[BookDownloadModel sharedInstance] getBookImageListWithBookInfo:_bookInfo];
            break;
        case BookFileBrowserType_PDF:
            [[BookDownloadModel sharedInstance] getBookFileListWithBookInfo:_bookInfo];
            break;
        default:
            break;
    }
}

- (void)showLoginView {
    UIAlertController *loginAlert = [UIAlertController alertControllerWithTitle:@"错误!" message:@"登录态失效，请重新登陆!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        [self presentViewController:self.appDelegate.loginVC animated:YES completion:nil];
    }];
    UIAlertAction *calcleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    [loginAlert addAction:loginAction];
    [loginAlert addAction:calcleAction];
    [self presentViewController:loginAlert animated:YES completion:nil];
}

- (void)CheckBookFileInLocalFolder {
    for (int i = 0; i < self.fileArray.count; i++) {
        NSDictionary *dic = self.fileArray[i];
        NSString *bookFile = dic[@"key"];
        NSString *filePath = [[BookDownloadModel sharedInstance] getBookDownloadPathWithBookID:self.bookInfo.bookID];
        NSString * bookFilePath = [NSString stringWithFormat:@"%@/%@",filePath,bookFile];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:bookFilePath]) {
            [self.downloadProgressArray replaceObjectAtIndex:i withObject:@(1)];
            [self.downloadStatusArray replaceObjectAtIndex:i withObject:@(BookDownloadStatue_Done)];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - PDFReader

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Progress
- (void)showToastWithMessage:(NSString *)msg{
    _mbprogress.mode = MBProgressHUDModeText;                                                       // 设置toast的样式为文字
    _mbprogress.label.text = NSLocalizedString(msg, @"HUD message title");                          // 设置toast上的文字
    [self.view addSubview:_mbprogress];                                                             // 将toast添加到view中
    [_mbprogress showAnimated:YES];                                                                 // 显示toast
    [_mbprogress hideAnimated:YES afterDelay:1.0];                                                  // 1.0秒后销毁toast
}

@end
